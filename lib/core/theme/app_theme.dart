import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Theme A: Velvet Sunset (Dark / Staff & Manager)
  static final ThemeData darkTheme = _buildVelvetSunsetTheme();

  // Theme B: Bistro Peach (Light / Customer)
  static final ThemeData freshTheme = _buildBistroPeachTheme();

  static ThemeData _buildVelvetSunsetTheme() {
    final Color background = const Color(0xFF1A1616); // Deep Velvet Dark
    final Color primary = const Color(0xFFFFAB91); // Sunset Orange/Pink Accent
    final Color secondary = const Color(0xFFD84315); // Deep Orange
    final Color onPrimary = const Color(0xFF2D1200); // Dark text on accent
    final Color surface = const Color(0xFF2D2A2A); // Slightly lighter surface
    final Color onSurface = const Color(0xFFEDE0D4); // Soft white text

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: onSurface,
        onPrimary: onPrimary,
        error: const Color(0xFFCF6679),
        surfaceContainerHighest: surface, // For form fields
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: onSurface.withOpacity(0.7)),
        hintStyle: TextStyle(color: onSurface.withOpacity(0.5)),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      dividerColor: primary.withOpacity(0.2),
    );
  }

  static ThemeData _buildBistroPeachTheme() {
    final Color background = const Color(0xFFFFFFFF); // Pure White
    final Color primary = const Color(0xFFFFDAB9); // Peach Accent (Light)
    final Color primaryDark = const Color(
      0xFFFFAB91,
    ); // Darker Peach/Sunset for text visibility
    final Color secondary = const Color(0xFFFFCCBC); // Soft Peach
    final Color onBackground = const Color(0xFF4E342E); // Brown/Dark Text
    final Color surface = const Color(0xFFFFF5F0); // Very light peach surface

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary:
            primaryDark, // Use darker peach for better contrast on white if needed, or stick to requested
        secondary: secondary,
        surface: surface,
        onSurface: onBackground,
        onPrimary: onBackground, // Dark text on light peach
        error: const Color(0xFFB00020),
        surfaceContainerHighest: surface, // For form fields
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: onBackground,
        displayColor: onBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onBackground,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onBackground,
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: primaryDark, width: 1.5),
        ),
        labelStyle: TextStyle(color: onBackground.withOpacity(0.7)),
        hintStyle: TextStyle(color: onBackground.withOpacity(0.5)),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shadowColor: primary.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      dividerColor: primaryDark.withOpacity(0.2),
    );
  }
}
