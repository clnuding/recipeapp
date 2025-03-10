import 'package:flutter/material.dart';
import 'package:recipeapp/components/alternative_card.dart';
import 'package:recipeapp/components/listitem.dart';
import 'package:recipeapp/components/searchbar.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/page/settings.dart';
import 'package:recipeapp/theme.dart';

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
          "subheader": "Subheader1",
          "image_url":
              "https://www.healthbenefitstimes.com/glossary/wp-content/uploads/2020/08/Recipe.jpg",
        },
        {
          "title": "Recipe2",
          "description": "Description2",
          "subheader": "Subheader2",
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
    final themeColors = Theme.of(context).extension<RecipeColors>()!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar + Square Button
              Padding(
                padding: const EdgeInsets.only(
                  top: 70,
                  left: 10,
                  right: 10,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    // Search Field
                    Expanded(
                      child: CustomSearchbar(
                        hintText: "Filter recipes ...",
                        icon: Icons.filter_list,
                        onChanged: _filterRecipes,
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ), // Space between search and button
                    // Square Add Button
                    Container(
                      height: 50,
                      width: 50, // Square shape
                      decoration: BoxDecoration(
                        color: themeColors.accent,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: Colors.white, size: 30),
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
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65, // Adjust based on card height
      ),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        return RecipeCard2(
          recipe: _filteredRecipes[index],

          onTap: () {
            print("Edit ${_filteredRecipes[index].title}");
          },
        );
      },
    );
  }
}
