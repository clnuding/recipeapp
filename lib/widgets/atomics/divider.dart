import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class HorizontalDivider extends StatelessWidget {
  final String? middleText;
  final double? thickness;

  const HorizontalDivider({super.key, this.middleText, this.thickness});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            thickness: thickness ?? 0.7,
            color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
          ),
        ),
        if (middleText != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SpoonSparkTheme.spacingS,
            ),
            child: Text(
              middleText!,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        Expanded(
          child: Divider(
            thickness: thickness ?? 0.7,
            color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
