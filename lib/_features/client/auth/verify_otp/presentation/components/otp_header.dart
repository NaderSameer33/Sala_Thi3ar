import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';

class OtpHeader extends StatelessWidget {
  final String title;
  final String phone;

  const OtpHeader({
    super.key,
    this.title = 'نسيت كلمة المرور',
    required this.phone,
  });

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
          title,
          style: AppStyles.font18BoldPrimary.copyWith(
            color: AppColors.primary,
          ),
        ),
        6.verticalSpacing,
        Text(
          'أدخل الكود المكون من 4 أرقام المرسل علي رقم الجوال',
          style: AppStyles.font14RegularGray,
        ),
        6.verticalSpacing,
        Row(
          children: [
            Text(
              '+$phone',
              style: AppStyles.font14RegularGray.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
              textDirection: TextDirection.ltr,
            ),
            8.horizontalSpacing,
            GestureDetector(
              onTap: () => context.pop(),
              child: Text(
                'تغيير رقم الجوال',
                style: AppStyles.font14BoldPrimary.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
