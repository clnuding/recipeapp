import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recipeapp/api/ingredients.dart';
import 'package:recipeapp/api/measurements.dart';
import 'package:recipeapp/api/recipeingredients.dart';
import 'package:recipeapp/api/tags.dart';
import 'package:recipeapp/api/recipes.dart';
import 'package:recipeapp/models/ingredient.dart';
import 'package:recipeapp/models/measurements.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/models/recipeingredients.dart';
import 'package:recipeapp/models/tags.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/ingredients_grid.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late final Future<Recipe> _recipeFuture = _loadRecipe();
  List<Recipeingredients> _ingredients = [];
  List<Ingredient> _allIngredients = [];
  List<Measurements> _allMeasurements = [];
  List<Tags> _allTags = [];
  List<Tags> _tagObjects = [];

  Future<Recipe> _loadRecipe() async {
    final recipe = await fetchRecipeById(widget.recipeId);
    final ingredients = await fetchRecipeIngredientsByRecipeId(widget.recipeId);
    _allIngredients = await fetchIngredients();
    _allMeasurements = await fetchMeasurements();
    _allTags = await fetchTags();

    _ingredients =
        ingredients.map((entry) {
          final name =
              _allIngredients
                  .firstWhere(
                    (ing) => ing.id == entry.ingredientId,
                    orElse: () => Ingredient(id: '', name: 'Unbekannt'),
                  )
                  .name;
          final unit =
              _allMeasurements
                  .firstWhere(
                    (m) => m.id == entry.measurementId,
                    orElse:
                        () => Measurements(id: '', name: '?', abbreviation: ''),
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

    _tagObjects =
        (recipe.tagId ?? []).map((id) {
          return _allTags.firstWhere(
            (tag) => tag.id == id,
            orElse: () => Tags(id: id, name: '?', category: ''),
          );
        }).toList();

    return recipe;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: LogoAppbar(
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: () {}),
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<Recipe>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Fehler beim Laden des Rezepts"));
          }

          final recipe = snapshot.data!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                recipe.thumbnailUrl != null &&
                                        recipe.thumbnailUrl!.isNotEmpty
                                    ? Image.network(
                                      recipe.thumbnailUrl!,
                                      fit: BoxFit.cover,
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
                                    '${recipe.prepTime ?? "-"} Min',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_tagObjects.isNotEmpty)
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
                                      _tagObjects.map((tag) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Text(
                                            tag.name,
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onSurface,
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
                      recipe.title,
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
                      initialServings: recipe.servings ?? 1,
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
                      description:
                          recipe.description ??
                          'Keine Zubereitungsbeschreibung vorhanden',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
