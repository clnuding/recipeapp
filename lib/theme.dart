import 'package:flutter/material.dart';

class RecipeThemeData {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color.fromARGB(255, 234, 244, 244),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 107, 144, 128),
    ),
    extensions: [
      /// COLORS
      RecipeColors(
        accent: Color.fromARGB(255, 107, 144, 128),
        accentSecondary: Color.fromARGB(255, 204, 227, 222),
        textPrimary: Colors.white,
        textSecondary: Colors.white70,
        textTertiary: Colors.white60,
      ),

      /// TEXT STYLES
      RecipeTextStyles(
        bodySmallPrimary: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodySmallSecondary: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
      ),
    ],
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
      bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
    ),
  );
}

// CUSTOM COLORS EXTENSION
@immutable
class RecipeColors extends ThemeExtension<RecipeColors> {
  final Color? accent;
  final Color? accentSecondary;
  final Color? textPrimary;
  final Color? textSecondary;
  final Color? textTertiary;

  const RecipeColors({
    required this.accent,
    this.accentSecondary,
    this.textPrimary,
    this.textSecondary,
    this.textTertiary,
  });

  @override
  RecipeColors copyWith({Color? accent, Color? danger, Color? success}) {
    return RecipeColors(
      accent: accent ?? this.accent,
      accentSecondary: accentSecondary,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textTertiary: textTertiary,
    );
  }

  @override
  RecipeColors lerp(ThemeExtension<RecipeColors>? other, double t) {
    if (other is! RecipeColors) return this;
    return RecipeColors(
      accent: Color.lerp(accent, other.accent, t),
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t),
    );
  }
}

// CUSTOM TEXT STYLES EXTENSION
@immutable
class RecipeTextStyles extends ThemeExtension<RecipeTextStyles> {
  final TextStyle? bodySmallPrimary;
  final TextStyle? bodySmallSecondary;

  const RecipeTextStyles({
    required this.bodySmallPrimary,
    required this.bodySmallSecondary,
  });

  @override
  RecipeTextStyles copyWith({
    TextStyle? bodySmallPrimary,
    TextStyle? bodySmallSecondary,
    TextStyle? bodySmallTertiary,
  }) {
    return RecipeTextStyles(
      bodySmallPrimary: bodySmallPrimary ?? this.bodySmallPrimary,
      bodySmallSecondary: bodySmallSecondary ?? this.bodySmallSecondary,
    );
  }

  @override
  RecipeTextStyles lerp(ThemeExtension<RecipeTextStyles>? other, double t) {
    if (other is! RecipeTextStyles) return this;
    return RecipeTextStyles(
      bodySmallPrimary: TextStyle.lerp(
        bodySmallPrimary,
        other.bodySmallPrimary,
        t,
      ),
      bodySmallSecondary: TextStyle.lerp(
        bodySmallSecondary,
        other.bodySmallSecondary,
        t,
      ),
    );
  }
}
