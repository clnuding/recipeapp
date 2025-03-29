import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeAppTheme {
  RecipeAppTheme._(); // Private constructor for singleton pattern

  static final RecipeAppTheme _instance = RecipeAppTheme._();

  factory RecipeAppTheme() {
    return _instance;
  }

  static RecipeAppTheme of(BuildContext context) {
    return _instance;
  }

  // Brand and utility colors
  final Color primaryColor = const Color.fromARGB(255, 152, 138, 104);
  //golden middle brownish Color.fromARGB(255, 152, 138, 104);
  final Color alternateColor = const Color.fromARGB(255, 255, 255, 255);
  //const Color.fromARGB(255, 224, 224, 224);
  final Color primaryText = const Color.fromARGB(255, 63, 60, 60);
  final Color primaryBackground = Color.fromARGB(255, 240, 237, 234);

  // ignore: prefer_typing_uninitialized_variables
  var error;

  // Text styles
  TextStyle get title1 => GoogleFonts.urbanist(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryText,
      );

  TextStyle get bodyText1 => GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: primaryText,
      );

  TextStyle get bodySmall => GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: primaryText,
      );

  TextStyle get bodyMedium => GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: primaryText,
      );

  TextStyle get displaySmall => GoogleFonts.urbanist(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: primaryText,
      );

  // Theme data
  ThemeData get themeData => ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: primaryBackground,
        textTheme: TextTheme(
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          displaySmall: displaySmall,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: title1.copyWith(color: primaryBackground),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: primaryText,
          surface: primaryBackground,
        ),
      );

  get alternate => null;
}

extension TextStyleExtension on TextStyle {
  TextStyle override({
    String? fontFamily,
    double? fontSize,
    double? letterSpacing,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return copyWith(
      fontFamily: fontFamily,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
