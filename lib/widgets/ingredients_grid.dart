import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class IngredientsGrid extends StatefulWidget {
  final List<Map<String, dynamic>> ingredients;
  final int initialServings;

  const IngredientsGrid({
    super.key,
    required this.ingredients,
    required this.initialServings,
  });

  @override
  _IngredientsGridState createState() => _IngredientsGridState();
}

class _IngredientsGridState extends State<IngredientsGrid> {
  late int _servings;

  @override
  void initState() {
    super.initState();
    _servings = widget.initialServings;
  }

  // Format number smartly
  String _formatNumber(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  // Map ingredient groups to default icons
  IconData _getIconForGroup(String group) {
    switch (group.toLowerCase()) {
      case 'vegetables':
        return FontAwesome.leaf_solid;
      case 'meat':
        return Icons.kebab_dining;
      case 'dairy':
        return Icons.egg;
      case 'grains':
        return Icons.grain;
      case 'spices':
        return Icons.spa;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ingredients Header with Serving Size Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Zutaten',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  // Decrement Serving Size Button
                  GestureDetector(
                    onTap: () {
                      if (_servings > 0) {
                        setState(() {
                          _servings--;
                        });
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: _servings > 0 ? Colors.black : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),

                  // Serving Size Display
                  Container(
                    width: 50,
                    height: 35,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$_servings',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Increment Serving Size Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _servings++;
                      });
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(Icons.add, color: Colors.black, size: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ingredients Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = widget.ingredients[index];

              // Adjust measurement based on servings
              final adjustedMeasurement =
                  (ingredient['measurement'] as double) * _servings;

              return Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Group Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForGroup(ingredient['group']),
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Ingredient Name
                    Text(
                      ingredient['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),

                    // Measurement with smart formatting
                    Text(
                      '${_formatNumber(adjustedMeasurement)} ${ingredient['measurementName']}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
