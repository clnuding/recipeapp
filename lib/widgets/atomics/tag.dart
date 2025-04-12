import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class Tag extends StatelessWidget {
  final Text text;
  final IconData? icon;
  final Color? iconColor;
  final double iconSize;
  final Color? backgroundColor;
  final double? radius;

  const Tag({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.radius = SpoonSparkTheme.radiusL,
    this.iconColor = SpoonSparkTheme.textOnPrimaryLight,
    this.iconSize = SpoonSparkTheme.fontXS,
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
        borderRadius: BorderRadius.circular(radius!),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: iconColor, size: iconSize),
          const SizedBox(width: SpoonSparkTheme.spacingXS),
          text,
        ],
      ),
    );
  }
}
