import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/tag.dart';

final List<Recipe> recipes = [
  Recipe(
    id: '1',
    title: 'Spaghetti',
    householdId: "123",
    description: "This is a description",
    thumbnailUrl:
        'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?q=80&w=500&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    creatorId: "1",
  ),
  Recipe(
    id: '2',
    title: 'Tacos',
    householdId: "123",
    thumbnailUrl:
        'https://images.unsplash.com/photo-1504544750208-dc0358e63f7f?q=80&w=500&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    creatorId: "1",
  ),
  Recipe(
    id: '3',
    title: 'Pizza',
    householdId: "123",
    description: "This is a description",
    thumbnailUrl:
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGl6emF8ZW58MHx8MHx8fDA%3D',
    creatorId: "1",
  ),
  Recipe(
    id: '4',
    title: 'Bulgur Buddah Bowl',
    householdId: "123",
    thumbnailUrl:
        'https://images.unsplash.com/photo-1600713529234-2ead3b91c6eb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8QnVsZ3VyfGVufDB8fDB8fHww',
    creatorId: "1",
  ),
];

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
                  children: [
                    Tag(
                      text: Text(
                        "Lunch".toLowerCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: SpoonSparkTheme.fontXS,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.tertiary,
                    ),
                    const SizedBox(width: SpoonSparkTheme.spacingS),
                    Tag(
                      text: Text(
                        "Vegan".toLowerCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: SpoonSparkTheme.fontXS,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.tertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
