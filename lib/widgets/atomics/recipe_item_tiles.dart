import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/screens/recipe_details.dart';
import 'package:recipeapp/theme/theme.dart';

class RecipeItemTiles extends StatelessWidget {
  final List<Recipe> recipes;
  final String error;
  final bool isLoading;

  const RecipeItemTiles({
    super.key,
    required this.recipes,
    required this.error,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(child: Text("Error: $error"));
    }

    if (recipes.isEmpty) {
      return Center(
        child: Text(
          "No recipes found.",
          //style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(
          recipe: recipes[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        RecipeDetailScreen(recipeId: recipes[index].id),
              ),
            );
          },
        );
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeCard({super.key, required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusS),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Image section
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
                child: Image.network(
                  recipe.thumbnailUrl ?? 'https://via.placeholder.com/150',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                        size: 50,
                      ),
                ),
              ),
            ),

            // ✅ Title section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  recipe.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: SpoonSparkTheme.fontWeightSemibold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
