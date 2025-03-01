import 'package:flutter/material.dart';
import 'dart:ui';

/// Custom Glass-Style Switch
class GlassSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GlassSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glass background (Reduced height)
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: 44, // Reduced width
              height: 24, // Reduced height
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
          ),
        ),
        // Scaled-down Switch
        Transform.scale(
          scale: 0.8, // Shrinks the Switch
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.orange, // Thumb color when active
            inactiveThumbColor: Colors.white70, // Thumb color when inactive
            activeTrackColor: Colors.orange.withValues(
              alpha: 0.3,
            ), // Glassy track color
            inactiveTrackColor: Colors.white.withValues(
              alpha: 0.1,
            ), // Glassy inactive track
          ),
        ),
      ],
    );
  }
}
