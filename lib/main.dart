import 'package:flutter/material.dart';
import 'package:recipeapp/screens/main_screen.dart';
import 'package:recipeapp/screens/add_recipe.dart' as add_recipe;
import 'package:recipeapp/screens/add_ingredient.dart' as add_ingredient;
import 'package:recipeapp/screens/review_recipe.dart'
    as review_recipe; // ✅ Import the review page
import 'package:recipeapp/base/theme.dart';
import 'package:recipeapp/screens/recipe_details.dart';
import 'package:recipeapp/screens/signin.dart';
import 'package:recipeapp/screens/signup.dart';
import 'package:recipeapp/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: RecipeAppTheme().themeData, // Using your centralized custom theme
      initialRoute: '/splash',
      routes: {
        // '/signIn': (context) => const SignInScreen(),
        '/splash': (context) => const SplashScreen(),
        '/signIn': (context) => const SignInScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/main': (context) => const MainScreen(),
        '/create_recipe': (context) => const add_recipe.AddRecipePage(),
        '/addIngredient':
            (context) =>
                add_ingredient.AddIngredientPage(recipeId: 'dummy_recipe_id'),
        '/reviewRecipe':
            (context) =>
                const review_recipe.RecipeReviewPage(), // ✅ Add this route
      },
    );
  }
}
