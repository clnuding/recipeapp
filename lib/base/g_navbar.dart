import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';

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
    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image.
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
          // Apply a blur effect.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.white.withValues(alpha: 0.2)),
          ),
          // Render the child on top.
          Container(child: child),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 25),
          child: GNav(
            duration: const Duration(milliseconds: 100),
            gap: 8, // the tab button gap between icon and text
            backgroundColor: Colors.white,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.grey.shade200,
            color: Colors.black, // unselected icon color
            padding: EdgeInsets.all(12),
            tabs: [
              GButton(icon: MingCute.calendar_line, text: 'Meal Plan'),
              GButton(icon: MingCute.fork_knife_line, text: 'Recipes'),
              GButton(icon: MingCute.shopping_cart_2_line, text: 'Groceries'),
              GButton(icon: MingCute.user_2_line, text: 'Profile'),
            ],
            onTabChange: onTap,
          ),
        ),
      ),
    );
  }
}
