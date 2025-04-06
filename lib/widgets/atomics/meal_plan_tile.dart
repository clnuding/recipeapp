import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/theme/theme.dart';

class MealPlanTile extends StatelessWidget {
  final Recipe recipe;

  const MealPlanTile({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Container(
        color: theme.colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Image
            Image.network(
              recipe.thumbnailUrl ?? '',
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 40,
                  ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                recipe.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: SpoonSparkTheme.fontWeightSemibold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
