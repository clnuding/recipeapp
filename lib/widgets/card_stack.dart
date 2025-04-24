import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/api/recipes.dart';
import 'package:recipeapp/screens/main_screen.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/recipe_swipe_card.dart';

class SwipeCardStackScreen extends StatefulWidget {
  final String userId;
  final String householdId;

  const SwipeCardStackScreen({
    super.key,
    required this.userId,
    required this.householdId,
  });

  @override
  State<SwipeCardStackScreen> createState() => _SwipeCardStackScreenState();
}

class _SwipeCardStackScreenState extends State<SwipeCardStackScreen> {
  final CardSwiperController controller = CardSwiperController();
  Set<String> chosenRecipes = {};
  Set<String> rejectedRecipes = {};

  late final List<RecipeSwipeCard> cards;
  late bool cardsEmpty;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadRecipeCards();
    cardsEmpty = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadRecipeCards() async {
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
        cards = recipes.map(RecipeSwipeCard.new).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Save recipe selections for the current user.
  Future<void> _saveRecipeSelections() async {
    await mpService.insertRecipeSelection(chosenRecipes.toList());

    // mark user selection as complete, check if all users in a household
    // have completed their selection, and set meal plan to 'finalized'
    // afterwards finalzing meal plan an deriving the shopping list
    await mpService.markUserSelectionAsCompleted();

    // After saving individual selections, check if all household users have completed their selection.
    // If so, create the final meal plan.
    // bool householdCompleted =
    //     await mpService.checkHouseholdSelectionsCompleted();
    // if (householdCompleted) {
    //   await mpService.finalizeMealPlan();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(child: Text("Error: $_error"));
    }

    if (cards.isEmpty) {
      return Center(child: Text("No recipes found."));
    }

    return Scaffold(
      appBar: LogoAppbar(showBackButton: false),
      body: Center(
        child:
            cardsEmpty
                ? Stack(
                  children: [
                    Center(
                      child: Text(
                        "Du bist durch alle Rezepte durch!",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SizedBox(
                          width: 250,
                          child: PrimaryButton(
                            text: "Back to Homepage",
                            onPressed:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
                                  (route) => false,
                                ),
                            icon: Icons.home,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : SafeArea(
                  child: Column(
                    children: [
                      Text(
                        '2. Wähle deine Rezepte',
                        style: theme.textTheme.headlineMedium,
                      ),
                      Flexible(
                        child: CardSwiper(
                          controller: controller,
                          cardsCount: cards.length,
                          isLoop: false,
                          onSwipe: _onSwipe,
                          onUndo: _onUndo,
                          onEnd: () async {
                            _saveRecipeSelections();
                            setState(() {
                              cardsEmpty = true;
                            });
                          },
                          allowedSwipeDirection:
                              AllowedSwipeDirection.symmetric(horizontal: true),
                          numberOfCardsDisplayed: min(cards.length, 4),
                          backCardOffset: const Offset(25, 35),
                          padding: const EdgeInsets.all(
                            SpoonSparkTheme.spacingXXL,
                          ),
                          cardBuilder:
                              (
                                context,
                                index,
                                horizontalThresholdPercentage,
                                verticalThresholdPercentage,
                              ) => cards[index],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(SpoonSparkTheme.spacingL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FloatingActionButton(
                              key: const Key("reject"),
                              heroTag: "rejectBtn",
                              shape: const CircleBorder(),
                              onPressed:
                                  () => {
                                    controller.swipe(CardSwiperDirection.left),
                                  },
                              child: const Icon(Icons.close_rounded),
                            ),
                            SizedBox(
                              width: 45,
                              height: 45,
                              child: FloatingActionButton(
                                key: const Key("undo"),
                                heroTag: "undoBtn",
                                backgroundColor: theme.colorScheme.tertiary,
                                shape: const CircleBorder(),
                                onPressed: () => controller.undo(),
                                child: const Icon(
                                  Icons.rotate_left,
                                  size: SpoonSparkTheme.fontL,
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              key: const Key("accept"),
                              heroTag: "acceptBtn",
                              backgroundColor: theme.colorScheme.tertiaryFixed,
                              shape: const CircleBorder(),
                              onPressed:
                                  () => controller.swipe(
                                    CardSwiperDirection.right,
                                  ),
                              child: const Icon(Icons.check_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction.name == "left") {
      rejectedRecipes.add(cards[previousIndex].recipe.id);
    } else {
      chosenRecipes.add(cards[previousIndex].recipe.id);
    }
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    // debugPrint('The card $currentIndex was undod from the ${direction.name}');
    return true;
  }
}
