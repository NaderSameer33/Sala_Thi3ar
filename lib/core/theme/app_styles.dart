import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_font_weights.dart';

abstract class AppStyles {
  static const String fontFamily = 'Tajawal';

  static TextStyle get font24BoldPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font24BoldBlack => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font20BoldPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font20BoldBlack => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font18BoldPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font18BoldBlack => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font18MediumBlack => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.black,
  );

  static TextStyle get font16BoldWhite => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.white,
  );

  static TextStyle get font16BoldPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font16BoldBlack => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font16SemiBoldBlack => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeights.semiBold,
    color: AppColors.black,
  );

  static TextStyle get font16MediumGray => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textGray,
  );

  static TextStyle get font16RegularGray => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );

  static TextStyle get font15BoldPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font15MediumSubtitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.subtitleGray,
  );

  static TextStyle get font15RegularSubtitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.subtitleGray,
  );

  static TextStyle get font14BoldPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font14BoldBlack => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.black,
  );

  static TextStyle get font14MediumPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.primary,
  );

  static TextStyle get font14MediumBlack => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.black,
  );

  static TextStyle get font14MediumGray => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textGray,
  );

  static TextStyle get font14RegularGray => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );

  static TextStyle get font14RegularSubtitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.subtitleGray,
  );

  static TextStyle get font13BoldPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font13MediumPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.primary,
  );

  static TextStyle get font13MediumGray => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textGray,
  );

  static TextStyle get font13RegularSubtitle => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.subtitleGray,
  );

  static TextStyle get font12BoldPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.primary,
  );

  static TextStyle get font12BoldWhite => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: AppFontWeights.bold,
    color: AppColors.white,
  );

  static TextStyle get font12MediumPrimary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: AppFontWeights.medium,
    color: AppColors.primary,
  );

  static TextStyle get font12RegularGray => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );

  static TextStyle get font12RegularSubtitleStrikethrough => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.subtitleGray,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle get font11RegularGray => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );

  static TextStyle get font10RegularGray => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.sp,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textGray,
  );
}

typedef AppTextStyles = AppStyles;
