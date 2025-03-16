import 'package:flutter/material.dart';
import 'package:recipeapp/base/theme.dart';

class GroceriesPage extends StatelessWidget {
  const GroceriesPage({super.key});

  // ✅ Test Data for Displaying Some Values
  final List<Map<String, dynamic>> testGroceries = const [
    {'checked': false, 'amount': 500, 'unit': 'g', 'item': 'Flour'},
    {'checked': true, 'amount': 2, 'unit': 'pcs', 'item': 'Eggs'},
    {'checked': false, 'amount': 1, 'unit': 'kg', 'item': 'Apples'},
    {'checked': true, 'amount': 250, 'unit': 'ml', 'item': 'Milk'},
    {'checked': false, 'amount': 3, 'unit': 'pcs', 'item': 'Bananas'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme.of(context);

    return Scaffold(
      // backgroundColor: theme.primaryBackground,
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Page Title
            Center(child: Text("Groceries", style: theme.title1)),
            const SizedBox(height: 16),

            // ✅ Groceries List View
            Expanded(
              child: ListView.separated(
                itemCount: testGroceries.length,
                separatorBuilder:
                    (context, index) =>
                        const SizedBox(height: 8), // ✅ Space between list items
                itemBuilder: (context, index) {
                  final item = testGroceries[index];

                  return GroceryListItemWidget(
                    checked: item['checked'],
                    amount: item['amount'],
                    unit: item['unit'],
                    itemName: item['item'],
                    theme: theme,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ **Grocery List Item Widget**
class GroceryListItemWidget extends StatelessWidget {
  final bool checked;
  final int amount;
  final String unit;
  final String itemName;
  final RecipeAppTheme theme;

  const GroceryListItemWidget({
    super.key,
    required this.checked,
    required this.amount,
    required this.unit,
    required this.itemName,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = theme.primaryText;
    final Color primaryColor = theme.primaryColor;

    return Row(
      children: [
        // ✅ Checkbox Container
        _buildContainer(
          width: 50,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(7),
            bottomLeft: Radius.circular(7),
          ),
          child: Icon(
            checked ? Icons.done : Icons.circle_outlined,
            color: checked ? primaryColor : textColor.withOpacity(0.5),
          ),
        ),

        // ✅ Amount
        _buildContainer(
          width: 60,
          child: Text(
            '$amount',
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),

        // ✅ Unit
        _buildContainer(
          width: 80,
          child: Text(unit, style: TextStyle(color: textColor, fontSize: 16)),
        ),

        // ✅ Item Name (Takes remaining space)
        Expanded(
          child: _buildContainer(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(7),
              bottomRight: Radius.circular(7),
            ),
            child: Text(
              itemName,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ✅ **Reusable Container for List Items**
  Widget _buildContainer({
    required Widget child,
    double width = double.infinity,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: theme.alternateColor,
        color: Colors.grey.shade200,
        borderRadius:
            borderRadius ??
            BorderRadius.zero, // ✅ Rounded corners only on first & last items
        border: Border.all(color: theme.primaryText.withOpacity(0.3), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }
}
