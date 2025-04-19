import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/atomics/ingredient_tile.dart';

//import 'package:recipeapp/theme/theme.dart';

class IngredientsGrid extends StatefulWidget {
  final List<Map<String, dynamic>> ingredients;
  final int initialServings;
  final String description; // 🆕

  const IngredientsGrid({
    super.key,
    required this.ingredients,
    required this.initialServings,
    required this.description, // 🆕
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

  String _formatNumber(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: TabBar(
                tabs: const [Tab(text: 'Zutaten'), Tab(text: 'Zubereitung')],
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: Colors.black54,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: theme.colorScheme.primary,
                  ),
                  insets: const EdgeInsets.symmetric(horizontal: 0),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                dividerColor: theme.dividerColor.withValues(alpha: 0.2),
              ),
            ),
          ),

          const SizedBox(height: 1),
          SizedBox(
            height: 350, // Adjust height as needed
            child: TabBarView(
              children: [
                // Zutaten Tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Portionen:',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            // decoration: BoxDecoration(
                            //   color: Colors.white,
                            //   borderRadius: BorderRadius.circular(8),
                            //   boxShadow: const [
                            //     BoxShadow(
                            //       color: Color.fromARGB(255, 234, 234, 234),
                            //       blurRadius: 4,
                            //       spreadRadius: 1,
                            //     ),
                            //   ],
                            // ),
                            child: Text(
                              '$_servings',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Ingredients Grid
                      Expanded(
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: widget.ingredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = widget.ingredients[index];
                            final adjustedMeasurement =
                                (ingredient['measurement'] as double);

                            return IngredientTile(
                              name: ingredient['name'],
                              amount: adjustedMeasurement,
                              unit: ingredient['measurementName'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Zubereitung Tab (Placeholder for now)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.description.isNotEmpty
                        ? widget.description
                        : 'Keine Zubereitungsbeschreibung vorhanden.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
