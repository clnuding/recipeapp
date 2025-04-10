import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/theme/theme.dart';

class RecipeItemList extends StatelessWidget {
  final List<Recipe> recipes;
  final String error;
  final bool isLoading;

  const RecipeItemList({
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
      return Center(child: Text("No recipes found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusM),
            ),
            child: Row(
              children: [
                // ✅ Recipe image thumbnail
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                  child: Image.network(
                    recipe.thumbnailUrl ?? 'https://via.placeholder.com/80',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.broken_image,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          size: 40,
                        ),
                  ),
                ),

                // ✅ Title and interaction
                Expanded(
                  child: InkWell(
                    onTap: () => HapticFeedback.lightImpact(),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceBright,
                        border: Border.all(color: theme.colorScheme.onPrimary),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(7),
                          bottomRight: Radius.circular(7),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        recipe.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
