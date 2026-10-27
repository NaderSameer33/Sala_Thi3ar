import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';

class RoleSelectionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryTint.withAlpha(90)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withAlpha(25)
                  : Colors.black.withAlpha(8),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.primaryTint,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.primary,
                size: 26.sp,
              ),
            ),
            14.horizontalSpacing,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: isSelected
                        ? AppStyles.font16BoldPrimary
                        : AppStyles.font16BoldDark,
                  ),
                  4.verticalSpacing,
                  Text(
                    description,
                    style: AppStyles.font13RegularGray,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            10.horizontalSpacing,
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textLightGray,
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16.sp,
                      color: AppColors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
