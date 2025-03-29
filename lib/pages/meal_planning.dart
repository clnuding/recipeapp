import 'package:flutter/material.dart';
import 'package:recipeapp/base/theme.dart';
import 'package:recipeapp/screens/weekday_plan.dart';

class MealPlanningPage extends StatelessWidget {
  const MealPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme(); // Get theme instance

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 10,
          ), // Equal left & right padding
          child: Column(
            children: [
              // Page Title
              // Text(
              //   "Meal Planning",
              //   style: theme.displaySmall.copyWith(fontWeight: FontWeight.w600),
              // ),
              const SizedBox(height: 20),

              // Table Header (Week Navigation)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left_sharp, color: theme.primaryText),
                  Column(
                    children: [
                      Text("Current Week", style: theme.bodyMedium),
                      Text(
                        "Mon, 22nd July - Sun, 28th July",
                        style: theme.bodySmall,
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right, color: theme.primaryText),
                ],
              ),
              const SizedBox(height: 20),

              // Meal Planning Table (Expands Fully)
              Expanded(child: _MealPlanningTable()),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================
// ✅ Meal Planning Data Table (FULL HEIGHT + CENTERED + STYLED HEADER)
// ==========================
class _MealPlanningTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme(); // Get theme instance

    // ✅ Sample Test Data (Static Meals for One Week)
    final List<Map<String, String>> mealData = [
      {
        "day": "Mon",
        "breakfast": "Pancakes",
        "lunch": "Caesar Salad",
        "dinner": "Grilled Chicken",
      },
      {
        "day": "Tue",
        "breakfast": "Oatmeal",
        "lunch": "Turkey Sandwich",
        "dinner": "Spaghetti Bolognese",
      },
      {
        "day": "Wed",
        "breakfast": "Scrambled Eggs",
        "lunch": "Sushi",
        "dinner": "Beef Stir-Fry",
      },
      {
        "day": "Thu",
        "breakfast": "French Toast",
        "lunch": "Grilled Cheese",
        "dinner": "BBQ Ribs",
      },
      {
        "day": "Fri",
        "breakfast": "Smoothie Bowl",
        "lunch": "Quinoa Salad",
        "dinner": "Fish Tacos",
      },
      {
        "day": "Sat",
        "breakfast": "Bagels & Cream Cheese",
        "lunch": "Burrito Bowl",
        "dinner": "Steak & Potatoes",
      },
      {
        "day": "Sun",
        "breakfast": "Cereal & Milk",
        "lunch": "Chicken Wrap",
        "dinner": "Margherita Pizza",
      },
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double totalWidth = constraints.maxWidth;
          double totalHeight =
              constraints.maxHeight; // Ensure table fills the screen
          double dayColumnWidth = totalWidth * 0.07; // Auto-size for "Day"
          double mealColumnWidth = totalWidth * 0.28; // Fixed width for meals

          return Container(
            width: totalWidth,
            height: totalHeight,
            padding: const EdgeInsets.symmetric(horizontal: 3), // Equal padding
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7), // Rounded corners
              color: theme.primaryBackground,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 4,
              //     spreadRadius: 1,
              //   ),
              // ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                7,
              ), // Ensures rounded corners apply to table
              child: DataTable(
                columnSpacing: 8, // Reduce space between columns
                headingRowHeight: 45, // Slightly larger heading
                dataRowHeight:
                    (totalHeight - 45) /
                    mealData.length, // Even row height for full screen usage
                headingRowColor: MaterialStateProperty.all(
                  theme.alternateColor,
                ), // Light grey header row
                dataRowColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                ) {
                  return states.contains(MaterialState.selected)
                      ? const Color.fromARGB(255, 43, 42, 42)
                      : null;
                }),
                border: TableBorder.all(
                  color: theme.primaryText.withOpacity(0.4),
                  width: 0.5,
                ),
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: dayColumnWidth,
                      child: Text(
                        'Day',
                        style: theme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: mealColumnWidth,
                      child: Text(
                        'Breakfast',
                        style: theme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: mealColumnWidth,
                      child: Text(
                        'Lunch',
                        style: theme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: mealColumnWidth,
                      child: Text(
                        'Dinner',
                        style: theme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
                rows:
                    mealData.map((meal) {
                      return DataRow(
                        color: MaterialStateProperty.all(
                          theme.primaryBackground.withOpacity(0.05),
                        ),
                        cells: [
                          DataCell(
                            SizedBox(
                              width: dayColumnWidth,
                              child: Text(
                                meal["day"] ?? '',
                                style: theme.bodySmall,
                                softWrap: true,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: mealColumnWidth,
                              child: Text(
                                meal["breakfast"] ?? '',
                                style: theme.bodySmall,
                                softWrap: true,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: mealColumnWidth,
                              child: Text(
                                meal["lunch"] ?? '',
                                style: theme.bodySmall,
                                softWrap: true,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: mealColumnWidth,
                              child: Text(
                                meal["dinner"] ?? '',
                                style: theme.bodySmall,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: const CenteredOverlayButton(),
    );
  }
}

class CenteredOverlayButton extends StatelessWidget {
  const CenteredOverlayButton({Key? key}) : super(key: key);

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
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 18),
        ),
        child: const Text('Start Meal Planning'),
      ),
    );
  }
}
