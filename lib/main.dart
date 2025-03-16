import 'package:flutter/material.dart';
import 'package:recipeapp/pages/sign_in.dart';
import 'package:recipeapp/pages/sign_up.dart';
import 'package:recipeapp/pages/main_screen.dart';
import 'package:recipeapp/pages/add_recipe.dart' as add_recipe;
import 'package:recipeapp/pages/add_ingredient.dart' as add_ingredient;
import 'package:recipeapp/pages/review_recipe.dart' as review_recipe; // ✅ Import the review page
import 'package:recipeapp/base/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: RecipeAppTheme().themeData, // Using your centralized custom theme
      initialRoute: '/signIn',
      routes: {
        '/signIn': (context) => const SignInPage(),
        '/signUp': (context) => const CreateAccountPage(),
        '/main': (context) => const MainScreen(),
        '/create_recipe': (context) => const add_recipe.AddRecipePage(),
        '/addIngredient': (context) => add_ingredient.AddIngredientPage(recipeId: 'dummy_recipe_id'),
        '/reviewRecipe': (context) => const review_recipe.RecipeReviewPage(), // ✅ Add this route
      },
    );
  }
}
