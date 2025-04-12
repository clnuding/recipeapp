import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: SpoonSparkTheme.spacingS),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}
