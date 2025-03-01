// import 'package:flutter/material.dart';
// import 'package:recipeapp/base/theme.dart' as CustomTheme;

// class AppScaffold extends StatelessWidget {
//   final Widget child;
//   final int selectedIndex;
//   final ValueChanged<int> onTap;
//   final bool showNavBar;

//   const AppScaffold({
//     super.key,
//     required this.child,
//     required this.selectedIndex,
//     required this.onTap,
//     this.showNavBar = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final customTheme = CustomTheme.RecipeAppTheme.of(context);
//     return Scaffold(
//       body: child,
//       bottomNavigationBar: showNavBar
//           ? BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               currentIndex: selectedIndex,
//               // Selected items use the primary color (golden yellow).
//               selectedItemColor: Theme.of(context).primaryColor,
//               // Unselected items use the custom theme's primaryText color.
//               unselectedItemColor: customTheme.primaryText,
//               onTap: onTap,
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.calendar_today),
//                   label: 'Meal Planning',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.restaurant_menu),
//                   label: 'Recipes',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.shopping_cart),
//                   label: 'Groceries',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.account_circle),
//                   label: 'Account',
//                 ),
//               ],
//             )
//           : null,
//     );
//   }
// }

// 

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recipeapp/base/theme.dart' as CustomTheme;

class AppScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool showNavBar;

  const AppScaffold({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onTap,
    this.showNavBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = CustomTheme.RecipeAppTheme.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image.
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1625631979614-7ab4aa53d600?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Apply a blur effect.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          // Render the child on top.
          Container(
            color: Colors.transparent,
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: showNavBar
          ? Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      currentIndex: selectedIndex,
                      selectedItemColor: Theme.of(context).primaryColor,
                      unselectedItemColor: customTheme.primaryText,
                      backgroundColor: Colors.transparent,
                      onTap: onTap,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_today),
                          label: 'Meal Planning',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.restaurant_menu),
                          label: 'Recipes',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart),
                          label: 'Groceries',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.account_circle),
                          label: 'Account',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
