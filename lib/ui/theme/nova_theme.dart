import 'package:flutter/material.dart';

/// Nova visual identity — deep midnight base, Furina teal accents, archon gold trim.
class NovaTheme {
  static const Color background    = Color(0xFF080D1A);
  static const Color surface       = Color(0xFF0F1829);
  static const Color surfaceLight  = Color(0xFF162236);
  static const Color accent        = Color(0xFF4DC8D4);
  static const Color accentGlow    = Color(0xFF7EEAF2);
  static const Color gold          = Color(0xFFD4A843);
  static const Color goldLight     = Color(0xFFF0CC77);
  static const Color textPrimary   = Color(0xFFE8F0F8);
  static const Color textSecondary = Color(0xFF8AA4BE);
  static const Color error         = Color(0xFFE05C6A);

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentGlow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: accent, secondary: gold, surface: surface, error: error,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimary,   fontSize: 32, fontWeight: FontWeight.w700),
      titleLarge:   TextStyle(color: textPrimary,   fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium:  TextStyle(color: textPrimary,   fontSize: 16, fontWeight: FontWeight.w500),
      bodyLarge:    TextStyle(color: textPrimary,   fontSize: 15, height: 1.5),
      bodyMedium:   TextStyle(color: textSecondary, fontSize: 13, height: 1.4),
      labelSmall:   TextStyle(color: textSecondary, fontSize: 11, letterSpacing: 0.8),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: surfaceLight, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accent, width: 1.5),
      ),
      hintStyle: const TextStyle(color: textSecondary),
    ),
  );
}
