import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_font_weights.dart';

abstract class AppStyles {
  static TextStyle get font24BoldPrimary => TextStyle(
    fontSize: 24.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font24BoldBlack => TextStyle(
    fontSize: 24.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font20BoldPrimary => TextStyle(
    fontSize: 20.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font20BoldBlack => TextStyle(
    fontSize: 20.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font18BoldPrimary => TextStyle(
    fontSize: 18.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font18BoldBlack => TextStyle(
    fontSize: 18.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font18MediumBlack => TextStyle(
    fontSize: 18.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.black,
  );

  static TextStyle get font16BoldWhite => TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.white,
  );

  static TextStyle get font16BoldPrimary => TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font16BoldBlack => TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font16SemiBoldBlack => TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.black,
  );

  static TextStyle get font16MediumGray => TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textGray,
  );

  static TextStyle get font16RegularGray => TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );

  static TextStyle get font15BoldPrimary => TextStyle(
    fontSize: 15.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font15MediumSubtitle => TextStyle(
    fontSize: 15.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.subtitleGray,
  );

  static TextStyle get font15RegularSubtitle => TextStyle(
    fontSize: 15.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.subtitleGray,
  );

  static TextStyle get font14BoldPrimary => TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font14BoldBlack => TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font14MediumPrimary => TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.primary,
  );

  static TextStyle get font14MediumBlack => TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.black,
  );

  static TextStyle get font14MediumGray => TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textGray,
  );

  static TextStyle get font14RegularGray => TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );

  static TextStyle get font14RegularSubtitle => TextStyle(
    fontSize: 14.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.subtitleGray,
  );

  static TextStyle get font13BoldPrimary => TextStyle(
    fontSize: 13.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font13MediumPrimary => TextStyle(
    fontSize: 13.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.primary,
  );

  static TextStyle get font13MediumGray => TextStyle(
    fontSize: 13.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textGray,
  );

  static TextStyle get font13RegularSubtitle => TextStyle(
    fontSize: 13.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.subtitleGray,
  );

  static TextStyle get font12BoldPrimary => TextStyle(
    fontSize: 12.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font12BoldWhite => TextStyle(
    fontSize: 12.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.white,
  );

  static TextStyle get font12MediumPrimary => TextStyle(
    fontSize: 12.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.primary,
  );

  static TextStyle get font12RegularGray => TextStyle(
    fontSize: 12.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );

  static TextStyle get font12RegularSubtitleStrikethrough => TextStyle(
    fontSize: 12.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.subtitleGray,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle get font11RegularGray => TextStyle(
    fontSize: 11.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );

  static TextStyle get font10RegularGray => TextStyle(
    fontSize: 10.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );
}

typedef AppTextStyles = AppStyles;
