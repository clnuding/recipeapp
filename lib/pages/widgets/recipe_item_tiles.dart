import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/base/theme.dart';
import 'package:recipeapp/models/recipe.dart';

class RecipeItemTiles extends StatelessWidget {
  final List<RecordModel> recipes;
  final String error;
  final bool isLoading;

  const RecipeItemTiles({
    super.key,
    required this.recipes,
    required this.error,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(
        child: Text(
          "Error: $error",
          style: TextStyle(color: theme.primaryText),
        ),
      );
    }

    if (recipes.isEmpty) {
      return Center(
        child: Text(
          "No recipes found.",
          style: TextStyle(color: theme.primaryText),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // ✅ Two items per row
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final record = recipes[index];

        return RecipeCard(
          recipe: Recipe(
            title: record.data['name'] ?? 'Unnamed Recipe',
            // subheader: record.data['description'] ?? '',
            imageUrl: record.data['image'] ?? '',
          ),
        );
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeCard({super.key, required this.recipe, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = RecipeAppTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 242, 237), // ✅ Uses theme background color
          borderRadius: BorderRadius.circular(7),
          // boxShadow: [
          //   BoxShadow(
          //     color: theme.primaryText.withOpacity(0.1), // ✅ Uses theme shadow color
          //     blurRadius: 5,
          //     spreadRadius: 2,
          //     offset: const Offset(0, 3),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Image container (2/3 of the card)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                  ),
                  child: Image.network(
                    recipe.imageUrl.isNotEmpty
                        ? recipe.imageUrl
                        : 'https://via.placeholder.com/150', // ✅ Fallback image
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      color: theme.primaryText.withOpacity(0.5),
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Title and subtitle (1/3 of the card)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryText, // ✅ Uses theme text color
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // const SizedBox(height: 4),
                    // Text(
                    //   recipe.subheader ?? '',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: theme.alternateColor, // ✅ Uses theme subtitle color
                    //   ),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
