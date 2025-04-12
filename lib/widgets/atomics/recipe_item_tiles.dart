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
          borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusS),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 234, 234, 234),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Image section
              Expanded(
                flex: 5,
                child: Image.network(
                  recipe.thumbnailUrl ?? 'https://via.placeholder.com/150',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        size: 50,
                      ),
                ),
              ),

              // ✅ Title section
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(4.0),
                  width: double.infinity,
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
      ),
    );
  }
}
