import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized app theme configuration
class AppTheme {
  /// Initialize theme configuration
  static Future<void> init() async {
    try {
      // Configure Google Fonts to load from asset bundle to avoid network issues
      GoogleFonts.config.allowRuntimeFetching = true;

      // Force loading of Montserrat font to avoid race conditions
      await GoogleFonts.pendingFonts([
        GoogleFonts.montserrat(),
      ]);
    } catch (e) {
      // Fallback to system fonts if Google Fonts fails
      debugPrint('Google Fonts initialization failed: $e');
    }
  }

  /// Get the main app theme
  static ThemeData get mainTheme {
    // Create a safe font
    final TextStyle safeFont = _getSafeFont();

    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textTheme: _textTheme,
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme,
      fontFamily: safeFont.fontFamily,
    );
  }

  /// Creates a safe font that won't crash if Google Fonts fails
  static TextStyle _getSafeFont() {
    try {
      return GoogleFonts.montserrat();
    } catch (e) {
      debugPrint('Error loading Google Font: $e');
      return const TextStyle(fontFamily: 'Roboto');
    }
  }

  // Color scheme
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black87,
    surfaceTint: Colors.white,
  );

  // App bar theme
  static final AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    centerTitle: true,
    titleTextStyle: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );

  // Elevated button theme
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  );

  // Text theme
  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.montserrat(
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.montserrat(
      color: Colors.white,
    ),
    bodySmall: GoogleFonts.montserrat(
      color: Colors.white,
    ),
  );

  // Card theme
  static final CardTheme _cardTheme = CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  // Dialog theme
  static final DialogTheme _dialogTheme = DialogTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
}
