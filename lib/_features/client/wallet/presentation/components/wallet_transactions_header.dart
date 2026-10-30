import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class WalletTransactionsHeader extends StatelessWidget {
  final VoidCallback onSeeAllTap;

  const WalletTransactionsHeader({
    super.key,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'سجل المعاملات',
          style: AppStyles.font16BoldPrimary,
        ),
        GestureDetector(
          onTap: onSeeAllTap,
          child: Text(
            'عرض الكل',
            style: AppStyles.font14RegularGray.copyWith(
              color: AppColors.textLightGray,
            ),
          ),
        ),
      ],
    );
  }
}

