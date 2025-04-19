import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/tag.dart';

class RecipeSwipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeSwipeCard(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(SpoonSparkTheme.radiusM),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recipe.thumbnailUrl ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(SpoonSparkTheme.spacingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: SpoonSparkTheme.spacingS),
                Row(
                  children:
                      recipe.tags.isNotEmpty
                          ? recipe.tags
                              .map(
                                (tag) => Tag(
                                  text: Text(
                                    tag.name,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontSize: SpoonSparkTheme.fontXS,
                                    ),
                                  ),
                                  backgroundColor: theme.colorScheme.tertiary,
                                ),
                              )
                              .toList()
                          : [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
