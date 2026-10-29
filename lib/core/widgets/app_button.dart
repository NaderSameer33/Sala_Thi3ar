import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'app_loading.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? borderRadius;
  final BorderSide? borderSide;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textStyle,
    this.borderRadius,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 55.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withAlpha(128),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        child: isLoading
            ? AppLoading(
                size: 24.r,
                color: AppColors.white,
              )
            : Text(
                text,
                style: textStyle ?? AppStyles.font15BoldWhite,
              ),
      ),
    );
  }
}
