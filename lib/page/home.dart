import 'package:flutter/material.dart';
import 'package:recipeapp/components/scrollcard.dart';
import 'package:recipeapp/page/recipes.dart';
import 'package:recipeapp/page/settings.dart';
import 'package:recipeapp/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define a GlobalKey for HomePage's State
  final GlobalKey<RecipesPageState> _recipePageKey =
      GlobalKey<RecipesPageState>();

  // Pages List
  List<Widget> _pages = [MainScreen(), RecipesPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _pages = [MainScreen(), RecipesPage(key: _recipePageKey), ProfilePage()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        _recipePageKey.currentState
            ?.reloadRecipes(); // Access the state method safely
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<RecipeColors>()!;

    return Stack(
      children: [
        /// Main content with blur effect
        Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: themeColors.accent,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                selectedItemColor: themeColors.accent!,
                unselectedItemColor: themeColors.accentSecondary!,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                iconSize: 25,
                type: BottomNavigationBarType.fixed,
                enableFeedback: false, // Disables the tap animation effect
                selectedFontSize: 10, // Prevents font from animating
                unselectedFontSize: 10, // Keeps it consistent
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.food_bank_rounded),
                    label: 'Recipes',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Map<String, String>> sampleData = [
    {
      'thumbnail':
          'https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-008.jpg',
      'title': 'This is a long recipe name or so',
      'subheading': 'Breakfast',
    },
    {
      'thumbnail':
          'https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-008.jpg',
      'title': 'Card Title 2',
      'subheading': 'Lunch',
    },
    {
      'thumbnail':
          'https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-008.jpg',
      'title': 'Card Title 3',
      'subheading': 'Snack',
    },
    {
      'thumbnail':
          'https://www.acouplecooks.com/wp-content/uploads/2019/05/Chopped-Salad-008.jpg',
      'title': 'Card Title 4',
      'subheading': 'Dinner',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollableCardSection(headline: 'Monday', items: sampleData),
            ScrollableCardSection(headline: 'Tuesday', items: sampleData),
            ScrollableCardSection(headline: 'Wednesday', items: sampleData),
            ScrollableCardSection(headline: 'Thursday', items: sampleData),
          ],
        ),
      ),
    );
  }
}
