import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';

class AddIngredientPage extends StatefulWidget {
  final String recipeId;
  const AddIngredientPage({super.key, required this.recipeId});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final TextEditingController _ingredientSearchController =
      TextEditingController();

  final List<String> _ingredientOptions = [
    'Apfel',
    'Banane',
    'Mehl',
    'Eier',
    'Lachs',
    'Butter',
    'Olivenöl',
    'Nudeln',
    'Sojasoße',
  ];

  final List<String> _measurementOptions = ['g', 'ml', 'Stück', 'TL', 'EL'];

  List<String> _filteredIngredients = [];
  List<Map<String, String>> _selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    _filteredIngredients = List.from(_ingredientOptions);
    _ingredientSearchController.addListener(_filterIngredientList);
  }

  void _filterIngredientList() {
    final query = _ingredientSearchController.text.toLowerCase();
    setState(() {
      _filteredIngredients =
          _ingredientOptions
              .where((ingredient) => ingredient.toLowerCase().contains(query))
              .toList();
    });
  }

  void _showAddDialog(String ingredientName, {int? indexToEdit}) {
    final TextEditingController amountController = TextEditingController();
    String? selectedUnit;

    if (indexToEdit != null) {
      final existing = _selectedIngredients[indexToEdit];
      amountController.text = existing['amount']!;
      selectedUnit = existing['unit'];
    }

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: theme.colorScheme.onPrimary,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ingredientName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedUnit,
                  hint: const Text("Einheit wählen"),
                  items:
                      _measurementOptions.map((unit) {
                        return DropdownMenuItem(value: unit, child: Text(unit));
                      }).toList(),
                  onChanged: (value) => selectedUnit = value,
                  decoration: const InputDecoration(labelText: "Einheit"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Menge"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isNotEmpty &&
                        selectedUnit != null) {
                      setState(() {
                        final data = {
                          'name': ingredientName,
                          'amount': amountController.text,
                          'unit': selectedUnit!,
                        };
                        if (indexToEdit != null) {
                          _selectedIngredients[indexToEdit] = data;
                        } else {
                          _selectedIngredients.add(data);
                        }
                      });
                      Navigator.pop(context);
                      _ingredientSearchController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _ingredientSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: LogoAppbar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pushNamed(context, '/reviewRecipe'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: SpoonSparkTheme.spacingL),
            _buildStepper(theme),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _ingredientSearchController,
                      decoration: const InputDecoration(
                        labelText: "Zutat suchen",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_ingredientSearchController.text.isNotEmpty &&
                        _filteredIngredients.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children:
                              _filteredIngredients.map((ingredient) {
                                return ListTile(
                                  title: Text(ingredient),
                                  onTap: () => _showAddDialog(ingredient),
                                );
                              }).toList(),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          _selectedIngredients.isEmpty
                              ? Center(
                                child: Text(
                                  'Noch keine Zutaten ausgewählt',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              )
                              : ListView.separated(
                                itemCount: _selectedIngredients.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final item = _selectedIngredients[index];
                                  return Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(
                                      SpoonSparkTheme.radiusS,
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          SpoonSparkTheme.radiusS,
                                        ),
                                      ),
                                      tileColor: theme.colorScheme.onPrimary,
                                      title: Text('${item['name']}'),
                                      subtitle: Text(
                                        '${item['amount']} ${item['unit']}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed:
                                                () => _showAddDialog(
                                                  item['name']!,
                                                  indexToEdit: index,
                                                ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed:
                                                () => setState(
                                                  () => _selectedIngredients
                                                      .removeAt(index),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    const stepLabels = ["Rezept", "Zutaten", "Prüfen"];
    const int activeIndex = 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingL),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              final isActive = index == activeIndex;
              final isCompleted = index < activeIndex;
              final Color barColor =
                  isActive
                      ? theme.colorScheme.primary
                      : isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceBright;

              BorderRadius borderRadius = BorderRadius.zero;
              if (index == 0) {
                borderRadius = const BorderRadius.horizontal(
                  left: Radius.circular(12),
                );
              } else if (index == 2) {
                borderRadius = const BorderRadius.horizontal(
                  right: Radius.circular(12),
                );
              }

              return Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 4 : 0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: borderRadius,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          stepLabels[index],
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                isActive
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (isCompleted)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.check,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareIconButton(IconData icon, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(7),
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.onSurface),
        onPressed: onPressed,
      ),
    );
  }
}
