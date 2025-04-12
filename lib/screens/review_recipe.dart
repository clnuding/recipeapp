import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/ingredients_grid.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/tag.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';

class RecipeReviewPage extends StatelessWidget {
  const RecipeReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String imageUrl =
        "https://images.unsplash.com/photo-1512058564366-18510be2db19";

    final List<String> tags = ['hausgemacht', 'italienisch', 'pasta'];
    final int portions = 4;

    final List<Map<String, String>> ingredients = [
      {"name": "Mehl", "amount": "500g"},
      {"name": "Eier", "amount": "3"},
      {"name": "Salz", "amount": "1 TL"},
      {"name": "Olivenöl", "amount": "2 EL"},
    ];

    return Scaffold(
      appBar: const LogoAppbar(actions: []),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 45),
        child: PrimaryButton(
          text: "Rezept erstellen",
          onPressed: () {
            // Your final submit action
            Navigator.pushNamed(context, '/main');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              const SizedBox(height: SpoonSparkTheme.spacingL),

              // 🔄 Stepper progress bar
              _buildStepper(theme),
              const SizedBox(height: SpoonSparkTheme.spacingL),

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
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
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

              // 🧾 Ingredients
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    const stepLabels = ["Rezept", "Zutaten", "Prüfen"];
    const int activeIndex = 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingL),
      child: Column(
        children: [
          // Container für Progress Bar
          Row(
            children: List.generate(3, (index) {
              final isActive = index == activeIndex;
              final isCompleted = index < activeIndex;
              final Color barColor =
                  isActive
                      ? theme.colorScheme.primary
                      : isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceBright;

              BorderRadius borderRadius = BorderRadius.zero;
              if (index == 0) {
                borderRadius = const BorderRadius.horizontal(
                  left: Radius.circular(12),
                );
              } else if (index == 2) {
                borderRadius = const BorderRadius.horizontal(
                  right: Radius.circular(12),
                );
              }

              // Jedes Segment
              return Expanded(
                child: Column(
                  children: [
                    Padding(
                      // Abstandsbreite zwischen den Segmenten
                      padding: EdgeInsets.only(right: index < 2 ? 6 : 0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: borderRadius,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Label mit optionalem Häkchen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          stepLabels[index],
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                isActive
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface,
                          ),
                        ),
                        // Häkchen für abgeschlossene Schritte
                        if (isCompleted)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.check,
                              size: 12,
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
