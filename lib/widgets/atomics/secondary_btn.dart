import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Color? color;
  final void Function()? onPressed;

  const SecondaryButton({
    super.key,
    required this.text,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.primary;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusM),
          side: BorderSide(color: defaultColor, width: 2),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color ?? defaultColor,
          fontWeight: SpoonSparkTheme.fontWeightBold,
        ),
      ),
    );
  }
}
