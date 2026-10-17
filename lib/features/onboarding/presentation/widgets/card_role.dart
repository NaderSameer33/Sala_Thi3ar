import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/theme/app_font_weights.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class CardRole extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CardRole({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.18)
        : colorScheme.surfaceContainerLow;

    final borderColor = isSelected
        ? colorScheme.primary
        : colorScheme.outline;

    final iconBgColor = isSelected
        ? colorScheme.primary
        : colorScheme.surface;

    final titleColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurface;

    final subtitleColor = colorScheme.onSurfaceVariant;

    final iconColor = isSelected
        ? colorScheme.onPrimary
        : colorScheme.primary;

    final checkColor = isSelected
        ? colorScheme.primary
        : theme.hintColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28.r,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: AppFontWeights.bold,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppStyles.font12RegularGray.copyWith(
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: checkColor,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}
