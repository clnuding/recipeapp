import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipeapp/base/theme.dart';
import 'package:recipeapp/api/recipes.dart'; // ✅ API logic
import 'package:recipeapp/models/recipe.dart'; // ✅ Recipe model
import 'package:recipeapp/widgets/recipe_item_list.dart';
import 'package:recipeapp/widgets/recipe_item_tiles.dart';
import 'package:recipeapp/api/pb_client.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  String _error = '';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _loadViewPreference();
    _loadRecipes();
    _searchController.addListener(_filterRecipes);
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
      final recipes = await fetchRecipes(); // ✅ pulls from api/recipes.dart
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
    final theme = RecipeAppTheme.of(context);
    final Color backgroundColor = theme.alternateColor;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
        child: Column(
          children: [
            // ✅ Top Bar: Search, Toggle, Add
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: theme.primaryText),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        hintText: "Search Recipes",
                        hintStyle: TextStyle(
                          color: theme.primaryText.withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.primaryText.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isGridView ? Icons.list : Icons.grid_view,
                      color: theme.primaryText,
                    ),
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                        _saveViewPreference(_isGridView);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/create_recipe'),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Icon(Icons.add, color: theme.primaryText, size: 28),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ✅ Recipe List / Grid
            Expanded(
              child:
                  _isGridView
                      ? RecipeItemTiles(
                        recipes: _filteredRecipes,
                        error: _error,
                        isLoading: _isLoading,
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
    );
  }
}
