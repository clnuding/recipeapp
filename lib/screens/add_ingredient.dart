import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            // 🧾 Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Schritt 2: Zutaten hinzufügen',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                  return ListTile(
                                    tileColor: theme.colorScheme.surfaceBright,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
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
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),

            // ⏳ Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildSquareIconButton(
                    Icons.arrow_back,
                    () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colorScheme.surfaceBright,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.66,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                          backgroundColor: theme.colorScheme.surface
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildSquareIconButton(
                    Icons.arrow_forward,
                    () => Navigator.pushNamed(context, '/reviewRecipe'),
                  ),
                ],
              ),
            ),
          ],
        ),
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
