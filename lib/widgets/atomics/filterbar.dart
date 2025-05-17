import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:recipeapp/theme/theme.dart';

class FilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? leadingIcon;
  final VoidCallback? onFilterPressed;
  final bool isFilterActive; // ✅ NEW

  const FilterBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.leadingIcon,
    this.onFilterPressed,
    this.isFilterActive = false, // ✅ default false
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
          suffixIcon: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.filter_list,
                ), // 👈 use standard filter icon
                onPressed: onFilterPressed,
              ),
              if (isFilterActive)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),

          suffixIconColor: theme.colorScheme.primary,
          hintText: 'Search...',
        ),
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
