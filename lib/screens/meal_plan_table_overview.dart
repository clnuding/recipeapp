import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class MealPlanTableView extends StatelessWidget {
  const MealPlanTableView({super.key});

  final List<String> days = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final List<String> meals = const ['Breakfast', 'Lunch', 'Dinner'];

  String getMealContent(String day, String meal) {
    return '$meal for $day';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double topReservedHeight = 275; // Reserved for header/nav
    const double rowSpacing = 6; // Space between each row

    final double totalSpacing = rowSpacing * (days.length - 1);
    final double availableHeight =
        screenHeight - topReservedHeight - totalSpacing;
    final double rowHeight = availableHeight / days.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        children: [
          // Auto-sized grid based on screen height
          ...days.asMap().entries.map((entry) {
            final int index = entry.key;
            final String day = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index != days.length - 1 ? rowSpacing : 0,
              ),
              child: SizedBox(
                height: rowHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Day label
                    Container(
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: secondary.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // Meal boxes
                    ...meals.map(
                      (meal) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              getMealContent(day, meal),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
