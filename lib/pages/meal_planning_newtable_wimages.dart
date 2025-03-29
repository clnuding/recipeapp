import 'dart:ui';
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

  final List<String> meals = const [
    'Breakfast',
    'Lunch',
    'Dinner',
  ];

  // ✅ Fixed image URLs for each meal type
  final String breakfastUrl = 'https://images.unsplash.com/photo-1638813133218-4367bd8123f6';
  final String lunchUrl = 'https://images.unsplash.com/photo-1661791839093-0b8baf8616ab';
  final String dinnerUrl = 'https://images.unsplash.com/photo-1598532213919-078e54dd1f40';

  String getMealImage(String meal) {
    switch (meal) {
      case 'Breakfast':
        return breakfastUrl;
      case 'Lunch':
        return lunchUrl;
      case 'Dinner':
        return dinnerUrl;
      default:
        return '';
    }
  }

  String getMealTitle(String day, String meal) {
    return '$meal for $day';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    const double topReservedHeight = 270;
    const double rowSpacing = 6;

    final double totalSpacing = rowSpacing * (days.length - 1);
    final double availableHeight = screenHeight - topReservedHeight - totalSpacing;
    final double rowHeight = availableHeight / days.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        children: [
          ...days.asMap().entries.map((entry) {
            final int index = entry.key;
            final String day = entry.value;

            return Padding(
              padding: EdgeInsets.only(bottom: index != days.length - 1 ? rowSpacing : 0),
              child: SizedBox(
                height: rowHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🟫 Day Label
                    Container(
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: secondary.withOpacity(0.4),
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

                    // 🍽️ Meal Tiles
                    ...meals.map((meal) {
                      final imageUrl = getMealImage(meal);

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // 🌄 Image Background
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image),
                              ),

                              // 🧊 Text Overlay (blurred background only for text)
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        color: Colors.white.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          getMealTitle(day, meal),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
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
              ),
            );
          }),
        ],
      ),
    );
  }
}
