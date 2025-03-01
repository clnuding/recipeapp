import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recipeapp/components/bottom_bar.dart';
import 'package:recipeapp/components/scrollcard.dart';
import 'package:recipeapp/page/recipes.dart';
import 'package:recipeapp/page/settings.dart';

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
    return Stack(
      children: [
        /// Background image covering the whole screen including bottom bar area
        Positioned.fill(
          child: Image.asset(
            'assets/images/recipeapp_bg.jpg',
            fit: BoxFit.cover, // Ensures full coverage
          ),
        ),

        // Blur Effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),
        ),

        /// Main content with blur effect
        Scaffold(
          backgroundColor:
              Colors.transparent, // Make Scaffold background transparent
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: GlassBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
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
