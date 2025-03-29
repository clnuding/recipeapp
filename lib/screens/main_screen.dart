import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/g_navbar.dart';
import 'package:recipeapp/screens/meal_plan_tile_overview.dart';
import 'package:recipeapp/screens/recipes.dart';
import 'package:recipeapp/screens/account.dart';
import 'package:recipeapp/screens/groceries.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default to Meal Planning

  // List of pages corresponding to each nav bar item.
  final List<Widget> _pages = [
    MealPlanningPage(), // Default page
    RecipesPage(),
    // RecipeDetailScreen(),
    GroceryListScreen(),
    AccountScreen(), // Your Account page (create this or use a placeholder)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GButtomNavBar(
      selectedIndex: _selectedIndex,
      onTap: _onItemTapped,
      child: _pages[_selectedIndex],
    );
  }
}
