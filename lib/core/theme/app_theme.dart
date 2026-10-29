import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_styles.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: AppStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.card,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    cardTheme: const CardThemeData(color: AppColors.card, elevation: 0),
  );
}
