import 'package:flutter/material.dart';
import 'package:recipeapp/base/bottom_bar.dart';
import 'package:recipeapp/pages/meal_planning.dart';
import 'package:recipeapp/pages/recipes.dart';
import 'package:recipeapp/pages/groceries.dart';
import 'package:recipeapp/pages/account.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to Meal Planning

  // List of pages corresponding to each nav bar item.
  final List<Widget> _pages = const [
    MealPlanningPage(), // Default page
    RecipesPage(),
    GroceriesPage(),
    AccountPage()      // Your Account page (create this or use a placeholder)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: _selectedIndex,
      onTap: _onItemTapped,
      child: _pages[_selectedIndex],
    );
  }
}
