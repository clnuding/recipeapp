import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recipeapp/api/recipes.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/ingredients_grid.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/tag.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Recipe> recipe;
  final String? cookingTime = "30";
  final List<String> tags = ['french', 'dinner', 'vegetarian'];

  @override
  void initState() {
    super.initState();
    recipe = _fetchRecipeById();
  }

  // Async function to fetch manga details
  Future<Recipe> _fetchRecipeById() async {
    final recipe = await fetchRecipeById(widget.recipeId);
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
        future: recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "No Recipe Details Found.",
                style: theme.textTheme.headlineSmall,
              ),
            );
          }
          Recipe recipe = snapshot.data!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: SpoonSparkTheme.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpoonSparkTheme.spacing16,
                      vertical: SpoonSparkTheme.spacing4,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusXXLarge,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.9,
                        child: Stack(
                          children: [
                            // Original Image
                            Image.network(
                              recipe.thumbnailUrl ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),

                            // Cooking Time Tag (Only shown if time is not null)
                            if (recipe.cookingTime != null)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Tag(
                                  icon: Icons.access_time,
                                  text: '${recipe.cookingTime} min',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SpoonSparkTheme.spacing16),

                  // Horizontally Scrollable Genres Section
                  SizedBox(
                    height: SpoonSparkTheme.spacing24,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpoonSparkTheme.spacing16,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(
                            SpoonSparkTheme.radiusMedium,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ), // Glass effect
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.8,
                                ), // Light transparent white
                                borderRadius: BorderRadius.circular(
                                  SpoonSparkTheme.radiusXXLarge,
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                right: SpoonSparkTheme.spacing8,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpoonSparkTheme.spacing12,
                                vertical: SpoonSparkTheme.spacing4,
                              ),
                              child: Text(
                                tags.isNotEmpty ? tags[index] : "N/A",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: SpoonSparkTheme.spacing24),
                  IngredientsGrid(
                    initialServings: 2,
                    ingredients: [
                      {
                        'name': 'Tomato',
                        'measurement': 2.0,
                        'measurementName': 'pcs',
                        'group': 'vegetables',
                      },
                      {
                        'name': 'Chicken Breast',
                        'measurement': 150.0,
                        'measurementName': 'g',
                        'group': 'meat',
                      },
                      {
                        'name': 'Cheese',
                        'measurement': 50.0,
                        'measurementName': 'g',
                        'group': 'dairy',
                      },
                      {
                        'name': 'Tomato',
                        'measurement': 2.0,
                        'measurementName': 'pcs',
                        'group': 'vegetables',
                      },
                      {
                        'name': 'Chicken Breast',
                        'measurement': 150.0,
                        'measurementName': 'g',
                        'group': 'meat',
                      },
                      {
                        'name': 'Brauner Champignon',
                        'measurement': 50.0,
                        'measurementName': 'g',
                        'group': 'dairy',
                      },
                    ],
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
