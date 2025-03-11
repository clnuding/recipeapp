// import 'package:flutter/material.dart';
// import 'package:recipeapp/base/theme.dart';

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
//     final theme = RecipeAppTheme(); // Access custom theme

//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background color
//           Container(color: theme.primaryBackground),
//           // Render the child on top
//           Container(
//             color: Colors.transparent,
//             child: child,
//           ),
//         ],
//       ),
//       bottomNavigationBar: showNavBar
//           ? BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               currentIndex: selectedIndex,
//               selectedItemColor: theme.primaryColor,
//               unselectedItemColor: theme.alternateColor,
//               backgroundColor: Colors.transparent,
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
