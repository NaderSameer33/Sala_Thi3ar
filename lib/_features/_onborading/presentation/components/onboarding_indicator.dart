import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 26.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primaryTint,
            borderRadius: BorderRadius.circular(10.r),
          ),
        );
      }),
    );
  }
}
