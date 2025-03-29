import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/logo_appbar.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            if (toGrabItems.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Need'.toUpperCase(),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              ...toGrabItems.map((item) => _buildGroceryTile(item)),
              SizedBox(height: 25),
            ],
            if (grabbedItems.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'Have'.toUpperCase(),
                  style: TextStyle(fontSize: 14),
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: GestureDetector(
            onTap: () => _toggleChecked(_groceryItems.indexOf(item)),
            child: CircleAvatar(
              radius: 14,
              backgroundColor:
                  item['checked'] ? Colors.green : theme.colorScheme.primary,
              child: Icon(
                item['checked'] ? Icons.check : Icons.radio_button_unchecked,
                color: theme.colorScheme.onPrimary,
                size: 14,
              ),
            ),
          ),
          title: Text(
            item['title'],
            style: TextStyle(
              fontSize: 15,
              decoration:
                  item['checked']
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
            ),
          ),
          subtitle: Text(
            '${item['amount']} ${item['unit']}',
            style: TextStyle(fontSize: 14, color: theme.colorScheme.primary),
          ),
          onTap: () => _toggleChecked(_groceryItems.indexOf(item)),
        ),
      ),
    );
  }
}
