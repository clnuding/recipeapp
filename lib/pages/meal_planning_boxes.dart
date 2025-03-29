import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipeapp/base/theme.dart';

class MealPlanningPage extends StatelessWidget {
  const MealPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme();

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('spoon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
            const SizedBox(width: 2),
            SvgPicture.asset(
              'assets/logos/spoonspark_logo.svg',
              height: 25,
            ),
            const SizedBox(width: 2),
            const Text('spark', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
          ],
        ),
        backgroundColor: theme.primaryBackground,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chevron_left_sharp, color: theme.primaryText),
                Column(
                  children: [
                    Text("Current Week", style: theme.bodyMedium),
                    Text("Mon, 22nd July - Sun, 28th July", style: theme.bodySmall),
                  ],
                ),
                Icon(Icons.chevron_right, color: theme.primaryText),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: _MealPlanningTable()),
          ],
        ),
      ),
    );
  }
}

class _MealPlanningTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme();
    final List<Map<String, String>> mealData = [
      {"day": "Mon", "breakfast": "Pancakes", "lunch": "Caesar Salad", "dinner": "Grilled Chicken"},
      {"day": "Tue", "breakfast": "Oatmeal", "lunch": "Turkey Sandwich", "dinner": "Spaghetti Bolognese"},
      {"day": "Wed", "breakfast": "Scrambled Eggs", "lunch": "Sushi", "dinner": "Beef Stir-Fry"},
      {"day": "Thu", "breakfast": "French Toast", "lunch": "Grilled Cheese", "dinner": "BBQ Ribs"},
      {"day": "Fri", "breakfast": "Smoothie Bowl", "lunch": "Quinoa Salad", "dinner": "Fish Tacos"},
      {"day": "Sat", "breakfast": "Bagels & Cream Cheese", "lunch": "Burrito Bowl", "dinner": "Steak & Potatoes"},
      {"day": "Sun", "breakfast": "Cereal & Milk", "lunch": "Chicken Wrap", "dinner": "Margherita Pizza"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: mealData.length,
        itemBuilder: (context, index) {
          final dayMeals = mealData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: theme.alternateColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dayMeals['day']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  _MealRow(label: 'Breakfast', value: dayMeals['breakfast']!),
                  _MealRow(label: 'Lunch', value: dayMeals['lunch']!),
                  _MealRow(label: 'Dinner', value: dayMeals['dinner']!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final String label;
  final String value;

  const _MealRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.bodyText1),
          Text(value, style: theme.bodyText1.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
