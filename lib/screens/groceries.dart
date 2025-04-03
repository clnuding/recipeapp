import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<Map<String, dynamic>> _groceryItems = [
    {'title': 'Apples', 'unit': 'kg', 'amount': 1.5, 'checked': false},
    {'title': 'Milk', 'unit': 'liters', 'amount': 2, 'checked': false},
    {'title': 'Bread', 'unit': 'pcs', 'amount': 1, 'checked': false},
    {'title': 'Eggs', 'unit': 'dozen', 'amount': 1, 'checked': false},
  ];

  void _toggleChecked(int index) {
    setState(() {
      _groceryItems[index]['checked'] = !_groceryItems[index]['checked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Map<String, dynamic>> toGrabItems =
        _groceryItems.where((item) => !item['checked']).toList();
    List<Map<String, dynamic>> grabbedItems =
        _groceryItems.where((item) => item['checked']).toList();

    return Scaffold(
      appBar: LogoAppbar(showBackButton: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpoonSparkTheme.spacing8,
        ),
        child: ListView(
          padding: EdgeInsets.all(SpoonSparkTheme.spacing8),
          children: [
            if (toGrabItems.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SpoonSparkTheme.spacing4,
                ),
                child: Text(
                  'Need'.toUpperCase(),
                  style: theme.textTheme.titleSmall,
                ),
              ),
              ...toGrabItems.map((item) => _buildGroceryTile(item)),
              SizedBox(height: SpoonSparkTheme.spacing24),
            ],
            if (grabbedItems.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SpoonSparkTheme.spacing4,
                ),
                child: Text(
                  'Have'.toUpperCase(),
                  style: theme.textTheme.titleSmall,
                ),
              ),
              ...grabbedItems.map((item) => _buildGroceryTile(item)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGroceryTile(Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusNormal),
        ),
        child: ListTile(
          leading: GestureDetector(
            onTap: () => _toggleChecked(_groceryItems.indexOf(item)),
            child: CircleAvatar(
              radius: SpoonSparkTheme.radiusXLarge,
              backgroundColor:
                  item['checked'] ? Colors.green : theme.colorScheme.primary,
              child: Icon(
                item['checked'] ? Icons.check : Icons.radio_button_unchecked,
                color: theme.colorScheme.onPrimary,
                size: SpoonSparkTheme.radiusXLarge,
              ),
            ),
          ),
          title: Text(
            item['title'],
            style: TextStyle(
              fontSize: theme.textTheme.titleMedium?.fontSize,
              decoration:
                  item['checked']
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
            ),
          ),
          subtitle: Text(
            '${item['amount']} ${item['unit']}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          onTap: () => _toggleChecked(_groceryItems.indexOf(item)),
        ),
      ),
    );
  }
}
