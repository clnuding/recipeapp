import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const GlassBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
        child: Container(
          color: Colors.transparent, // Glass effect background
          padding: EdgeInsets.only(top: 10), // Add padding
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent, // Transparent background
            elevation: 0, // Remove shadow
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withValues(alpha: 0.7),
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            iconSize: 25,
            type:
                BottomNavigationBarType.fixed, // Ensures no shifting animation
            enableFeedback: false, // Disables the tap animation effect
            selectedFontSize: 10, // Prevents font from animating
            unselectedFontSize: 10, // Keeps it consistent
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank_rounded),
                label: 'Recipes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
