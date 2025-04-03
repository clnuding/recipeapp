import 'package:flutter/material.dart';

class AddIngredientPage extends StatefulWidget {
  final String recipeId;
  const AddIngredientPage({super.key, required this.recipeId});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _ingredientSearchController =
      TextEditingController();

  final List<String> _ingredientOptions = [
    'Flour',
    'Sugar',
    'Salt',
    'Butter',
    'Eggs',
  ];
  final List<String> _measurementOptions = ['g', 'ml', 'cup', 'tbsp', 'tsp'];

  String? _selectedIngredient;
  String? _selectedMeasurement;
  List<String> _filteredIngredients = [];

  @override
  void initState() {
    super.initState();
    _filteredIngredients = List.from(_ingredientOptions);
    _ingredientSearchController.addListener(_filterIngredientList);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _ingredientSearchController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Form Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Step 2: Add Ingredients',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildIngredientSearchBar(),
                      const SizedBox(height: 16),

                      _buildMeasurementDropdown(),
                      const SizedBox(height: 16),

                      _buildInputField(
                        controller: _amountController,
                        label: "Amount",
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientSearchBar() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: TextField(
            controller: _ingredientSearchController,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              hintText: "Search Ingredient",
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
        if (_ingredientSearchController.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Column(
              children:
                  _filteredIngredients.map((ingredient) {
                    return ListTile(
                      title: Text(
                        ingredient,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedIngredient = ingredient;
                          _ingredientSearchController.text = ingredient;
                          _filteredIngredients = [];
                        });
                      },
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildMeasurementDropdown() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMeasurement,
          hint: Text(
            "Select Measurement",
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.onSurface),
          isExpanded: true,
          dropdownColor: theme.colorScheme.onPrimary,
          style: TextStyle(color: theme.colorScheme.onSurface),
          items:
              _measurementOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedMeasurement = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        filled: true,
        fillColor: theme.colorScheme.onPrimary,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildSquareIconButton(
            Icons.arrow_back,
            () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(child: _buildProgressBar(2)),
          const SizedBox(width: 8),
          _buildSquareIconButton(
            Icons.arrow_forward,
            () => Navigator.pushNamed(context, '/reviewRecipe'),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareIconButton(IconData icon, VoidCallback onPressed) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface, size: 24),
      ),
    );
  }

  Widget _buildProgressBar(int activeStep) {
    final theme = Theme.of(context);
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressCircle(activeStep >= 1),
          _buildProgressLine(),
          _buildProgressCircle(activeStep >= 2),
          _buildProgressLine(),
          _buildProgressCircle(activeStep >= 3),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(bool isActive) {
    final theme = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : Colors.transparent,
        border: Border.all(color: theme.colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  Widget _buildProgressLine() {
    final theme = Theme.of(context);
    return Container(width: 20, height: 3, color: theme.colorScheme.primary);
  }
}
