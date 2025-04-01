import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class Tag extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? backgroundColor;

  const Tag({super.key, required this.text, this.icon, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.7,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpoonSparkTheme.spacingS,
        vertical: SpoonSparkTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBackgroundColor,
        borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusL),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: theme.colorScheme.onPrimary,
              size: theme.textTheme.labelMedium?.fontSize,
            ),
          const SizedBox(width: SpoonSparkTheme.spacingXS),
          Text(
            text,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
