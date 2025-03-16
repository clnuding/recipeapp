import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/base/theme.dart'; // Provides RecipeAppTheme

class RecipeItemList extends StatelessWidget {
  final List<RecordModel> recipes;
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
    final theme = RecipeAppTheme.of(context);
    final Color primaryTextColor = theme.primaryText;
    final Color primaryBackground = theme.primaryBackground;
    final Color borderColor = theme.alternateColor;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(
        child: Text(
          "Error: $error",
          style: TextStyle(color: primaryTextColor),
        ),
      );
    }

    if (recipes.isEmpty) {
      return Center(
        child: Text(
          "No recipes found.",
          style: TextStyle(color: primaryTextColor),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final record = recipes[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // ✅ Left Side: Recipe Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                  child: Image.network(
                    record.data['image'] ??
                        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.0.3&q=80&w=1080',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                // ✅ Right Side: Recipe Name Container
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Navigation or action can be added here
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.alternateColor, // ✅ Background from theme
                        border: Border.all(
                          color: borderColor, // ✅ Use theme color for border
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(7),
                          bottomRight: Radius.circular(7),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        record.data['name'] ?? 'Unnamed Recipe',
                        style: TextStyle(
                          color: primaryTextColor, // ✅ Use theme text color
                          fontSize: 20,
                          fontWeight: FontWeight.w600, // ✅ Improve readability
                        ),
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
