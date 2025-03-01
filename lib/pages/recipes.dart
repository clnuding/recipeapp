import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/base/theme.dart'; // Provides RecipeAppTheme
import 'package:recipeapp/pages/widgets/recipe_item.dart'; // Custom list item widget

// Global PocketBase client.
final pb = PocketBase('http://127.0.0.1:8090');

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  // This function fetches all records from the "user_recipes" collection.
  Future<List<RecordModel>> fetchRecipes() async {
    final List<RecordModel> records =
        await pb.collection('user_recipes').getFullList();
    return records;
  }

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<RecordModel> _allRecipes = [];
  List<RecordModel> _filteredRecipes = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
    _searchController.addListener(filterRecipes);
  }

  Future<void> _fetchRecipes() async {
    try {
      final List<RecordModel> records =
          await pb.collection('user_recipes').getFullList();
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

  void filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredRecipes = _allRecipes;
      } else {
        _filteredRecipes = _allRecipes.where((record) {
          final name = (record.data['name'] ?? '').toString().toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve primaryText from custom theme.
    final primaryTextColor = RecipeAppTheme.of(context).primaryText;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(child: Text("Error: $_error"))
                : Padding(
                    padding: const EdgeInsets.only(top: 100), // Increased top padding.
                    child: Column(
                      children: [
                        // Search bar at the top.
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(color: primaryTextColor),
                            decoration: InputDecoration(
                              labelText: "Search Recipes",
                              labelStyle: TextStyle(color: primaryTextColor),
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.search,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Expanded list of recipes.
                        Expanded(
                          child: _filteredRecipes.isEmpty
                              ? const Center(child: Text("No recipes found."))
                              : ListView.builder(
                                  itemCount: _filteredRecipes.length,
                                  itemBuilder: (context, index) {
                                    final record = _filteredRecipes[index];
                                    final recipeName =
                                        record.data['name'] ?? 'Unnamed Recipe';
                                    final imageUrl = record.data['image'] ??
                                        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.0.3&q=80&w=1080';
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: RecipeListItemWidget(
                                        recipeName: recipeName,
                                        imageUrl: imageUrl,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Create Recipe page.
          Navigator.pushNamed(context, '/create_recipe');
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Center the FAB at bottom.
    );
  }
}
