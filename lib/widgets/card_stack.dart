import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/screens/main_screen.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/recipe_swipe_card.dart';

class SwipeCardStackScreen extends StatefulWidget {
  const SwipeCardStackScreen({super.key});

  @override
  State<SwipeCardStackScreen> createState() => _SwipeCardStackScreenState();
}

class _SwipeCardStackScreenState extends State<SwipeCardStackScreen> {
  final CardSwiperController controller = CardSwiperController();
  Set<Recipe> chosenRecipes = {};
  Set<Recipe> rejectedRecipes = {};

  final cards = recipes.map(RecipeSwipeCard.new).toList();
  late bool cardsEmpty;

  @override
  void initState() {
    super.initState();
    cardsEmpty = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: LogoAppbar(showBackButton: true),
      body: Center(
        child:
            cardsEmpty
                ? Stack(
                  children: [
                    Center(
                      child: Text(
                        "Alle Rezepte geswiplant!",
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
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
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
                      Flexible(
                        child: CardSwiper(
                          controller: controller,
                          cardsCount: cards.length,
                          isLoop: false,
                          onSwipe: _onSwipe,
                          onUndo: _onUndo,
                          onEnd:
                              () => setState(() {
                                cardsEmpty = true;
                              }),
                          allowedSwipeDirection:
                              AllowedSwipeDirection.symmetric(horizontal: true),
                          numberOfCardsDisplayed: 4,
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
      rejectedRecipes.add(cards[previousIndex].recipe);
    } else {
      chosenRecipes.add(cards[previousIndex].recipe);
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
