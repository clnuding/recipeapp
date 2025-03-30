import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class RecipeReviewPage extends StatelessWidget {
  const RecipeReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String recipeName = "Homemade Pasta";
    final String recipeType = "Main Course";
    final int portions = 4;
    final String imageUrl =
        "https://images.unsplash.com/photo-1512058564366-18510be2db19";

    final List<Map<String, String>> ingredients = [
      {"name": "Flour", "amount": "500g"},
      {"name": "Eggs", "amount": "3"},
      {"name": "Salt", "amount": "1 tsp"},
      {"name": "Olive Oil", "amount": "2 tbsp"},
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: SpoonSparkTheme.spacing16,
              ),
              child: Center(
                child: Text(
                  "Step 3: Review Recipe",
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),

            _buildRecipeHeader(
              context,
              imageUrl,
              recipeName,
              recipeType,
              portions,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReviewSection(
                      context,
                      title: "Ingredients",
                      content: Column(
                        children:
                            ingredients
                                .map(
                                  (ingredient) => _buildReviewRow(
                                    context,
                                    ingredient["name"]!,
                                    ingredient["amount"]!,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

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
                  Expanded(child: _buildProgressBar(context, 3)),
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

  Widget _buildRecipeHeader(
    BuildContext context,
    String imageUrl,
    String name,
    String type,
    int portions,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          _buildReviewRow(context, "Name:", name),
          _buildReviewRow(context, "Type:", type),
          _buildReviewRow(context, "Portions:", "$portions"),
        ],
      ),
    );
  }

  Widget _buildReviewSection(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildReviewRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(BuildContext context, bool isActive) {
    final theme = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : Colors.transparent,
        border: Border.all(color: theme.colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  Widget _buildProgressLine(BuildContext context) {
    final theme = Theme.of(context);
    return Container(width: 20, height: 3, color: theme.colorScheme.primary);
  }

  Widget _buildProgressBar(BuildContext context, int activeStep) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressCircle(context, activeStep >= 1),
          _buildProgressLine(context),
          _buildProgressCircle(context, activeStep >= 2),
          _buildProgressLine(context),
          _buildProgressCircle(context, activeStep >= 3),
        ],
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
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.primary, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}
