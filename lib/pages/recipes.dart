import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/base/theme.dart'; // Provides RecipeAppTheme
import 'package:recipeapp/pages/widgets/recipe_item_list.dart'; // List View
import 'package:recipeapp/pages/widgets/recipe_item_tiles.dart'; // Grid View

// Global PocketBase client.
final pb = PocketBase('http://127.0.0.1:8090');

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<RecordModel> _allRecipes = [];
  List<RecordModel> _filteredRecipes = [];
  bool _isLoading = true;
  String _error = '';
  bool _isGridView = false; // ✅ Toggle state for List/Grid View

  @override
  void initState() {
    super.initState();
    _loadViewPreference(); // ✅ Load the saved view mode
    _fetchRecipes();
    _searchController.addListener(_filterRecipes);
  }

  // ✅ Load the last selected view from SharedPreferences
  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGridView = prefs.getBool('isGridView') ?? false;
    });
  }

  // ✅ Save the selected view to SharedPreferences
  Future<void> _saveViewPreference(bool isGrid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGridView', isGrid);
  }

  Future<void> _fetchRecipes() async {
    try {
      final List<RecordModel> records =
          await pb.collection('recipes_user').getFullList();
      setState(() {
        _allRecipes = records;
        _filteredRecipes = records;
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
      _filteredRecipes = query.isEmpty
          ? _allRecipes
          : _allRecipes.where((record) {
              final name = (record.data['name'] ?? '').toString().toLowerCase();
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
    final Color backgroundColor = theme.alternateColor; // ✅ Use theme background color for buttons

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 16, right: 16), // ✅ Consistent padding
        child: Column(
          children: [
            // ✅ Search Bar + Toggle Button + Add Recipe Button
            Row(
              children: [
                // ✅ Compact Search Bar
                Expanded(
                  child: Container(
                    height: 40, // ✅ Reduced height for a sleeker look
                    decoration: BoxDecoration(
                      color: backgroundColor, // ✅ Use alternateColor for background
                      borderRadius: BorderRadius.circular(7.0), // ✅ Rounded corners
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: theme.primaryText),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), // ✅ Adjusted padding
                        hintText: "Search Recipes",
                        hintStyle: TextStyle(color: theme.primaryText.withOpacity(0.6)),
                        border: InputBorder.none, // ✅ No border
                        prefixIcon: Icon(Icons.search, color: theme.primaryText.withOpacity(0.6)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // ✅ Toggle Button (Switch Between List/Grid) with Background
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: backgroundColor, // ✅ Same background as search bar
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isGridView ? Icons.list : Icons.grid_view,
                      color: theme.primaryText, // ✅ Use theme text color
                    ),
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                        _saveViewPreference(_isGridView); // ✅ Save user preference
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // ✅ Add Recipe Button with Background
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/create_recipe'),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: backgroundColor, // ✅ Same background as search bar
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Icon(
                      Icons.add,
                      color: theme.primaryText, // ✅ Use theme text color
                      size: 28, // ✅ Adjusted size for better visibility
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // ✅ Space between search bar & list/grid

            // ✅ Recipe List / Grid View (Now perfectly aligned with search bar)
            Expanded(
              child: _isGridView
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


//add different grouping options + filter options by tag types