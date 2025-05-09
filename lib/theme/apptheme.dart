import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    const primaryColor = Color(0xFF265E48);
    const primaryMedium = Color(0xFF1D8A39);
    const primaryLight = Color(0xFF80B029);
    const accentYellow = Color(0xFFFCC200);
    const background = Color(0xFFFAF9F6);
    // const surface = Color(0xFFFFFFFF);
    const border = Color(0xFFE0E0E0);
    const textPrimary = Color(0xFF212121);
    const textSecondary = Color(0xFF757575);

    const headlineStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: textPrimary,
    );

    const bodyStyle = TextStyle(fontSize: 16, color: textSecondary);

    const buttonStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: background,
    );

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: background,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryMedium,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: headlineStyle,
        bodyLarge: bodyStyle,
        labelLarge: buttonStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMedium,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: buttonStyle,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor),
        ),
        hintStyle: const TextStyle(color: textSecondary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: accentYellow,
        labelStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryFixed: primaryMedium,
        primaryContainer: primaryLight,
        secondary: accentYellow,
        // background: background,
        surface: background,
        error: Colors.redAccent,
      ),
    );
  }
}
