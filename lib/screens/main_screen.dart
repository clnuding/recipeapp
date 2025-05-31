import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/atomics/navbar.dart';
import 'package:recipeapp/screens/meal_plan_tile_overview.dart';
import 'package:recipeapp/screens/recipes.dart';
import 'package:recipeapp/screens/account.dart';
import 'package:recipeapp/screens/groceries.dart';

class MainScreen extends StatefulWidget {
  final int initialTabIndex;
  const MainScreen({super.key, this.initialTabIndex = 0}); // 👈 Add this

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  // List of pages corresponding to each nav bar item.
  final List<Widget> _pages = [
    MealPlanningPage(), // Default page
    RecipesPage(),
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
    return BottomNavbar(
      selectedIndex: _selectedIndex,
      onTap: _onItemTapped,
      child: _pages[_selectedIndex],
    );
  }
}
