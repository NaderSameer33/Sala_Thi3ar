import 'package:flutter/material.dart';
import 'app_colors.dart';

class DarkTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Tajawal',
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkScaffold,
      cardColor: AppColors.darkSurface,
      canvasColor: AppColors.darkInputFill,
      dividerColor: AppColors.darkBorder,
      hintColor: AppColors.subtitleGray,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        surfaceContainerHighest: AppColors.darkSurface,
        surfaceContainerLow: AppColors.darkInputFill,
        outline: AppColors.darkBorder,
        onSurface: AppColors.white,
        onSurfaceVariant: AppColors.subtitleGray,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkScaffold,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
      ),
    );
  }
}
