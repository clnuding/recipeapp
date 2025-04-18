import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/state/recipe_wizard_state.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/ingredients_grid.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/models/recipeingredients.dart';
import 'package:recipeapp/models/ingredient.dart';
import 'package:recipeapp/models/measurements.dart';
import 'package:recipeapp/api/recipes.dart';
import 'package:recipeapp/api/recipeingredients.dart';
import 'package:recipeapp/api/ingredients.dart';
import 'package:recipeapp/api/measurements.dart';

class RecipeReviewPage extends StatefulWidget {
  const RecipeReviewPage({super.key});

  @override
  State<RecipeReviewPage> createState() => _RecipeReviewPageState();
}

class _RecipeReviewPageState extends State<RecipeReviewPage> {
  Recipe? _recipe;
  List<Recipeingredients> _ingredients = [];
  List<Ingredient> _allIngredients = [];
  List<Measurements> _allMeasurements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipeData();
  }

  Future<void> _loadRecipeData() async {
    print('📦 Loading recipe from wizard state...');
    try {
      final wizard = Provider.of<RecipeWizardState>(context, listen: false);

      final recipe = Recipe(
        id: wizard.recipeId!,
        title: wizard.title ?? 'Unbenannt',
        description: wizard.description,
        servings: wizard.servings,
        thumbnailUrl: wizard.image?.path,
        creatorId: pb.authStore.model?.id ?? '',
        householdId: pb.authStore.model?.getStringValue('household_id'),
        tagId: wizard.tagIds,
        prepTime: wizard.prepTimeMinutes,
        nutritionAutoCalculated: false,
      );

      // ✅ Fetch details for names
      final allIngredients = await fetchIngredients();
      final allMeasurements = await fetchMeasurements();
      _allIngredients = allIngredients;
      _allMeasurements = allMeasurements;

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
              ingredientId: name, // 🔁 Replace ID with name for display
              measurementId: unit, // 🔁 Replace ID with name for display
              quantity: entry.quantity,
            );
          }).toList();

      setState(() {
        _recipe = recipe;
        _ingredients = enrichedIngredients;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Failed to load data from wizard: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizard = Provider.of<RecipeWizardState>(
      context,
    ); // Access wizard state

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/addIngredient');
        return false;
      },
      child: Scaffold(
        appBar: LogoAppbar(
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/addIngredient');
            },
          ),
          actions: [],
        ),
        body:
            _isLoading || _recipe == null
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
                            child: AspectRatio(
                              aspectRatio: 1.9,
                              child:
                                  wizard.image != null
                                      ? Image.file(
                                        wizard.image!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )
                                      : Container(
                                        color: theme.colorScheme.surfaceBright,
                                        child: const Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        const SizedBox(height: SpoonSparkTheme.spacingM),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpoonSparkTheme.spacingL,
                          ),
                          child: Text(
                            _recipe!.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: SpoonSparkTheme.spacingL),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpoonSparkTheme.spacingL,
                          ),
                          child: IngredientsGrid(
                            initialServings: _recipe!.servings ?? 1,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    const stepLabels = ["Rezept", "Zutaten", "Prüfen"];
    const int activeIndex = 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingL),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              final isActive = index == activeIndex;
              final isCompleted = index < activeIndex;
              final Color barColor =
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
                      mainAxisSize: MainAxisSize.min,
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
        ],
      ),
    );
  }
}
