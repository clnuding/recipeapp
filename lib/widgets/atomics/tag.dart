import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class Tag extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const Tag({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = theme.colorScheme.surfaceBright;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SpoonSparkTheme.spacingM, // wider horizontal padding
          vertical:
              SpoonSparkTheme
                  .spacingL, // increased vertical padding for taller tag
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? defaultBackgroundColor,
          borderRadius: BorderRadius.circular(
            SpoonSparkTheme.radiusL,
          ), // less rounded
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: theme.colorScheme.onSurfaceVariant,
                size: SpoonSparkTheme.fontM,
              ),
            if (icon != null) const SizedBox(width: SpoonSparkTheme.spacingXS),
            Text(
              text,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
