import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';

class DontHaveAccountRow extends StatelessWidget {
  final VoidCallback onTap;

  const DontHaveAccountRow({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب ؟ ',
          style: AppStyles.font14RegularGray.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'تسجيل الآن',
            style: AppStyles.font14BoldPrimary,
          ),
        ),
      ],
    );
  }
}
