import 'package:flutter/material.dart';
import 'package:recipeapp/page/home.dart';
import 'package:recipeapp/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: RecipeThemeData.lightTheme,
      home: HomeScreen(),
    );
  }
}
