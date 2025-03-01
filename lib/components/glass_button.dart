import 'dart:ui';
import 'package:flutter/material.dart';

class FloatingGlassButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingGlassButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 110, // Adjust as needed for nav bar overlap
      left: 100, // Padding on left
      right: 100, // Padding on right
      child: GestureDetector(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glass effect
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.4,
                ), // Semi-transparent glass
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                ), // Glassy border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: const Icon(Icons.add, size: 25, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
