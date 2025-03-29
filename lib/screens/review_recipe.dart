import 'package:flutter/material.dart';
import 'package:recipeapp/base/theme.dart'; // Provides RecipeAppTheme

class RecipeReviewPage extends StatelessWidget {
  const RecipeReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme.of(context);

    // ✅ Test Data (Replace with real data later)
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
      backgroundColor: Colors.white, // ✅ Full-screen white background
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Page Title (Now Matches the Format of Other Pages)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  "Step 3: Review Recipe", // ✅ Updated Title
                  style: theme.title1.copyWith(color: theme.primaryText),
                ),
              ),
            ),

            // ✅ Recipe Image + Info (Merged)
            _buildRecipeHeader(
              theme,
              imageUrl,
              recipeName,
              recipeType,
              portions,
            ),

            // ✅ Recipe Details (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Ingredients List
                    _buildReviewSection(
                      theme,
                      title: "Ingredients",
                      content: Column(
                        children:
                            ingredients
                                .map(
                                  (ingredient) => _buildReviewRow(
                                    ingredient["name"]!,
                                    ingredient["amount"]!,
                                    theme,
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

            // ✅ Bottom Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // ✅ Back Button
                  _buildSquareIconButton(
                    theme,
                    Icons.arrow_back,
                    () => Navigator.pop(context),
                  ),

                  const SizedBox(width: 8),

                  // ✅ Progress Bar (Step 3 Active)
                  Expanded(child: _buildProgressBar(theme, 3)),

                  const SizedBox(width: 8),

                  // ✅ Finish Button
                  _buildSquareIconButton(theme, Icons.check, () {
                    // Implement finish functionality later
                    Navigator.pop(context);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ **Merged Recipe Header (Image + Name, Type, Portions)**
  Widget _buildRecipeHeader(
    RecipeAppTheme theme,
    String imageUrl,
    String name,
    String type,
    int portions,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ), // ✅ Keeps spacing consistent
      decoration: BoxDecoration(
        color: theme.alternateColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Recipe Image (Full Width)
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.network(
              imageUrl,
              height: 120, // ✅ Keeps a clean and modern look
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Recipe Info (Inside the Same Box)
          _buildReviewRow("Name:", name, theme),
          _buildReviewRow("Type:", type, theme),
          _buildReviewRow("Portions:", "$portions", theme),
        ],
      ),
    );
  }

  /// ✅ **Reusable Section Builder**
  Widget _buildReviewSection(
    RecipeAppTheme theme, {
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.alternateColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.title1.copyWith(color: theme.primaryText)),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  /// ✅ **Reusable Row for Data**
  Widget _buildReviewRow(String label, String value, RecipeAppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.bodyText1.copyWith(
              color: theme.primaryText.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: theme.bodyText1.copyWith(color: theme.primaryText),
          ),
        ],
      ),
    );
  }

  /// ✅ **Progress Circle**
  Widget _buildProgressCircle(RecipeAppTheme theme, bool isActive) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor : Colors.transparent,
        border: Border.all(color: theme.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  /// ✅ **Progress Line Between Circles**
  Widget _buildProgressLine(RecipeAppTheme theme) {
    return Container(width: 20, height: 3, color: theme.primaryColor);
  }

  /// ✅ **Progress Bar**
  Widget _buildProgressBar(RecipeAppTheme theme, int activeStep) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.alternateColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressCircle(theme, activeStep >= 1),
          _buildProgressLine(theme),
          _buildProgressCircle(theme, activeStep >= 2),
          _buildProgressLine(theme),
          _buildProgressCircle(theme, activeStep >= 3),
        ],
      ),
    );
  }

  /// ✅ **Reusable Square Icon Button**
  Widget _buildSquareIconButton(
    RecipeAppTheme theme,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: theme.alternateColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.primaryColor, size: 24),
        onPressed: onPressed,
      ),
    );
  }
}
