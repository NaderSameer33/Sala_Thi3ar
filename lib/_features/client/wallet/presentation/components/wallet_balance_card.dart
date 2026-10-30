import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class WalletBalanceCard extends StatelessWidget {
  final num balance;

  const WalletBalanceCard({
    super.key,
    required this.balance,
  });

  String _formatBalance(num val) {
    if (val.truncateToDouble() == val) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border,
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'رصيدك',
            style: AppStyles.font18BoldPrimary,
          ),
          12.verticalSpacing,
          Text(
            '${_formatBalance(balance)} ر.س',
            style: AppStyles.font24BoldDark.copyWith(
              color: AppColors.primary,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

