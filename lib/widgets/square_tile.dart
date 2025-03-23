import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onTap;
  const SquareTile({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: icon,
      ),
    );
  }
}
