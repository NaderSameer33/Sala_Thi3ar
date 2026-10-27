import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image.asset(
            'assets/images/app_logo.png',
            height: 125.h,
            fit: BoxFit.contain,
          ),
        ),
        24.verticalSpacing,
        Text(
          'مرحبا بك مرة أخرى',
          style: AppStyles.font18BoldPrimary.copyWith(
            color: AppColors.primary,
          ),
        ),
        6.verticalSpacing,
        Text(
          'يمكنك تسجيل الدخول الآن',
          style: AppStyles.font14RegularGray,
        ),
      ],
    );
  }
}
