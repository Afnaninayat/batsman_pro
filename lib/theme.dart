import 'package:flutter/material.dart';

class AppTheme {
  static const Color goldLight = Color(0xFFEABC5C);
  static const Color goldDark = Color(0xFFD7942E);
  static const Color accent = Color(0xFFFFE000);
  static const Color dark = Color(0xFF3C280D);
  static const Color background = Color(0xFF000000);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: goldLight,
      fontFamily: 'Poppins', // optional but looks professional

      colorScheme: const ColorScheme.dark(
        primary: goldLight,
        secondary: goldDark,
        background: background,
        surface: Color(0xFF121212),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: goldLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: goldLight,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: goldLight, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldLight,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          shadowColor: goldDark.withOpacity(0.4),
          elevation: 8,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: goldLight,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
      ),
    );
  }
}
