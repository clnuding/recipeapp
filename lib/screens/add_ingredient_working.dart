import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/api/ingredients.dart';
import 'package:recipeapp/api/measurements.dart';
import 'package:recipeapp/api/recipeingredients.dart';
import 'package:recipeapp/models/ingredient.dart';
import 'package:recipeapp/models/measurements.dart';
import 'package:recipeapp/models/recipeingredients.dart';
import 'package:recipeapp/api/pb_client.dart';

class AddIngredientPage extends StatefulWidget {
  final String recipeId;
  const AddIngredientPage({super.key, required this.recipeId});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final TextEditingController _ingredientSearchController =
      TextEditingController();
  List<Ingredient> _allIngredients = [];
  List<Ingredient> _filteredIngredients = [];
  List<Measurements> _allMeasurements = [];
  List<Map<String, String?>> _selectedIngredients = [];
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
    _ingredientSearchController.addListener(_filterIngredientList);
  }

  Future<void> _loadIngredients() async {
    final ingredients = await fetchIngredients();
    final measurements = await fetchMeasurements();
    setState(() {
      _allIngredients = ingredients;
      _filteredIngredients = ingredients;
      _allMeasurements = measurements;
    });
  }

  void _filterIngredientList() {
    final query = _ingredientSearchController.text.toLowerCase();
    setState(() {
      _filteredIngredients =
          _allIngredients
              .where(
                (ingredient) => ingredient.name.toLowerCase().contains(query),
              )
              .toList();
    });
  }

  void _showAddDialog(Ingredient ingredient, {int? indexToEdit}) async {
    final TextEditingController amountController = TextEditingController();
    String? selectedUnitId = ingredient.standardMeasurementId;

    if (indexToEdit != null) {
      final existing = _selectedIngredients[indexToEdit];
      amountController.text = existing['amount']!;
      selectedUnitId = existing['unit_id'];
    }

    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
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
                        ingredient.name,
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
                  value: selectedUnitId,
                  hint: const Text("Einheit wählen"),
                  items:
                      _allMeasurements
                          .map(
                            (m) => DropdownMenuItem(
                              value: m.id,
                              child: Text(m.name),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => selectedUnitId = value,
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
                        selectedUnitId != null) {
                      final data = {
                        'id': ingredient.id,
                        'name': ingredient.name,
                        'amount': amountController.text,
                        'unit':
                            _allMeasurements
                                .firstWhere((m) => m.id == selectedUnitId)
                                .name,
                        'unit_id': selectedUnitId,
                      };
                      setState(() {
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

  void _submitIngredients() async {
    if (_submitted) return; // Prevent duplicate submission
    _submitted = true;

    if (!pb.authStore.isValid) {
      print("❌ User not authenticated.");
      return;
    }

    final userId = pb.authStore.model?.id;
    final householdId = pb.authStore.model?.getStringValue('household_id');
    if (userId == null || householdId == null) return;

    for (var item in _selectedIngredients) {
      final quantity = double.tryParse(item['amount'] ?? '') ?? 0.0;
      if (quantity <= 0) continue;

      final recipeIngredient = Recipeingredients(
        id: '',
        userId: userId,
        householdId: householdId,
        recipeId: widget.recipeId,
        ingredientId: item['id']!,
        measurementId: item['unit_id']!,
        quantity: quantity,
      );

      try {
        await pb
            .collection('recipeIngredients')
            .create(body: recipeIngredient.toJson()..remove("id"));
      } catch (e) {
        print("❌ Failed to save ingredient: $e");
      }
    }

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/reviewRecipe',
        arguments: {'recipeId': widget.recipeId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: LogoAppbar(
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _submitIngredients,
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
                                  title: Text(ingredient.name),
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
                                      title: Text(item['name']!),
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
                                                  _allIngredients.firstWhere(
                                                    (ing) =>
                                                        ing.id == item['id'],
                                                  ),
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
                  isActive || isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceBright;

              BorderRadius borderRadius = BorderRadius.zero;
              if (index == 0)
                borderRadius = const BorderRadius.horizontal(
                  left: Radius.circular(12),
                );
              if (index == 2)
                borderRadius = const BorderRadius.horizontal(
                  right: Radius.circular(12),
                );

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
                    Text(
                      stepLabels[index],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
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
