import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final String? label;
  final Color? color;

  const CustomCheckBox({
    super.key,
    this.label,
    this.color,
    this.value = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Transform.translate(
          offset: const Offset(-5, 0),
          child: Checkbox(
            activeColor: color ?? defaultColor,
            value: value,
            onChanged: onChanged,
            visualDensity: VisualDensity(horizontal: -4.0),
          ),
        ),
        Expanded(child: Text(label ?? '', style: theme.textTheme.bodySmall)),
      ],
    );
  }
}
