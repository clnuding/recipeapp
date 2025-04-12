import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusM),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(MingCute.settings_6_line),
            onPressed: () {},
          ),
          suffixIconColor: theme.colorScheme.primary,
          hintText: 'Search...',
        ),
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
