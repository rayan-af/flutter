import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Theme A: Midnight Cobalt (Premium Dark / Staff & Manager)
  static final ThemeData darkTheme = _buildJapandiTheme();

  // Theme B: Bistro Peach (Light / Customer) - Kept mostly unchanged but polished
  static final ThemeData freshTheme = _buildBistroPeachTheme();

  static ThemeData _buildJapandiTheme() {
    // Japandi Dark Theme Colors
    final Color background = const Color(0xFF121212); // True Dark
    final Color primary = const Color(0xFF4A6B53);    // Soft Forest Green #4A6B53
    final Color onPrimary = const Color(0xFFFFFFFF);
    final Color secondary = const Color(0xFF8B948B);
    final Color onSecondary = const Color(0xFF1B261D);
    final Color surface = const Color(0xFF1E1E1E);
    final Color surfaceContainerLow = const Color(0xFF1A1A1A);
    final Color surfaceContainerHigh = const Color(0xFF2A2A2A);
    final Color surfaceContainerHighest = const Color(0xFF333333);
    final Color onSurface = const Color(0xFFEBEBE9);  // Light Text
    final Color outline = const Color(0xFF555555);
    
    // Status Colors
    final Color error = const Color(0xFFCF6679);
    final Color onError = const Color(0xFF000000);
    final Color tertiary = const Color(0xFFDEB887); // Accent wood color

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        tertiary: tertiary,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: onError,
        surfaceContainerHighest: surfaceContainerHighest, // For form fields
      ),
      textTheme: GoogleFonts.manropeTextTheme(ThemeData(brightness: Brightness.dark).textTheme).apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary, 
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: primary,
          letterSpacing: -0.5,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28), // Minimalist rounded caps
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 2,
          shadowColor: primary.withValues(alpha: 0.1), 
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHighest.withValues(alpha: 0.5), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24), 
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: primary, width: 2.0),
        ),
        labelStyle: GoogleFonts.inter(color: outline, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: outline, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerHigh,
        elevation: 0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ), 
        margin: const EdgeInsets.all(8),
      ),
      dividerColor: outline.withValues(alpha: 0.2),
      iconTheme: IconThemeData(color: primary),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  static ThemeData _buildBistroPeachTheme() {
    // Keeping existing light theme as fallback/customer view
    final Color background = const Color(0xFFFFFFFF);
    final Color primary = const Color(0xFFFFDAB9);
    final Color primaryDark = const Color(0xFFFFAB91);
    final Color secondary = const Color(0xFFFFCCBC);
    final Color onBackground = const Color(0xFF4E342E);
    final Color surface = const Color(0xFFFFF5F0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: primaryDark,
        secondary: secondary,
        surface: surface,
        onSurface: onBackground,
        onPrimary: onBackground,
        error: const Color(0xFFB00020),
        surfaceContainerHighest: surface,
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
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryDark, width: 1.5),
        ),
        labelStyle: TextStyle(color: onBackground.withOpacity(0.7)),
        hintStyle: TextStyle(color: onBackground.withOpacity(0.5)),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shadowColor: primary.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      dividerColor: primaryDark.withOpacity(0.2),
    );
  }
}
