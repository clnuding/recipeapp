import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';

/// A widget that displays a stack of cards based on a list of recipes.
/// The top card is swipeable. Swiping to left (endToStart) will add the recipe
/// to [chosenRecipes] and show a green toast, and swiping right (startToEnd)
/// will add it to [rejectedRecipes].
class RecipeSwipeCardStack extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeSwipeCardStack({Key? key, required this.recipes})
    : super(key: key);

  @override
  _RecipeSwipeCardStackState createState() => _RecipeSwipeCardStackState();
}

class _RecipeSwipeCardStackState extends State<RecipeSwipeCardStack> {
  // Lists to keep track of chosen and rejected recipes.
  List<Recipe> chosenRecipes = [];
  List<Recipe> rejectedRecipes = [];

  // List of recipes remaining to be swiped.
  late List<Recipe> remainingRecipes;

  @override
  void initState() {
    super.initState();
    // Create a copy of the original list.
    remainingRecipes = List.from(widget.recipes);
  }

  /// Show a toast message when a recipe is chosen.
  void showChosenToast(String recipeTitle) {
    final theme = Theme.of(context);
    Fluttertoast.showToast(
      msg: "you want to eat: " + recipeTitle,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: theme.colorScheme.tertiaryFixed,
      textColor: theme.colorScheme.onTertiaryFixed,
      fontSize: SpoonSparkTheme.fontM,
    );
  }

  /// Build the individual recipe card.
  Widget buildCard(Recipe recipe) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.9;
    final double cardHeight = MediaQuery.of(context).size.height * 0.7;

    return Container(
      margin: const EdgeInsets.all(16),
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Consistent shadow on all borders
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            recipe.title,
            style: const TextStyle(fontSize: 24),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppbar(showBackButton: true),
      body: Center(
        child:
            remainingRecipes.isEmpty
                ? const Text("No more recipes")
                : Stack(
                  alignment: Alignment.center,
                  children:
                      remainingRecipes.asMap().entries.map((entry) {
                        int index = entry.key;
                        Recipe recipe = entry.value;
                        // The top card is the last in the list.
                        bool isTopCard = index == remainingRecipes.length - 1;
                        // Calculate a horizontal offset for non-top cards.
                        // The top card remains centered (offset = 0).
                        double offsetX =
                            isTopCard
                                ? 0
                                : 0.0 * (remainingRecipes.length - 1 - index);
                        double offsetY =
                            isTopCard
                                ? 0
                                : -0.0 * (remainingRecipes.length - 1 - index);
                        Widget cardWidget = buildCard(recipe);

                        if (isTopCard) {
                          cardWidget = Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              setState(() {
                                remainingRecipes.remove(recipe);
                                if (direction == DismissDirection.endToStart) {
                                  // Swiped left – add to chosen recipes.
                                  chosenRecipes.add(recipe);
                                  showChosenToast(recipe.title);
                                } else if (direction ==
                                    DismissDirection.startToEnd) {
                                  // Swiped right – add to rejected recipes.
                                  rejectedRecipes.add(recipe);
                                }
                              });
                            },
                            // Background for swiping right (revealed when swiping left)
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                radius: 20,
                                child: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                            // Secondary background for swiping left (revealed when swiping right)
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 20,
                                child: Icon(Icons.check, color: Colors.white),
                              ),
                            ),
                            child: cardWidget,
                          );
                        } else {
                          cardWidget = Transform.translate(
                            offset: Offset(offsetX, offsetY),
                            child: cardWidget,
                          );
                        }

                        return cardWidget;
                      }).toList(),
                ),
      ),
    );
  }
}
