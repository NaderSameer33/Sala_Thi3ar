import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class OnboardingFeaturesRow extends StatelessWidget {
  const OnboardingFeaturesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _BuildFeatureItem(icon: Icons.eco_outlined, label: 'طازج 100%'),
        _BuildFeatureItem(
          icon: Icons.electric_bolt_outlined,
          label: 'توصيل سريع',
        ),
        _BuildFeatureItem(
          icon: Icons.verified_user_outlined,
          label: 'جودة مضمونة',
        ),
      ],
    );
  }
}

class _BuildFeatureItem extends StatelessWidget {
  const _BuildFeatureItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryTint.withAlpha(120),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.primary),
          4.horizontalSpacing,
          Text(label, style: AppStyles.font12MediumPrimary),
        ],
      ),
    );
  }
}
