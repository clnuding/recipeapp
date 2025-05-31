import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:recipeapp/screens/main_screen.dart';
import 'package:recipeapp/screens/add_ingredient.dart' as add_ingredient;
import 'package:recipeapp/screens/add_recipe.dart' as add_recipe;
import 'package:recipeapp/screens/recipes.dart';
import 'package:recipeapp/screens/review_recipe.dart' as review_recipe;
import 'package:recipeapp/screens/signin.dart';
import 'package:recipeapp/screens/signup.dart';
import 'package:recipeapp/screens/splash_screen.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/state/recipe_wizard_state.dart'; // 💡 Dein State

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecipeWizardState())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: SpoonSparkTheme.lightTheme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signIn': (context) => const SignInScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/main': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as int?;
          return MainScreen(initialTabIndex: args ?? 0);
        },
        '/create_recipe': (context) {
          if (!pb.authStore.isValid) {
            return const SignInScreen();
          } else {
            return const add_recipe.AddRecipePage();
          }
        },
        '/addIngredient': (context) => const add_ingredient.AddIngredientPage(),

        '/reviewRecipe': (context) => const review_recipe.RecipeReviewPage(),
        '/recipes': (context) => const RecipesPage(),
      },
    );
  }
}
