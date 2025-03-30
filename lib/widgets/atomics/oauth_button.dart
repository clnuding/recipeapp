import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class OAuthButton extends StatelessWidget {
  final String text;
  final dynamic icon;
  final Future<void> Function(BuildContext) onPressed;

  const OAuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: () => onPressed(context),
      icon: _buildIcon(theme),
      label: Text(text, style: theme.textTheme.bodyMedium),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    if (icon is IconData) {
      return Icon(icon, color: theme.colorScheme.onSurface, size: 20);
    } else if (icon is String) {
      return Brand(icon, size: 20);
    } else {
      throw ArgumentError('Unsupported icon type: ${icon.runtimeType}');
    }
  }
}
