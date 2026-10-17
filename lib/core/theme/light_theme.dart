import 'package:flutter/material.dart';
import 'app_colors.dart';

class LightTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Tajawal',
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      cardColor: AppColors.cardBackground,
      canvasColor: AppColors.inputFill,
      dividerColor: AppColors.border,
      hintColor: AppColors.subtitleGray,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white,
        surfaceContainerHighest: AppColors.cardBackground,
        surfaceContainerLow: AppColors.inputFill,
        outline: AppColors.border,
        onSurface: AppColors.black,
        onSurfaceVariant: AppColors.textGray,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
      ),
    );
  }
}
