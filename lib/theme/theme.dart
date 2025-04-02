import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration with light and dark themes
/// All customizable colors, typography, and spacing are defined here
class SpoonSparkTheme {
  // ==================== COLOR PALETTE ====================
  // =======================================================

  // Primary color
  static const Color _primary = Color.fromARGB(255, 249, 97, 103);
  // static const Color _primary = Color.fromARGB(255, 255, 178, 64);
  // static const Color _primary = Color.fromARGB(255, 255, 168, 38);
  // static const Color _primary = Color.fromARGB(255, 0, 146, 98);
  static final Color _primaryDisabled = _primary.withValues(alpha: 0.6);

  // Background colors
  static const Color _backgroundAccent = Color.fromARGB(255, 229, 222, 209);
  static const Color _backgroundMuted = Color.fromARGB(255, 240, 237, 234);
  static const Color _backgroundLight = Color.fromARGB(255, 255, 255, 255);

  // Text colors
  static const Color _primaryTextLight = Color.fromARGB(255, 28, 28, 28);
  static const Color _secondaryTextLight = Color.fromARGB(117, 117, 117, 117);
  static const Color _textOnPrimaryLight = Color.fromARGB(255, 255, 255, 255);
  static const Color _foregroundMuted = Color.fromARGB(117, 117, 117, 117);
  static const Color _divider = Color.fromARGB(255, 224, 224, 244);

  // Error / Success colors
  static const Color _error = Color.fromARGB(255, 255, 90, 79);
  // static const Color _success = Color.fromARGB(255, 50, 201, 151);

  // ==================== TYPOGRAPHY =======================
  // =======================================================
  // Font families
  static String primaryFontFamily = 'Roboto';
  // static String secondaryFontFamily = 'Urbanist';

  // Font weights
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Font sizes
  static const double fontXS = 10.0;
  static const double fontSM = 13.0;
  static const double fontS = 14.0;
  static const double fontM = 16.0;
  static const double fontL = 18.0;
  static const double fontXL = 22.0;
  static const double fontXXL = 24.0;

  // Text Styles
  static TextStyle label = GoogleFonts.getFont(
    primaryFontFamily,
    fontSize: fontXS,
    fontWeight: fontWeightRegular,
    color: _primaryTextLight,
  );

  static TextStyle labelLarge = GoogleFonts.getFont(
    primaryFontFamily,
    fontSize: fontSM,
    fontWeight: fontWeightRegular,
    color: _primaryTextLight,
  );

  static TextStyle bodySmall = GoogleFonts.getFont(
    primaryFontFamily,
    fontSize: fontS,
    fontWeight: fontWeightRegular,
    color: _primaryTextLight,
  );

  static TextStyle bodyRegular = GoogleFonts.getFont(
    primaryFontFamily,
    fontSize: fontM,
    fontWeight: fontWeightMedium,
    color: _primaryTextLight,
  );

  static TextStyle bodyMedium = GoogleFonts.getFont(
    primaryFontFamily,
    fontSize: fontM,
    fontWeight: fontWeightMedium,
    color: _primaryTextLight,
  );

  static TextStyle subheading = GoogleFonts.getFont(
    primaryFontFamily,
    fontSize: fontL,
    fontWeight: fontWeightSemibold,
    color: _primaryTextLight,
  );

  static TextStyle headingRegular = GoogleFonts.getFont(
    primaryFontFamily,
    fontSize: fontXL,
    fontWeight: fontWeightRegular,
    color: _primaryTextLight,
  );

  static TextStyle heading = GoogleFonts.getFont(
    primaryFontFamily,
    fontSize: fontXXL,
    fontWeight: fontWeightSemibold,
    color: _primaryTextLight,
  );

  // ==================== SPACING ==========================
  // =======================================================
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 18.0;
  static const double spacingXXL = 24.0;

  // ==================== Radius ==========================
  // ======================================================
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 10.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 14.0;
  static const double radiusXXL = 16.0;
  static const double radiusR = 30.0;

  // ==================== LIGHT THEME ====================
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _primary,
        onPrimary: _textOnPrimaryLight,
        secondary: _primaryTextLight,
        onSecondary: _textOnPrimaryLight,
        secondaryContainer: _backgroundAccent,
        onSecondaryContainer: _textOnPrimaryLight,
        error: _error,
        onError: _textOnPrimaryLight,
        surface: _backgroundLight,
        onSurface: _primaryTextLight,
        surfaceBright: _backgroundMuted,
        onSurfaceVariant: _primaryTextLight,
        tertiary: _foregroundMuted,
      ),
      textTheme: _buildTextTheme(isLight: true),
      scaffoldBackgroundColor: _backgroundLight,
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: _backgroundMuted,
        titleTextStyle: bodySmall.copyWith(fontWeight: fontWeightSemibold),
        subtitleTextStyle: labelLarge.copyWith(
          color: _primaryTextLight.withValues(alpha: 0.7),
        ),
        iconColor: _primary,
        contentPadding: EdgeInsets.symmetric(horizontal: spacingL),
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        enableFeedback: false,
        minLeadingWidth: 30,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: _primary,
          disabledBackgroundColor: _primaryDisabled,
          elevation: 0,
          overlayColor: Colors.white12,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: _primary, width: 2),
            borderRadius: BorderRadius.circular(radiusR),
          ),
          textStyle: bodySmall.copyWith(
            color: _textOnPrimaryLight,
            fontWeight: fontWeightSemibold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _primary, width: 2),
          minimumSize: const Size(double.infinity, 50),
          padding: EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusR),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: fontXL,
          foregroundColor: _primaryTextLight.withValues(alpha: 0.9),
          padding: EdgeInsets.all(spacingXS),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
        ),
      ),
      iconTheme: IconThemeData(color: _primaryTextLight, size: fontXL),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingM,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: bodySmall.copyWith(
          color: _primaryTextLight.withValues(alpha: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: _divider),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: _divider),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingS,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _backgroundLight,
        elevation: 0,
        foregroundColor: _primaryTextLight,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _backgroundLight,
        selectedItemColor: _primary,
        unselectedItemColor: _secondaryTextLight,
      ),
      dividerTheme: DividerThemeData(
        color: _divider,
        thickness: 1,
        space: spacingL,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primary;
          }
          return Colors.grey[50];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primary.withValues(alpha: 0.5);
          }
          return _divider;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: _foregroundMuted),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXS),
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primary;
          }
          return null;
        }),
      ),
    );
  }

  // Build text theme based on light or dark mode
  static TextTheme _buildTextTheme({required bool isLight}) {
    return TextTheme(
      headlineLarge: heading,
      headlineMedium: headingRegular,
      titleLarge: subheading,
      bodyLarge: bodyMedium,
      bodyMedium: bodyRegular,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
    );
  }
}
