import 'package:flutter/material.dart';
import 'package:recipeapp/base/theme.dart' as CustomTheme;

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = CustomTheme.RecipeAppTheme.of(context).primaryText;

    return Container(
      color: Colors.transparent, // Set background to transparent.
      child: Center(
        child: Text(
          "Account Page",
          style: TextStyle(
            color: textColor,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
