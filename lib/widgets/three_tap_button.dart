import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:recipeapp/theme/theme.dart';

class ActionButtonsRow extends StatelessWidget {
  final String dayKey;
  // Callback passes the meal button index and the new state.
  final void Function(int buttonIndex, ButtonState newState)
  onButtonStateChanged;

  const ActionButtonsRow({
    super.key,
    required this.dayKey,
    required this.onButtonStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActionButton(
          icon: Icons.free_breakfast,
          label: 'Frühstück',
          onStateChanged: (state) => onButtonStateChanged(0, state),
        ),
        ActionButton(
          icon: FontAwesome.bowl_food_solid,
          label: 'Lunch',
          onStateChanged: (state) => onButtonStateChanged(1, state),
        ),
        ActionButton(
          icon: BoxIcons.bx_restaurant,
          label: 'Dinner',
          onStateChanged: (state) => onButtonStateChanged(2, state),
        ),
      ],
    );
  }
}

enum ButtonState { normal, primary, highlighted }

class ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  // Callback to notify parent of state changes.
  final ValueChanged<ButtonState> onStateChanged;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onStateChanged,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  ButtonState _state = ButtonState.primary;

  void _handleTap() {
    setState(() {
      _state =
          (_state == ButtonState.primary || _state == ButtonState.highlighted)
              ? ButtonState.normal
              : ButtonState.primary;
    });
    // Notify parent
    widget.onStateChanged(_state);
  }

  void _handleDoubleTap() {
    setState(() {
      _state = ButtonState.highlighted;
    });
    // Notify parent
    widget.onStateChanged(_state);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor;
    Color textColor;

    switch (_state) {
      case ButtonState.primary:
        backgroundColor = theme.colorScheme.primary.withValues(alpha: 0.15);
        textColor = theme.colorScheme.primary;
        break;
      case ButtonState.highlighted:
        backgroundColor = SpoonSparkTheme.highlight;
        textColor = theme.colorScheme.secondary;
        break;
      case ButtonState.normal:
        backgroundColor = theme.colorScheme.surfaceBright;
        textColor = theme.colorScheme.secondary.withValues(alpha: 0.3);
        break;
    }

    return GestureDetector(
      onTap: _handleTap,
      onDoubleTap: _handleDoubleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: textColor, size: 12),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
