import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Color? color;
  final IconData? icon;
  final void Function()? onPressed;

  const SecondaryButton({
    super.key,
    required this.text,
    this.color,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.primary;

    if (icon != null) {
      return OutlinedButton.icon(
        icon: Icon(icon, color: defaultColor),
        onPressed: onPressed,
        label: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color ?? defaultColor,
            fontWeight: SpoonSparkTheme.fontWeightBold,
          ),
        ),
      );
    }
    return ElevatedButton(
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
