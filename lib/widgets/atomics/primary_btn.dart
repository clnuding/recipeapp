import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color? color;
  final void Function()? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.onPrimary;

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color ?? defaultColor,
        ),
      ),
    );
  }
}
