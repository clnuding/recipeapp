import 'package:flutter/material.dart';
import 'package:recipeapp/base/theme.dart';

class GroceriesPage extends StatelessWidget {
  const GroceriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = RecipeAppTheme.of(context).primaryText;

    return Container(
      color: Colors.transparent, // Use transparent to show the underlying background.
      child: Center(
        child: Text(
          "Groceries Page",
          style: TextStyle(
            color: textColor,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
