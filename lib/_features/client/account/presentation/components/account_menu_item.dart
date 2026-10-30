import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class AccountMenuItem extends StatelessWidget {
  final String title;
  final String? iconPath;
  final IconData? iconData;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showTrailingArrow;
  final Color? titleColor;

  const AccountMenuItem({
    super.key,
    required this.title,
    this.iconPath,
    this.iconData,
    this.onTap,
    this.trailing,
    this.showTrailingArrow = true,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            if (iconPath != null)
              Image.asset(
                iconPath!,
                width: 22.r,
                height: 22.r,
                fit: BoxFit.contain,
              )
            else if (iconData != null)
              Icon(iconData, size: 22.r, color: AppColors.primary),
            12.horizontalSpacing,
            Expanded(
              child: Text(
                title,
                style: AppStyles.font14BoldPrimary.copyWith(
                  color: titleColor ?? AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showTrailingArrow)
              Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 1.2.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 11.r,
                    color: AppColors.textLightGray,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
