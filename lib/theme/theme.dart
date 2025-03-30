import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration with light and dark themes
/// All customizable colors, typography, and spacing are defined here
class SpoonSparkTheme {
  // ==================== COLORS ====================
  // Primary colors
  static const Color _primaryLight = Color(0xFF6200EE);
  static const Color _primaryVariantLight = Color(0xFF3700B3);
  static const Color _primary = Color.fromARGB(255, 156, 140, 117);

  // Secondary colors
  static const Color _secondary = Color.fromARGB(255, 208, 200, 189);
  static const Color _secondaryVariantLight = Color(0xFF018786);

  // Background colors
  static const Color _backgroundLight = Color.fromARGB(255, 240, 237, 234);

  // Surface colors
  static const Color _surfaceLight = Color(0xFFFFFFFF);
  static const Color _borderMuted = Colors.grey;

  // Error colors
  static const Color _errorLight = Color(0xFFB00020);

  // Text colors
  static const Color _textOnPrimary = Color(0xDEFFFFFF); // 87% opacity
  static const Color _textPrimaryLight = Color(0xDE000000); // 87% opacity
  static const Color _textSecondaryLight = Color(0x99000000); // 60% opacity
  static const Color _textDisabledLight = Color(0x61000000); // 38% opacity
  static const Color _textPrimaryDark = Color(0xDEFFFFFF); // 87% opacity
  static const Color _textSecondaryDark = Color(0x99FFFFFF); // 60% opacity
  static const Color _textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  // ==================== SPACING ====================
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing15 = 15.0;
  static const double spacing16 = 16.0;
  static const double spacing18 = 18.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // ==================== RADIUS ====================
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusNormal = 10.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 14.0;
  static const double radiusXXLarge = 16.0;

  // ==================== FONTS ====================
  // Default font families
  static String primaryFontFamily = 'Urbanist';
  static String secondaryFontFamily = 'Roboto';

  // Font sizes
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeNormal = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeDisplay = 34.0;

  // Font weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // ==================== LIGHT THEME ====================
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _primary,
        onPrimary: _textOnPrimary,
        primaryContainer: _primaryVariantLight,
        onPrimaryContainer: Colors.white,
        secondary: _secondary,
        onSecondary: Colors.black,
        secondaryContainer: _secondaryVariantLight,
        onSecondaryContainer: Colors.white,
        error: _errorLight,
        onError: Colors.white,
        surface: _backgroundLight,
        onSurface: _textPrimaryLight,
        onSurfaceVariant: Colors.white,
        tertiary: _borderMuted,
      ),
      textTheme: _buildTextTheme(isLight: true),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.white,
        titleTextStyle: TextStyle(
          color: _textPrimaryLight,
          fontSize: fontSizeNormal,
          fontWeight: fontWeightMedium,
        ),
        iconColor: _primary,
        contentPadding: EdgeInsets.symmetric(horizontal: spacing16),
        style: ListTileStyle.drawer,
        horizontalTitleGap: spacing12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        enableFeedback: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: _primary,
          disabledBackgroundColor: _secondary,
          padding: EdgeInsets.symmetric(
            horizontal: spacing12,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusNormal),
          ),
          textStyle: TextStyle(
            color: _textOnPrimary,
            fontSize: fontSizeNormal,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: fontSizeLarge,
          padding: EdgeInsets.all(spacing8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusNormal),
          ),
        ),
      ),
      iconTheme: IconThemeData(color: _primary, size: fontSizeNormal),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _borderMuted),
          minimumSize: const Size(double.infinity, 50),
          padding: EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: spacing12,
            vertical: spacing12,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _backgroundLight,
        elevation: 0,
        foregroundColor: _textPrimaryLight,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _surfaceLight,
        selectedItemColor: _primaryLight,
        unselectedItemColor: _textSecondaryLight,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey[300],
        thickness: 1,
        space: spacing16,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryLight;
          }
          return Colors.grey[50];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryLight.withValues(alpha: 0.5);
          }
          return Colors.grey[400];
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: _borderMuted),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryLight;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryLight;
          }
          return null;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: _primaryLight,
        thumbColor: _primaryLight,
        inactiveTrackColor: _primaryLight.withValues(alpha: 0.3),
      ),
    );
  }

  // Build text theme based on light or dark mode
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? _textPrimaryLight : _textPrimaryDark;
    final Color textSecondary =
        isLight ? _textSecondaryLight : _textSecondaryDark;
    final Color textDisabled = isLight ? _textDisabledLight : _textDisabledDark;

    // You can use GoogleFonts for easy font integration
    // Or you can use your custom fonts after adding them to pubspec.yaml
    return TextTheme(
      displayLarge: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: 96,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: 60,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: 48,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: fontSizeXXLarge,
        fontWeight: fontWeightBold,
        letterSpacing: 0.25,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: fontSizeXLarge,
        fontWeight: fontWeightSemibold,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: 18,
        fontWeight: fontWeightSemibold,
        letterSpacing: 0.15,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: 16,
        fontWeight: fontWeightMedium,
        letterSpacing: 0.15,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: 14,
        fontWeight: fontWeightMedium,
        letterSpacing: 0.1,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.getFont(
        secondaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.getFont(
        secondaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textPrimary,
      ),
      bodySmall: GoogleFonts.getFont(
        secondaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.getFont(
        secondaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.getFont(
        primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelSmall: GoogleFonts.getFont(
        secondaryFontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.25,
        color: textDisabled,
      ),
    );
  }
}
