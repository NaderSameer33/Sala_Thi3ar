import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/wallet_transaction_model.dart';

class WalletTransactionItem extends StatelessWidget {
  final WalletTransactionModel transaction;

  const WalletTransactionItem({
    super.key,
    required this.transaction,
  });

  String _formatAmount(num val) {
    if (val.truncateToDouble() == val) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final isCharge = transaction.isCharge;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border,
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.date.isNotEmpty ? transaction.date : '27 يونيو, 2021',
                style: AppStyles.font12RegularGray.copyWith(
                  color: AppColors.textLightGray,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isCharge ? 'شحن المحفظة' : 'دفعت مقابل هذا الطلب',
                    style: AppStyles.font14BoldPrimary.copyWith(
                      color: isCharge ? AppColors.primary : AppColors.red,
                    ),
                  ),
                  8.horizontalSpacing,
                  Icon(
                    isCharge
                        ? Icons.arrow_circle_up_rounded
                        : Icons.arrow_circle_down_rounded,
                    color: isCharge ? AppColors.primary : AppColors.red,
                    size: 20.r,
                  ),
                ],
              ),
            ],
          ),
          10.verticalSpacing,
          if (isCharge)
            Text(
              '${_formatAmount(transaction.amount)} ر.س',
              style: AppStyles.font18BoldPrimary.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.start,
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_formatAmount(transaction.amount)} ر.س',
                    style: AppStyles.font14BoldPrimary,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          '+2',
                          style: AppStyles.font10BoldWhite.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      4.horizontalSpacing,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: Image.asset(
                          'assets/images/tomato.png',
                          width: 20.r,
                          height: 20.r,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                      8.horizontalSpacing,
                      Text(
                        'طلب #${transaction.modelId != 0 ? transaction.modelId : (transaction.id != 0 ? transaction.id : 4587)}',
                        style: AppStyles.font12RegularGray.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

