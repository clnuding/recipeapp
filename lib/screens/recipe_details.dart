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
            return Text('Error: \${snapshot.error}');
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
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  const SizedBox(height: SpoonSparkTheme.spacingL),

                  // 🔄 Stepper progress bar
                  //_buildStepper(theme),
                  //const SizedBox(height: SpoonSparkTheme.spacingL),

                  // 🖼️ Image
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
                        child: Stack(
                          children: [
                            // Background image
                            Positioned.fill(
                              child: Image.network(
                                recipe.thumbnailUrl ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            // Title banner (bottom-left)
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    252,
                                    251,
                                    251,
                                  ).withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  recipe.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                            // Duration badge (top-right)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ).withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${recipe.cookingTime ?? "-"} Min.',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: SpoonSparkTheme.spacingL),

                  // 🏷️ Tags
                  SizedBox(
                    height: SpoonSparkTheme.spacingXXL,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpoonSparkTheme.spacingL,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(
                            SpoonSparkTheme.radiusS,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceBright,
                                borderRadius: BorderRadius.circular(
                                  SpoonSparkTheme.radiusXXL,
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                right: SpoonSparkTheme.spacingS,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: SpoonSparkTheme.spacingM,
                                vertical: SpoonSparkTheme.spacingXS,
                              ),
                              child: Text(
                                tags[index],
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
                  const SizedBox(height: SpoonSparkTheme.spacingL),

                  // 🧾 Ingredients
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpoonSparkTheme.spacingL,
                    ),
                    child: IngredientsGrid(
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
