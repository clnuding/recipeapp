import 'package:flutter/material.dart';
import 'package:recipeapp/api/tags.dart';
import 'package:recipeapp/screens/add_recipe.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/filterbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipeapp/api/recipes.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/widgets/atomics/recipe_item_list.dart';
import 'package:recipeapp/widgets/atomics/recipe_item_tiles.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<String> _selectedMealTypes = [];
  List<String> _selectedCategories = [];
  List<String> _selectedSeasons = [];

  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  String _error = '';
  bool _isGridView = false;
  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
    _searchController.addListener(_filterRecipes);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      _didLoad = true;
      _loadRecipes();
    }
  }

  bool get _hasFilterActive =>
      _selectedMealTypes.isNotEmpty ||
      _selectedCategories.isNotEmpty ||
      _selectedSeasons.isNotEmpty;

  void _showFilterSheet() async {
    final theme = Theme.of(context);
    final tags = await fetchTags(); // get tags from backend

    final mealTypes = tags.where((t) => t.category == 'meal_type').toList();
    final recipeCategories =
        tags.where((t) => t.category == 'meal_category').toList();
    final recipeSeasons = tags.where((t) => t.category == 'season').toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Rezepte filtern", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),

                  // Meal Type Dropdown
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value:
                        _selectedMealTypes.isEmpty
                            ? null
                            : _selectedMealTypes.first,
                    items:
                        mealTypes.map((tag) {
                          return DropdownMenuItem(
                            value: tag.id,
                            child: Text(tag.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedMealTypes = value != null ? [value] : [];
                      });
                    },
                    decoration: const InputDecoration(labelText: "Art"),
                  ),

                  const SizedBox(height: 16),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value:
                        _selectedCategories.isEmpty
                            ? null
                            : _selectedCategories.first,
                    items:
                        recipeCategories.map((tag) {
                          return DropdownMenuItem(
                            value: tag.id,
                            child: Text(tag.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedCategories = value != null ? [value] : [];
                      });
                    },
                    decoration: const InputDecoration(labelText: "Kategorie"),
                  ),

                  const SizedBox(height: 16),

                  // Season Dropdown
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value:
                        _selectedSeasons.isEmpty
                            ? null
                            : _selectedSeasons.first,
                    items:
                        recipeSeasons.map((tag) {
                          return DropdownMenuItem(
                            value: tag.id,
                            child: Text(tag.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedSeasons = value != null ? [value] : [];
                      });
                    },
                    decoration: const InputDecoration(labelText: "Saison"),
                  ),

                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedMealTypes.clear();
                        _selectedCategories.clear();
                        _selectedSeasons.clear();
                        _filteredRecipes = _allRecipes; // Reset to full list
                      });
                      Navigator.of(context).pop(); // Close the modal
                    },
                    child: Text(
                      "Filter zurücksetzen",
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: () {
                      _applyTagFilter();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text("Anwenden"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _applyTagFilter() {
    setState(() {
      _filteredRecipes =
          _allRecipes.where((recipe) {
            final tags = recipe.tagId ?? [];

            final matchesMeal =
                _selectedMealTypes.isEmpty ||
                tags.any(_selectedMealTypes.contains);
            final matchesCat =
                _selectedCategories.isEmpty ||
                tags.any(_selectedCategories.contains);
            final matchesSeason =
                _selectedSeasons.isEmpty || tags.any(_selectedSeasons.contains);

            return matchesMeal && matchesCat && matchesSeason;
          }).toList();
    });
  }

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGridView = prefs.getBool('isGridView') ?? false;
    });
  }

  Future<void> _saveViewPreference(bool isGrid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGridView', isGrid);
  }

  Future<void> _loadRecipes() async {
    if (!pb.authStore.isValid) {
      setState(() {
        _error = 'User not authenticated.';
        _isLoading = false;
      });
      return;
    }

    try {
      final recipes = await fetchRecipes();
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes =
          query.isEmpty
              ? _allRecipes
              : _allRecipes.where((recipe) {
                final name = recipe.title.toLowerCase();
                return name.contains(query);
              }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: LogoAppbar(
        showBackButton: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: SpoonSparkTheme.spacingL - 8),
            child: IconButton(
              icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                  _saveViewPreference(_isGridView);
                });
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpoonSparkTheme.spacingL,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: SpoonSparkTheme.spacingXS,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilterBar(
                      controller: _searchController,
                      hintText: 'Filter Recipes',
                      onFilterPressed: _showFilterSheet,
                      isFilterActive: _hasFilterActive, // ✅ this shows the dot
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SpoonSparkTheme.spacingS),
            Expanded(
              child:
                  _isGridView
                      ? RecipeItemTiles(
                        recipes: _filteredRecipes,
                        error: _error,
                        isLoading: _isLoading,
                        onChanged: _loadRecipes,
                      )
                      : RecipeItemList(
                        recipes: _filteredRecipes,
                        error: _error,
                        isLoading: _isLoading,
                      ),
            ),
          ],
        ),
      ),

      // ✅ Reserve space so button floats above BottomNavbar
      bottomNavigationBar: const SizedBox(height: 80),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(), // 👈 Ensures it's a circle
        elevation: 0, // 👈 Removes shadow
        highlightElevation: 0, // 👈 Removes tap shadow
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => AddRecipePage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
