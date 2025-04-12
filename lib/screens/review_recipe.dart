import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/ingredients_grid.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/tag.dart';

class RecipeReviewPage extends StatelessWidget {
  const RecipeReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String recipeName = "Homemade Pasta";
    final String recipeType = "Hauptgang";
    final int portions = 4;
    final String imageUrl =
        "https://images.unsplash.com/photo-1512058564366-18510be2db19";

    final List<String> tags = ['hausgemacht', 'italienisch', 'pasta'];

    final List<Map<String, String>> ingredients = [
      {"name": "Mehl", "amount": "500g"},
      {"name": "Eier", "amount": "3"},
      {"name": "Salz", "amount": "1 TL"},
      {"name": "Olivenöl", "amount": "2 EL"},
    ];

    return Scaffold(
      appBar: const LogoAppbar(actions: []),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: SpoonSparkTheme.spacingL),
              child: Center(
                child: Text(
                  "Schritt 3: Rezept prüfen",
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
            const SizedBox(height: SpoonSparkTheme.spacingM),

            // Image
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpoonSparkTheme.spacingL,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusXXL),
                child: AspectRatio(
                  aspectRatio: 1.9,
                  child: Stack(
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: SpoonSparkTheme.spacingL),

            // Tags
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
                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
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

            // Ingredients
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpoonSparkTheme.spacingL,
              ),
              child: IngredientsGrid(
                initialServings: portions,
                ingredients:
                    ingredients
                        .map(
                          (e) => {
                            'name': e['name']!,
                            'measurement':
                                double.tryParse(
                                  e['amount']!.replaceAll(
                                    RegExp(r'[^\d.]'),
                                    '',
                                  ),
                                ) ??
                                0,
                            'measurementName': e['amount']!.replaceAll(
                              RegExp(r'[\d\s]'),
                              '',
                            ),
                            'group': 'misc',
                          },
                        )
                        .toList(),
              ),
            ),

            const SizedBox(height: SpoonSparkTheme.spacingL),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildSquareIconButton(
                    context,
                    Icons.arrow_back,
                    () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colorScheme.surfaceBright,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 1.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                          backgroundColor: theme.colorScheme.surface
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildSquareIconButton(
                    context,
                    Icons.check,
                    () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(7),
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.onSurface),
        onPressed: onPressed,
      ),
    );
  }
}
