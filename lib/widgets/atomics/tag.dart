import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class Tag extends StatelessWidget {
  final Text text;
  final IconData? icon;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const Tag({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    required void Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = theme.colorScheme.surfaceBright;

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
          text,
        ],
      ),
    );
  }
}
