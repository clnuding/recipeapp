import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class OnImageTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const OnImageTag({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpoonSparkTheme.spacing8,
        vertical: SpoonSparkTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusLarge),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: Colors.white,
            size: theme.textTheme.labelMedium?.fontSize,
          ),
          const SizedBox(width: SpoonSparkTheme.spacing4),
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
