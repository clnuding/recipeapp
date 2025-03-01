import 'package:flutter/material.dart';
import 'package:recipeapp/base/theme.dart';

class MealPlanningPage extends StatelessWidget {
  const MealPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use your custom primaryText for text color.
    final textColor = RecipeAppTheme.of(context).primaryText;

    return Container(
      // Set the background to transparent so the AppScaffold's background shows.
      color: Colors.transparent,
      child: Center(
        child: Text(
          "Meal Planning Page New",
          style: TextStyle(color: textColor, fontSize: 24),
        ),
      ),
    );
  }
}
