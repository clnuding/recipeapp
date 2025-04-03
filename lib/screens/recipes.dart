import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/filterbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipeapp/api/recipes.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/widgets/atomics/recipe_item_list.dart';
import 'package:recipeapp/widgets/atomics/recipe_item_tiles.dart';
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
      appBar: LogoAppbar(showBackButton: false),
      backgroundColor: theme.colorScheme.surface,
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
                    ),
                  ),

                  const SizedBox(width: SpoonSparkTheme.spacingS),

                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusR,
                      ),
                    ),
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

                  const SizedBox(width: SpoonSparkTheme.spacingXS),

                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        SpoonSparkTheme.radiusM,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
                      onPressed:
                          () => Navigator.pushNamed(context, '/create_recipe'),
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
