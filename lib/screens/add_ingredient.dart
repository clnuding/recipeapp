import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipeapp/screens/add_recipe.dart';
import 'package:recipeapp/screens/review_recipe.dart';
import 'package:recipeapp/state/recipe_wizard_state.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/api/ingredients.dart';
import 'package:recipeapp/api/measurements.dart';
import 'package:recipeapp/api/recipeingredients.dart';
import 'package:recipeapp/models/ingredient.dart';
import 'package:recipeapp/models/measurements.dart';
import 'package:recipeapp/models/recipeingredients.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/widgets/atomics/ingredient_tile.dart';

class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage({super.key});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  bool get _hasAtLeastOneIngredient => _selectedIngredients.isNotEmpty;

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

    // ✅ Load previously added ingredients from wizard state
    final wizard = Provider.of<RecipeWizardState>(context, listen: false);
    _selectedIngredients =
        wizard.ingredients.map((entry) {
          return {
            'id': entry.ingredientId,
            'name': '', // We'll populate name after loading
            'amount': entry.quantity.toString(),
            'unit_id': entry.measurementId,
            'unit': '', // We'll populate unit after loading
          };
        }).toList();
  }

  Future<void> _loadIngredients() async {
    final ingredients = await fetchIngredients();
    final measurements = await fetchMeasurements();
    setState(() {
      _allIngredients = ingredients;
      _filteredIngredients = ingredients;
      _allMeasurements = measurements;

      // 🔁 Fill in missing names & units
      for (var item in _selectedIngredients) {
        item['name'] =
            _allIngredients
                .firstWhere(
                  (ing) => ing.id == item['id'],
                  orElse: () => Ingredient(id: '', name: 'Unbekannt'),
                )
                .name;

        item['unit'] =
            _allMeasurements
                .firstWhere(
                  (m) => m.id == item['unit_id'],
                  orElse:
                      () => Measurements(id: '', name: '?', abbreviation: ''),
                )
                .name;
      }
    });
  }

  void _filterIngredientList() {
    final query = _ingredientSearchController.text.toLowerCase();
    setState(() {
      _filteredIngredients =
          _allIngredients
              .where(
                (ingredient) => ingredient.name.toLowerCase().startsWith(query),
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
                          .where(
                            (m) => m.name != null && m.name.trim().isNotEmpty,
                          )
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,5}(,\d{0,2})?$'),
                    ),
                  ],
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
                        'unit_id': selectedUnitId!,
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

  void _submitIngredients() {
    final wizard = Provider.of<RecipeWizardState>(context, listen: false);

    for (var item in _selectedIngredients) {
      final quantity = double.tryParse(item['amount'] ?? '') ?? 0.0;
      if (quantity <= 0) continue;

      final alreadyExists = wizard.ingredients.any(
        (i) =>
            i.ingredientId == item['id'] &&
            i.measurementId == item['unit_id'] &&
            i.quantity == quantity,
      );

      if (alreadyExists) continue;

      final newIngredient = Recipeingredients(
        id: '', // not used yet
        userId: '', // not used yet
        householdId: '',
        recipeId: '',
        ingredientId: item['id']!,
        measurementId: item['unit_id']!,
        quantity: quantity,
      );

      wizard.addIngredient(newIngredient);
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => RecipeReviewPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _saveToWizard(); // 👈 auch hier speichern
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => AddRecipePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        return false;
      },

      child: Scaffold(
        appBar: LogoAppbar(
          leading: BackButton(
            onPressed: () {
              _saveToWizard(); // 👈 Speichern bevor zurück
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation1, animation2) => AddRecipePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _hasAtLeastOneIngredient ? _submitIngredients : null,
              color:
                  _hasAtLeastOneIngredient
                      ? null
                      : Colors.grey, // optional visual cue
              // tooltip:
              //     _hasAtLeastOneIngredient
              //         ? "Weiter"
              //         : "Mindestens eine Zutat erforderlich", // helpful for accessibility
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
                  child: Stack(
                    children: [
                      // Main content
                      Column(
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
                          const SizedBox(height: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_selectedIngredients.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    // child: Text(
                                    //   '* Mindestens eine Zutat erforderlich',
                                    //   style: TextStyle(
                                    //     color: theme.colorScheme.error,
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!_hasAtLeastOneIngredient)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Text(
                                            '* Mindestens eine Zutat erforderlich',
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        child:
                                            _selectedIngredients.isEmpty
                                                ? Center(
                                                  child: Text(
                                                    'Noch keine Zutaten ausgewählt',
                                                    style: TextStyle(
                                                      color: theme
                                                          .colorScheme
                                                          .onSurface
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                )
                                                : GridView.builder(
                                                  itemCount:
                                                      _selectedIngredients
                                                          .length,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 4,
                                                        childAspectRatio: 0.7,
                                                        crossAxisSpacing: 10,
                                                        mainAxisSpacing: 10,
                                                      ),
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    final item =
                                                        _selectedIngredients[index];
                                                    return IngredientTile(
                                                      name: item['name']!,
                                                      amount: double.tryParse(
                                                        item['amount'] ?? '',
                                                      ),
                                                      unit: item['unit'],
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons.edit,
                                                            ),
                                                            iconSize: 16,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed:
                                                                () => _showAddDialog(
                                                                  _allIngredients
                                                                      .firstWhere(
                                                                        (ing) =>
                                                                            ing.id ==
                                                                            item['id'],
                                                                      ),
                                                                  indexToEdit:
                                                                      index,
                                                                ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons.delete,
                                                            ),
                                                            iconSize: 16,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed:
                                                                () => setState(() {
                                                                  _selectedIngredients
                                                                      .removeAt(
                                                                        index,
                                                                      );
                                                                }),
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
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Overlay search results
                      if (_ingredientSearchController.text.isNotEmpty &&
                          _filteredIngredients.isNotEmpty)
                        Positioned(
                          top: 50,
                          left: 0,
                          right: 0,
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(maxHeight: 250),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _filteredIngredients.take(5).length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 0.7,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemBuilder: (context, index) {
                                  final ingredient =
                                      _filteredIngredients[index];
                                  return GestureDetector(
                                    onTap: () => _showAddDialog(ingredient),
                                    child: IngredientTile(
                                      name: ingredient.name,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  void _saveToWizard() {
    final wizard = Provider.of<RecipeWizardState>(context, listen: false);

    // 🔁 Entferne alle alten Zutaten aus dem Wizard
    for (final ing in wizard.ingredients.toList()) {
      wizard.removeIngredient(ing.ingredientId);
    }

    // ➕ Füge aktuelle Zutaten hinzu
    for (var item in _selectedIngredients) {
      final quantity = double.tryParse(item['amount'] ?? '') ?? 0.0;
      if (quantity <= 0) continue;

      final newIngredient = Recipeingredients(
        id: '', // not used
        userId: '',
        householdId: '',
        recipeId: '',
        ingredientId: item['id']!,
        measurementId: item['unit_id']!,
        quantity: quantity,
      );

      wizard.addIngredient(newIngredient);
    }
  }
}
