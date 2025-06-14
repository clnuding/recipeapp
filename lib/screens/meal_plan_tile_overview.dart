import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/screens/meal_plan_intro.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/screens/meal_plan_table_overview.dart';
import 'package:recipeapp/widgets/atomics/meal_plan_tile.dart';
import 'package:recipeapp/widgets/date_range_selector.dart';

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

  final String breakfastUrl =
      'https://images.unsplash.com/photo-1638813133218-4367bd8123f6';
  final String lunchUrl =
      'https://images.unsplash.com/photo-1661791839093-0b8baf8616ab';
  final String dinnerUrl =
      'https://images.unsplash.com/photo-1598532213919-078e54dd1f40';

  Recipe _recipeWithImage(String title, String url) => Recipe(
    id: "id",
    title: title,
    creatorId: "user",
    thumbnailUrl: url,
    householdId: "12345",
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
        'Breakfast': _recipeWithImage(
          'Oatmeal with yogurt and berries',
          breakfastUrl,
        ),
        'Lunch': _recipeWithImage('Grilled Cheese Sandwich', lunchUrl),
        'Dinner': _recipeWithImage('Spaghetti & Meatballs', dinnerUrl),
      },
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: LogoAppbar(
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            color: theme.colorScheme.onPrimary,
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MealPlanIntroScreen(
                        startDate: _startOfWeek,
                        userId: "73sm101s43o0apr",
                        householdId: "93s2b45o34971c3",
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 📅 Week Navigation + View Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: DateRangeSelector(
                startDate: _startOfWeek,
                onDropdownTap: () {},
                onPrevious: _goToPreviousWeek,
                onNext: _goToNextWeek,
              ),
            ),

            const SizedBox(height: SpoonSparkTheme.spacingXS),

            // Main content area
            Expanded(
              child:
                  isGridView
                      ? _buildCardStyleView()
                      : const MealPlanTableView(),
            ),
          ],
        ),
      ),
      // floatingActionButton: const CenteredOverlayButton(),
    );
  }

  Widget _buildCardStyleView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        children:
            weeklyMeals.entries.map((entry) {
              final day = entry.key;
              final meals = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(7),
        ),
        child:
            recipe != null
                ? MealPlanTile(recipe: recipe)
                : Center(
                  child: Text(
                    label,
                    // style: TextStyle(
                    //   color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    //   fontWeight: FontWeight.w500,
                    // ),
                  ),
                ),
      ),
    );
  }
}
