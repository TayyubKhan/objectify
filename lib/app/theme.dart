import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.orange; // Light Blue
  static const Color secondary = Color(0xFFFFFFFF); // White
  static const Color background = Color(0xFFE3F2FD); // Light Blue Background
  static const Color accent = Colors.orangeAccent; // Dark Blue Accent
  static const Color textPrimary = Colors.white; // Dark Blue Text
  static const Color textSecondary = Color(0xFFFFFFFF); // White Text
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      background: AppColors.background,
    ),
    iconTheme: IconThemeData(color: AppColors.secondary),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
    ),
  );
}
