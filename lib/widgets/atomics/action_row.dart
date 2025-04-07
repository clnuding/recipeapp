import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class TightActionRow extends StatelessWidget {
  final List<Widget> actions;
  final double spacing;
  final EdgeInsets padding;

  const TightActionRow({
    super.key,
    required this.actions,
    this.spacing = SpoonSparkTheme.spacingXS,
    this.padding = const EdgeInsets.only(right: SpoonSparkTheme.spacingS),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            actions[i],
            if (i != actions.length - 1) SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }
}
