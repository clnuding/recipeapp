import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipeapp/theme/theme_old.dart';

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
  static const Color _secondaryLight = Color(0xFF03DAC6);
  static const Color _secondaryVariantLight = Color(0xFF018786);

  // Background colors
  static const Color _backgroundLight = Color.fromARGB(255, 240, 237, 234);
  static const Color _whiteBackground = Color.fromARGB(255, 240, 237, 234);

  // Surface colors
  static const Color _surfaceLight = Color(0xFFFFFFFF);

  // Error colors
  static const Color _errorLight = Color(0xFFB00020);

  // Additional colors
  // static const Color _successLight = Color(0xFF4CAF50);
  // static const Color _successDark = Color(0xFF81C784);
  // static const Color _warningLight = Color(0xFFFFC107);
  // static const Color _warningDark = Color(0xFFFFD54F);
  // static const Color _infoLight = Color(0xFF2196F3);
  // static const Color _infoDark = Color(0xFF64B5F6);

  // Text colors
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
        onPrimary: Colors.white,
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
          backgroundColor: _primary,
          padding: EdgeInsets.symmetric(
            horizontal: spacing12,
            vertical: spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusNormal),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(spacing8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusNormal),
          ),
        ),
      ),
      iconTheme: IconThemeData(color: _primary, size: fontSizeNormal),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
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
        fontSize: 34,
        fontWeight: FontWeight.w400,
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
  // ==================== CUSTOM EXTENSION METHODS ====================
  // Extension methods to easily access theme values from context
//   static extension BuildContextThemeExtension on BuildContext {
//     // Colors
//     ColorScheme get colors => Theme.of(this).colorScheme;
    
//     // Text styles
//     TextTheme get textStyles => Theme.of(this).textTheme;
    
//     // Custom colors
//     Color get success => Theme.of(this).brightness == Brightness.light ? _successLight : _successDark;
//     Color get warning => Theme.of(this).brightness == Brightness.light ? _warningLight : _warningDark;
//     Color get info => Theme.of(this).brightness == Brightness.light ? _infoLight : _infoDark;
    
//     // Spacing
//     double get spacing2 => AppTheme.spacing2;
//     double get spacing4 => AppTheme.spacing4;
//     double get spacing8 => AppTheme.spacing8;
//     double get spacing12 => AppTheme.spacing12;
//     double get spacing16 => AppTheme.spacing16;
//     double get spacing24 => AppTheme.spacing24;
//     double get spacing32 => AppTheme.spacing32;
//     double get spacing48 => AppTheme.spacing48;
//     double get spacing64 => AppTheme.spacing64;
    
//     // Border radius
//     double get radiusSmall => AppTheme.radiusSmall;
//     double get radiusMedium => AppTheme.radiusMedium;
//     double get radiusLarge => AppTheme.radiusLarge;
//     double get radiusXLarge => AppTheme.radiusXLarge;
//   }
// }

// ==================== EXAMPLE USAGE ====================
// How to use this theme in your main.dart:
/*
import 'package:flutter/material.dart';
import 'path_to_theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system, // Use system theme, or specify ThemeMode.light or ThemeMode.dark
      home: HomePage(),
    );
  }
}

// Then in your widgets, you can use:
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: EdgeInsets.all(context.spacing16),
        child: Column(
          children: [
            Text(
              'Heading',
              style: context.textStyles.headlineSmall,
            ),
            SizedBox(height: context.spacing16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(context.spacing16),
                child: Text(
                  'This is a card with themed styling',
                  style: context.textStyles.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
