import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/screens/weekday_plan.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/screens/meal_plan_table_overview.dart';
import 'package:recipeapp/widgets/atomics/meal_plan_tile.dart';

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

  Recipe _recipeWithImage(String title, String url) =>
      Recipe(id: "id", title: title, creatorId: "user", thumbnailUrl: url);

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
    return Scaffold(
      appBar: LogoAppbar(showBackButton: false),
      body: SafeArea(
        child: Column(
          children: [
            // 📅 Week Navigation + View Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Left controls
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

                  // Center week display
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('E, dd.MM.yyyy').format(_startOfWeek),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text('–', style: TextStyle(fontSize: 8)),
                        Text(
                          DateFormat(
                            'E, dd.MM.yyyy',
                          ).format(_startOfWeek.add(const Duration(days: 6))),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right controls
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _goToNextWeek,
                      ),
                      IconButton(
                        icon: Icon(
                          isGridView ? Icons.grid_view : Icons.table_chart,
                        ),
                        onPressed:
                            () => setState(() => isGridView = !isGridView),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

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
                    // Text(
                    //   day,
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
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

class CenteredOverlayButton extends StatelessWidget {
  const CenteredOverlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    // This positions the button in the center of the screen
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MealPlannerScreen(startDate: DateTime.now()),
            ),
          );
        },
        child: const Text('Start Meal Planning'),
      ),
    );
  }
}
