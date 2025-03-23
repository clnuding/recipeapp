import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:recipeapp/base/theme.dart'; // Import your custom theme

class GButtomNavBar extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool showNavBar;

  const GButtomNavBar({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onTap,
    this.showNavBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme.of(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1625631979614-7ab4aa53d600?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: theme.primaryBackground.withOpacity(0.2)),
          ),
          child,
        ],
      ),
      bottomNavigationBar: showNavBar
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 15),
              color: theme.primaryBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _navItems(theme),
              ),
            )
          : null,
    );
  }

  List<Widget> _navItems(RecipeAppTheme theme) {
    final Color activeColor = theme.primaryText;
    final Color inactiveColor = theme.primaryText.withOpacity(0.5);

    final List<_NavItemData> items = [
      _NavItemData(icon: MingCute.calendar_line, label: 'Meal Plan'),
      _NavItemData(icon: MingCute.fork_knife_line, label: 'Recipes'),
      _NavItemData(icon: MingCute.shopping_cart_2_line, label: 'Groceries'),
      _NavItemData(icon: MingCute.user_2_line, label: 'Profile'),
    ];

    return List.generate(items.length, (index) {
      final isSelected = selectedIndex == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => onTap(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[index].icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  items[index].label,
                  style: TextStyle(
                    fontSize: isSelected ? 13.5 : 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  _NavItemData({required this.icon, required this.label});
}
