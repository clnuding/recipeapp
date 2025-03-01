import 'package:flutter/material.dart';
import 'package:recipeapp/components/card.dart';
import 'package:recipeapp/components/listitem.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/page/settings.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  RecipesPageState createState() => RecipesPageState();
}

class RecipesPageState extends State<RecipesPage> {
  List<Recipe> _filteredRecipes = [];
  List<Recipe> _allRecipes = [];
  bool _isLoading = true;
  bool _showRecipesListView = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _loadSettings();
  }

  void reloadRecipes() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      _loadRecipes();
      _loadSettings();
    }
  }

  Future<void> _loadSettings() async {
    bool preference = await getRecipesViewPreference();
    setState(() {
      _showRecipesListView = preference;
    });
  }

  Future<void> _loadRecipes() async {
    try {
      List<Map<String, dynamic>> recipesJSON = [
        {
          "title": "Recipe1",
          "description": "Description1",
          "image_url":
              "https://www.healthbenefitstimes.com/glossary/wp-content/uploads/2020/08/Recipe.jpg",
        },
        {
          "title": "Recipe2",
          "description": "Description2",
          "image_url":
              "https://www.healthbenefitstimes.com/glossary/wp-content/uploads/2020/08/Recipe.jpg",
        },
      ];
      List<Recipe> recipes =
          recipesJSON.map((json) => Recipe.fromJson(json)).toList();
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching recipes: $e");
    }
  }

  void _filterRecipes(String query) {
    setState(() {
      _filteredRecipes =
          _allRecipes
              .where(
                (recipe) =>
                    recipe.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar + Square Button
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
                child: Row(
                  children: [
                    // Search Field
                    Expanded(
                      child: TextField(
                        onChanged: _filterRecipes,
                        decoration: InputDecoration(
                          hintText: "Filter Recipes...",
                          hintStyle: const TextStyle(color: Colors.white60),
                          suffixIcon: const Icon(
                            Icons.filter_list,
                            color: Colors.white70,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 191, 105, 0),
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.black.withValues(alpha: 0.3),
                        ),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: const Color.fromARGB(255, 191, 105, 0),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ), // Space between search and button
                    // Square Add Button
                    Container(
                      height: 55, // Same height as the search bar
                      width: 55, // Square shape
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          print("Add button pressed");
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Recipe List or Grid View
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _filteredRecipes.isEmpty
                        ? const Center(
                          child: Text(
                            "No recipes found",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : _showRecipesListView
                        ? _buildListView()
                        : _buildGridView(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        return RecipeListItem(recipe: _filteredRecipes[index], onTap: () {});
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(recipe: _filteredRecipes[index], onTap: () {});
      },
    );
  }
}
