import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel item;

  const OnboardingPageItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 250.r,
                height: 250.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryTint.withAlpha(180),
                      AppColors.primaryTint.withAlpha(20),
                    ],
                  ),
                ),
              ),
              Lottie.asset(
                item.lottiePath,
                height: 260.h,
                width: 260.w,
                fit: BoxFit.contain,
              ),
            ],
          ),
          24.verticalSpacing,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.primary.withAlpha(40),
              ),
            ),
            child: Text(
              item.badge,
              style: AppStyles.font12MediumPrimary,
            ),
          ),
          16.verticalSpacing,
          Text(
            item.title,
            style: AppStyles.font20BoldDark,
            textAlign: TextAlign.center,
          ),
          12.verticalSpacing,
          Text(
            item.subtitle,
            style: AppStyles.font14RegularGray.copyWith(
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
