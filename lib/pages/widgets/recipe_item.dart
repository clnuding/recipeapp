// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:recipeapp/base/theme.dart'; // Ensure RecipeAppTheme is properly imported

// class RecipeListItemWidget extends StatelessWidget {
//   final String recipeName;
//   final String imageUrl;

//   const RecipeListItemWidget({
//     super.key,
//     required this.recipeName,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Retrieve theme properties
//     final theme = RecipeAppTheme.of(context);
//     final primaryTextColor = theme.primaryText; // Text color should match the theme
//     final primaryBackground = theme.primaryBackground; // Background color from theme
//     final borderColor = theme.alternateColor; // Border color from theme

//     // Get screen width
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Container(
//       width: screenWidth * 0.95,
//       height: 80,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           // Left side: Recipe image
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(10),
//               bottomLeft: Radius.circular(10),
//             ),
//             child: Image.network(
//               imageUrl,
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Right side: Recipe name container
//           Expanded(
//             child: InkWell(
//               splashColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               onTap: () {
//                 HapticFeedback.lightImpact();
//                 // Add navigation or other onTap behavior if needed
//               },
//               child: Container(
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: primaryBackground, // ✅ Set background from theme
//                   border: Border.all(
//                     color: borderColor, // ✅ Use theme color for border
//                     width: 1,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(10),
//                     bottomRight: Radius.circular(10),
//                   ),
//                 ),
//                 padding: const EdgeInsets.only(left: 10),
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   recipeName.isNotEmpty ? recipeName : 'n/a',
//                   style: TextStyle(
//                     color: primaryTextColor, // ✅ Use theme color for text
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600, // Improve readability
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
