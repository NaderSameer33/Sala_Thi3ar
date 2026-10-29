import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';

class AlreadyHaveAccountRow extends StatelessWidget {
  final VoidCallback onTap;

  const AlreadyHaveAccountRow({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل ؟ ',
          style: AppStyles.font14RegularGray.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'تسجيل الدخول',
            style: AppStyles.font14BoldPrimary,
          ),
        ),
      ],
    );
  }
}
