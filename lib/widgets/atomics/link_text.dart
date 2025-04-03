import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const LinkText({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            // Show snackbar
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(text)));

            // Call external onTap if provided
            onTap?.call();
          },
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
