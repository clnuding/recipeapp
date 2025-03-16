import 'package:flutter/material.dart';
import 'package:recipeapp/base/theme.dart'; // Provides RecipeAppTheme

class AddIngredientPage extends StatefulWidget {
  final String recipeId;
  const AddIngredientPage({super.key, required this.recipeId});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _ingredientSearchController = TextEditingController();

  // Test data for ingredients and measurements
  final List<String> _ingredientOptions = [
    'Flour', 'Sugar', 'Salt', 'Butter', 'Eggs'
  ];
  final List<String> _measurementOptions = [
    'g', 'ml', 'cup', 'tbsp', 'tsp'
  ];

  // Selected values
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
      _filteredIngredients = _ingredientOptions
          .where((ingredient) => ingredient.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Form Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Title
                      Center(
                        child: Text(
                          'Step 2: Add Ingredients',
                          style: theme.title1.copyWith(color: theme.primaryText),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ingredient Search Bar with Icon
                      _buildIngredientSearchBar(theme),
                      const SizedBox(height: 16),

                      // Measurement Dropdown
                      _buildMeasurementDropdown(theme),
                      const SizedBox(height: 16),

                      // Amount Input Field
                      _buildInputField(
                        controller: _amountController,
                        label: "Amount",
                        theme: theme,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Styled Bottom Bar (Same Design as add_recipe.dart)
            _buildBottomNavigation(theme),
          ],
        ),
      ),
    );
  }

  /// ✅ **Ingredient Search Bar with Search Icon & Selection**
  Widget _buildIngredientSearchBar(RecipeAppTheme theme) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.alternateColor,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: TextField(
            controller: _ingredientSearchController,
            style: TextStyle(color: theme.primaryText),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              hintText: "Search Ingredient",
              hintStyle: TextStyle(color: theme.primaryText.withOpacity(0.6)),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: theme.primaryText.withOpacity(0.6)), // ✅ Search Icon Added
            ),
          ),
        ),
        if (_ingredientSearchController.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: theme.alternateColor,
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Column(
              children: _filteredIngredients.map((ingredient) {
                return ListTile(
                  title: Text(
                    ingredient,
                    style: TextStyle(color: theme.primaryText),
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

  /// ✅ **Measurement Dropdown**
  Widget _buildMeasurementDropdown(RecipeAppTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: theme.alternateColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMeasurement,
          hint: Text(
            "Select Measurement",
            style: TextStyle(color: theme.primaryText.withOpacity(0.6)),
          ),
          icon: Icon(Icons.arrow_drop_down, color: theme.primaryText),
          isExpanded: true,
          dropdownColor: theme.alternateColor,
          style: TextStyle(color: theme.primaryText),
          items: _measurementOptions.map((String option) {
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

  /// ✅ **Reusable Input Field Builder**
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required RecipeAppTheme theme,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: theme.primaryText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.primaryText.withOpacity(0.6)),
        filled: true,
        fillColor: theme.alternateColor, // ✅ Themed background
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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

  /// ✅ **Bottom Navigation (Same as add_recipe.dart)**
  Widget _buildBottomNavigation(RecipeAppTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildSquareIconButton(theme, Icons.arrow_back, () => Navigator.pop(context)),
          const SizedBox(width: 8),
          Expanded(child: _buildProgressBar(theme, 2)), // Step 2 active for ingredients page
          const SizedBox(width: 8),
          _buildSquareIconButton(theme, Icons.arrow_forward, () => Navigator.pushNamed(context, '/reviewRecipe')),
        ],
      ),
    );
  }

  /// ✅ **Reusable Square Icon Button**
  Widget _buildSquareIconButton(RecipeAppTheme theme, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: theme.alternateColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, color: theme.primaryText, size: 24),
      ),
    );
  }

  /// ✅ **Progress Bar Widget**
  Widget _buildProgressBar(RecipeAppTheme theme, int activeStep) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.alternateColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressCircle(theme, activeStep >= 1),
          _buildProgressLine(theme),
          _buildProgressCircle(theme, activeStep >= 2),
          _buildProgressLine(theme),
          _buildProgressCircle(theme, activeStep >= 3),
        ],
      ),
    );
  }


  /// ✅ Progress Circle: Active is filled; inactive shows only accent border.
  Widget _buildProgressCircle(RecipeAppTheme theme, bool isActive) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor : Colors.transparent,
        border: Border.all(color: theme.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  /// ✅ Progress Line Between Circles
  Widget _buildProgressLine(RecipeAppTheme theme) {
    return Container(
      width: 20,
      height: 3,
      color: theme.primaryColor,
    );
  }
}
