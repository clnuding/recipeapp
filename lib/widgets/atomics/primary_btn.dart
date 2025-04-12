import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color? color;
  final IconData? icon;
  final IconAlignment? iconAlignment;
  final void Function()? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.color,
    this.onPressed,
    this.iconAlignment = IconAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.onPrimary;

    if (icon != null) {
      return ElevatedButton.icon(
        iconAlignment: iconAlignment,
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
