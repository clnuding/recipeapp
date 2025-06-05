import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/screens/add_ingredient.dart';
import 'package:recipeapp/screens/recipes.dart';
import 'package:recipeapp/state/recipe_wizard_state.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/ingredients_grid.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/models/recipeingredients.dart';
import 'package:recipeapp/models/ingredient.dart';
import 'package:recipeapp/models/measurements.dart';
import 'package:recipeapp/models/tags.dart';
import 'package:recipeapp/api/ingredients.dart';
import 'package:recipeapp/api/measurements.dart';
import 'package:recipeapp/api/tags.dart';
import 'package:image/image.dart' as img;

class RecipeReviewPage extends StatefulWidget {
  const RecipeReviewPage({super.key});

  @override
  State<RecipeReviewPage> createState() => _RecipeReviewPageState();
}

class _RecipeReviewPageState extends State<RecipeReviewPage> {
  List<Recipeingredients> _ingredients = [];
  List<Ingredient> _allIngredients = [];
  List<Measurements> _allMeasurements = [];
  List<Tags> _allTags = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadRecipeData();
  }

  Future<MultipartFile> _prepareResizedImage(File file) async {
    final originalBytes = await file.readAsBytes();
    final decoded = img.decodeImage(originalBytes);

    if (decoded == null) {
      throw Exception("Could not decode image.");
    }

    final resized = img.copyResize(
      decoded,
      width: decoded.width > 800 ? 800 : decoded.width,
    );

    final compressed = img.encodeJpg(resized, quality: 85); // quality: 0-100

    return MultipartFile.fromBytes(
      'thumbnail',
      compressed,
      filename: 'thumbnail.jpg',
    );
  }

  Future<bool> _showDiscardChangesDialog() async {
    final theme = Theme.of(context);
    bool shouldLeave = false;

    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: theme.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 40,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text("Änderungen verwerfen?", style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                "Wenn du abbrichst, gehen deine Eingaben verloren.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  shouldLeave = true;
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text("Ja, verwerfen"),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Abbrechen"),
              ),
            ],
          ),
        );
      },
    );

    return shouldLeave;
  }

  Future<void> _loadRecipeData() async {
    try {
      final wizard = Provider.of<RecipeWizardState>(context, listen: false);
      final allIngredients = await fetchIngredients();
      final allMeasurements = await fetchMeasurements();
      final allTags = await fetchTags();

      _allIngredients = allIngredients;
      _allMeasurements = allMeasurements;
      _allTags = allTags;

      final enrichedIngredients =
          wizard.ingredients.map((entry) {
            final name =
                allIngredients
                    .firstWhere(
                      (ing) => ing.id == entry.ingredientId,
                      orElse: () => Ingredient(id: '', name: 'Unbekannt'),
                    )
                    .name;

            final unit =
                allMeasurements
                    .firstWhere(
                      (m) => m.id == entry.measurementId,
                      orElse:
                          () =>
                              Measurements(id: '', name: '?', abbreviation: ''),
                    )
                    .name;

            return Recipeingredients(
              id: entry.id,
              userId: entry.userId,
              householdId: entry.householdId,
              recipeId: entry.recipeId,
              ingredientId: name,
              measurementId: unit,
              quantity: entry.quantity,
            );
          }).toList();

      final tagObjects =
          wizard.tagIds
              .map(
                (id) => _allTags.firstWhere(
                  (tag) => tag.id == id,
                  orElse: () => Tags(id: id, name: '?', category: ''),
                ),
              )
              .toList();

      wizard.setTagObjects(tagObjects);

      setState(() {
        _ingredients = enrichedIngredients;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Failed to load data: $e');
    }
  }

  Future<void> _submitRecipe() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final wizard = Provider.of<RecipeWizardState>(context, listen: false);
    final userId = pb.authStore.model?.id;
    final householdId = pb.authStore.model?.getStringValue('household_id');

    if (userId == null || householdId == null) {
      print('❌ Missing user or household');
      return;
    }

    try {
      String recipeId;

      // ✅ If editing, update instead of creating
      if (wizard.isEditing && wizard.recipeId != null) {
        await pb
            .collection('recipes')
            .update(
              wizard.recipeId!,
              body: {
                'name': wizard.title,
                'instructions': wizard.description,
                'servings': wizard.servings,
                'prep_time_minutes': wizard.prepTimeMinutes,
                'tag_id': wizard.tagIds,
                'weekly_planning': wizard.weeklyPlanning, // ✅ NEW
                'number_of_meals': wizard.numberOfMeals, // ✅ NEW
              },
            );

        // Optional: update thumbnail if changed
        if (wizard.image != null) {
          await pb
              .collection('recipes')
              .update(
                wizard.recipeId!,
                files: [await _prepareResizedImage(File(wizard.image!.path))],
              );
        }

        // ✅ Delete existing recipe ingredients and re-create
        final existingIngredients = await pb
            .collection('recipeIngredients')
            .getFullList(filter: 'recipe_id="${wizard.recipeId!}"');

        for (var ing in existingIngredients) {
          await pb.collection('recipeIngredients').delete(ing.id);
        }

        recipeId = wizard.recipeId!;
      } else {
        // ✅ Create new recipe
        final recipeRecord = await pb
            .collection('recipes')
            .create(
              body: {
                'name': wizard.title,
                'instructions': wizard.description,
                'servings': wizard.servings,
                'prep_time_minutes': wizard.prepTimeMinutes,
                'tag_id': wizard.tagIds,
                'user_id': userId,
                'household_id': householdId,
                'weekly_planning': wizard.weeklyPlanning, // ✅ NEW
                'number_of_meals': wizard.numberOfMeals, // ✅ NEW
              },
              files:
                  wizard.image != null
                      ? [await _prepareResizedImage(File(wizard.image!.path))]
                      : [],
            );

        recipeId = recipeRecord.id;
      }

      // ✅ Create ingredients
      for (final ing in wizard.ingredients) {
        await pb
            .collection('recipeIngredients')
            .create(
              body: {
                'user_id': userId,
                'household_id': householdId,
                'recipe_id': recipeId,
                'ingredient_id': ing.ingredientId,
                'measurement_id': ing.measurementId,
                'quantity': ing.quantity,
              },
            );
      }

      wizard.clear();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main',
          (route) => false,
          arguments: 1, // 👈 Recipes tab index
        );
      }
    } catch (e) {
      print('❌ Error submitting recipe: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizard = Provider.of<RecipeWizardState>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation1, animation2) => AddIngredientPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: LogoAppbar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation1, animation2) => AddIngredientPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close), // cancel icon
              onPressed: () async {
                final shouldLeave = await _showDiscardChangesDialog();
                if (shouldLeave && mounted) {
                  Provider.of<RecipeWizardState>(
                    context,
                    listen: false,
                  ).clear(); // 🧹 Clear wizard state
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main',
                    (route) => false,
                    arguments: 1,
                  );
                }
              },
            ),
          ],
        ),

        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: SpoonSparkTheme.spacingL),
                        _buildStepper(theme),
                        const SizedBox(height: SpoonSparkTheme.spacingL),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpoonSparkTheme.spacingL,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              SpoonSparkTheme.radiusXXL,
                            ),
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.9,
                                  child:
                                      wizard.image != null
                                          ? Image.file(
                                            wizard.image!,
                                            fit: BoxFit.cover,
                                          )
                                          : (wizard.thumbnailFilename != null &&
                                                  wizard.recipeId != null
                                              ? Image.network(
                                                "${pb.baseUrl}/api/files/recipes/${wizard.recipeId}/${wizard.thumbnailFilename!}",
                                                fit: BoxFit.cover,
                                              )
                                              : Container(
                                                color:
                                                    theme
                                                        .colorScheme
                                                        .surfaceBright,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 48,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              )),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.timer,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${wizard.prepTimeMinutes} Min',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (wizard.tagObjects.isNotEmpty)
                                  Positioned(
                                    bottom: 12,
                                    left: 0,
                                    right: 0,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        children:
                                            wizard.tagObjects.map((tag) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.85),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Text(
                                                  tag.name,
                                                  style: TextStyle(
                                                    color:
                                                        theme
                                                            .colorScheme
                                                            .onSurface,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: SpoonSparkTheme.spacingM),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpoonSparkTheme.spacingL,
                          ),
                          child: Text(
                            wizard.title ?? '',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: SpoonSparkTheme.spacingL),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpoonSparkTheme.spacingL,
                          ),
                          child: IngredientsGrid(
                            initialServings: wizard.servings,
                            ingredients:
                                _ingredients
                                    .map(
                                      (e) => {
                                        'name': e.ingredientId,
                                        'measurement': e.quantity,
                                        'measurementName': e.measurementId,
                                        'group': 'misc',
                                      },
                                    )
                                    .toList(),
                            description: wizard.description ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text:
                  wizard.isEditing
                      ? "Rezept aktualisieren"
                      : "Rezept erstellen",
              onPressed: _isSubmitting ? null : _submitRecipe,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    const stepLabels = ["Rezept", "Zutaten", "Prüfen"];
    const int activeIndex = 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingL),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index == activeIndex;
          final isCompleted = index < activeIndex;
          final barColor =
              isActive || isCompleted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceBright;

          BorderRadius borderRadius = BorderRadius.zero;
          if (index == 0) {
            borderRadius = const BorderRadius.horizontal(
              left: Radius.circular(12),
            );
          } else if (index == 2) {
            borderRadius = const BorderRadius.horizontal(
              right: Radius.circular(12),
            );
          }

          return Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: index < 2 ? 6 : 0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stepLabels[index],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (isCompleted)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.check,
                          size: 12,
                          color: theme.colorScheme.primary.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
