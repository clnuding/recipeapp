import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/pages/widgets/meal_plan_tile.dart';
import 'package:recipeapp/pages/meal_planning_newtable.dart';

class MealPlanningPage extends StatefulWidget {
  const MealPlanningPage({super.key});

  @override
  State<MealPlanningPage> createState() => _MealPlanningPageState();
}

class _MealPlanningPageState extends State<MealPlanningPage> {
  bool isGridView = true;

  DateTime _startOfWeek = _getStartOfWeek(DateTime.now());

  static DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void _goToPreviousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.add(const Duration(days: 7));
    });
  }

  String _getFormattedWeekRange() {
    final endOfWeek = _startOfWeek.add(const Duration(days: 6));
    final formatter = DateFormat('E, dd.MM.yyyy');
    return '${formatter.format(_startOfWeek)} - ${formatter.format(endOfWeek)}';
  }

  final String breakfastUrl = 'https://images.unsplash.com/photo-1638813133218-4367bd8123f6';
  final String lunchUrl = 'https://images.unsplash.com/photo-1661791839093-0b8baf8616ab';
  final String dinnerUrl = 'https://images.unsplash.com/photo-1598532213919-078e54dd1f40';

  Recipe _recipeWithImage(String title, String url) => Recipe(
        id: "id",
        title: title,
        creatorId: "user",
        thumbnailUrl: url,
      );

  late final Map<String, Map<String, Recipe?>> weeklyMeals = {
    for (var day in [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ])
      day: {
        'Breakfast': _recipeWithImage('Oatmeal with yogurt and berries', breakfastUrl),
        'Lunch': _recipeWithImage('Grilled Cheese Sandwich', lunchUrl),
        'Dinner': _recipeWithImage('Spaghetti & Meatballs', dinnerUrl),
      }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // 🥄 Logo Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'spoon',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(width: 2),
                  SvgPicture.asset('assets/logos/spoonspark_logo.svg', height: 25),
                  const SizedBox(width: 2),
                  const Text(
                    'spark',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 📅 Week Navigation + View Toggle
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [
      // Left: + and < buttons
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Add meal action
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _goToPreviousWeek,
          ),
        ],
      ),

      // Center: Week range text, takes remaining space
      Expanded(
        child: Center(
          child: Text(
            _getFormattedWeekRange(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      // Right: > and view toggle
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _goToNextWeek,
          ),
          IconButton(
            icon: Icon(isGridView ? Icons.grid_view : Icons.table_chart),
            onPressed: () {
              setState(() => isGridView = !isGridView);
            },
          ),
        ],
      ),
    ],
  ),
),




            const SizedBox(height: 4),

            // 👇 Main Content Switches View
            Expanded(
              child: isGridView
                  ? _buildCardStyleView()
                  : const MealPlanTableView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStyleView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        children: weeklyMeals.entries.map((entry) {
          final day = entry.key;
          final meals = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMealTile(meals['Breakfast'], 'Breakfast'),
                    const SizedBox(width: 8),
                    _buildMealTile(meals['Lunch'], 'Lunch'),
                    const SizedBox(width: 8),
                    _buildMealTile(meals['Dinner'], 'Dinner'),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMealTile(Recipe? recipe, String label) {
    return Expanded(
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: lightColorScheme.surface,
          borderRadius: BorderRadius.circular(7),
        ),
        child: recipe != null
            ? MealPlanTile(recipe: recipe)
            : Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: lightColorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }
}
