import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipeapp/base/theme.dart'; // Make sure this exports RecipeAppTheme

class RecipeListItemWidget extends StatelessWidget {
  final String recipeName;
  final String imageUrl;

  const RecipeListItemWidget({
    Key? key,
    required this.recipeName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width.
    final screenWidth = MediaQuery.of(context).size.width;
    // Set a transparent white background for the right container.
    final containerColor = Colors.white.withOpacity(0.5);
    // Use the custom theme's primaryBackground as the text color.
    final textColor = RecipeAppTheme.of(context).primaryBackground;

    return Container(
      width: screenWidth * 0.95,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Left side: Recipe image.
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          // Right side: Recipe name container.
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                HapticFeedback.lightImpact();
                // Add navigation or other onTap behavior as needed.
              },
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: containerColor,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  recipeName.isNotEmpty ? recipeName : 'n/a',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
