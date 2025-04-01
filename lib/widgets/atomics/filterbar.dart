import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class FilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? leadingIcon;

  const FilterBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusM),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: -4),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: Icon(
              Icons.filter_list_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: SpoonSparkTheme.fontXL,
            ),
          ),
          hintText: 'Search...',
          border: InputBorder.none,
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
