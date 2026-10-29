import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/extension/spacing_extension.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        10.verticalSpacing,
        Hero(
          tag: 'app_logo',
          child: Image.asset(
            'assets/images/app_logo.png',
            height: 85.h,
            fit: BoxFit.contain,
          ),
        ),
        12.verticalSpacing,
        Text(
          'سلة ثمار',
          style: AppStyles.font24BoldDark,
        ),
        8.verticalSpacing,
        Text(
          'سلتك المتكاملة لكل ما تحتاجه من خضروات وفواكه طازجة يومياً بأعلى جودة وأفضل سعر',
          textAlign: TextAlign.center,
          style: AppStyles.font14RegularGray,
        ),
        16.verticalSpacing,
      ],
    );
  }
}
