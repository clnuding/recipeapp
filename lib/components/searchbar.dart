import 'package:flutter/material.dart';
import 'package:recipeapp/theme.dart';

class CustomSearchbar extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const CustomSearchbar({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<RecipeColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: themeColors.accentSecondary!.withValues(
          alpha: 0.7,
        ), // Background color
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: themeColors.accent!.withValues(alpha: 0.6),
          ),
          suffixIcon: Icon(
            icon,
            color: themeColors.accent!.withValues(alpha: 0.6),
          ),
          border: InputBorder.none, // Removes border lines
          enabledBorder: InputBorder.none, // Removes border when not focused
          focusedBorder: InputBorder.none, // Removes bo
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        style: TextStyle(color: themeColors.accent, fontSize: 16),
        cursorColor: themeColors.accentSecondary!.withValues(alpha: 1.0),
      ),
    );
  }
}
