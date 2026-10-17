import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? icon;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 60.h;
    final effectiveRadius = borderRadius ?? 15.r;
    final effectiveBgColor = backgroundColor ??
        (isOutlined ? AppColors.transparent : AppColors.primary);
    final effectiveBorderColor = borderColor ?? AppColors.primary;

    return SizedBox(
      width: width ?? double.infinity,
      height: effectiveHeight,
      child: Material(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(effectiveRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(effectiveRadius),
              border: isOutlined
                  ? Border.all(color: effectiveBorderColor, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: isLoading
                ? SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOutlined ? AppColors.primary : AppColors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        title,
                        style: textStyle ??
                            (isOutlined
                                ? AppStyles.font16BoldPrimary
                                : AppStyles.font16BoldWhite),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
