import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipeapp/api/recipes.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/ingredients_grid.dart';
import 'package:recipeapp/widgets/on_image_tag.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Recipe> recipe;
  final String? cookingTime = "30";
  final List<String> tags = [
    'Vegan',
    'Gluten-Free',
    'Dinner',
    'Vegan',
    'Gluten-Free',
    'Dinner',
    'Vegan',
    'Gluten-Free',
    'Dinner',
  ];
  final String? description =
      'A healthy and delicious vegan dinner recipe perfect for weeknights.';

  @override
  void initState() {
    super.initState();
    recipe = _fetchRecipeById();
  }

  // Async function to fetch manga details
  Future<Recipe> _fetchRecipeById() async {
    final recipe = await fetchRecipeById(widget.recipeId);
    return recipe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'spoon',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 2),
            // SVG Logo
            SvgPicture.asset('assets/logos/spoonspark_logo.svg', height: 25),
            const SizedBox(width: 2),
            const Text(
              'spark',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        backgroundColor: lightBackground,
        elevation: 0,
      ),
      body: FutureBuilder<Recipe>(
        future: recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "No details about this Manga found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          Recipe _recipe = snapshot.data!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 1.9,
                        child: Stack(
                          children: [
                            // Original Image
                            Image.network(
                              _recipe.thumbnailUrl ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),

                            // Cooking Time Tag (Only shown if time is not null)
                            if (_recipe.cookingTime != null)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: OnImageTag(
                                  icon: Icons.access_time,
                                  text: '${_recipe.cookingTime} min',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Horizontally Scrollable Genres Section
                  SizedBox(
                    height: 25,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ), // Glass effect
                            child: Container(
                              decoration: BoxDecoration(
                                color: secondary.withValues(
                                  alpha: 0.8,
                                ), // Light transparent white
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              child: Text(
                                tags.isNotEmpty ? tags[index] : "N/A",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Expandable Summary Content Section
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(12),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withValues(alpha: 0.1),
                  //           spreadRadius: 1,
                  //           blurRadius: 3,
                  //           offset: const Offset(0, 1),
                  //         ),
                  //       ],
                  //     ),
                  //     child: LayoutBuilder(
                  //       builder: (context, constraints) {
                  //         return Padding(
                  //           padding: const EdgeInsets.all(12.0),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 description ?? "N/A",
                  //                 maxLines: _isExpanded ? null : 2,
                  //                 overflow:
                  //                     _isExpanded
                  //                         ? TextOverflow.visible
                  //                         : TextOverflow.ellipsis,
                  //                 style: const TextStyle(
                  //                   fontSize: 14,
                  //                   color: Colors.black,
                  //                 ),
                  //               ),
                  //               Align(
                  //                 alignment: Alignment.centerLeft,
                  //                 child: GestureDetector(
                  //                   onTap: () {
                  //                     setState(() {
                  //                       _isExpanded = !_isExpanded;
                  //                     });
                  //                   },
                  //                   child: Container(
                  //                     padding: const EdgeInsets.only(top: 5),
                  //                     child: Text(
                  //                       _isExpanded ? "less" : "more",
                  //                       style: const TextStyle(
                  //                         color: primary,
                  //                         fontWeight: FontWeight.bold,
                  //                         fontSize: 14,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 25),
                  IngredientsGrid(
                    initialServings: 2,
                    ingredients: [
                      {
                        'name': 'Tomato',
                        'measurement': 2.0,
                        'measurementName': 'pcs',
                        'group': 'vegetables',
                      },
                      {
                        'name': 'Chicken Breast',
                        'measurement': 150.0,
                        'measurementName': 'g',
                        'group': 'meat',
                      },
                      {
                        'name': 'Cheese',
                        'measurement': 50.0,
                        'measurementName': 'g',
                        'group': 'dairy',
                      },
                      {
                        'name': 'Tomato',
                        'measurement': 2.0,
                        'measurementName': 'pcs',
                        'group': 'vegetables',
                      },
                      {
                        'name': 'Chicken Breast',
                        'measurement': 150.0,
                        'measurementName': 'g',
                        'group': 'meat',
                      },
                      {
                        'name': 'Brauner Champignon',
                        'measurement': 50.0,
                        'measurementName': 'g',
                        'group': 'dairy',
                      },
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
