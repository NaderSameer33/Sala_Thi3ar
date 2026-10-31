import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class OrderSummaryCard extends StatelessWidget {
  final num productPrice;
  final num deliveryPrice;
  final num discount;
  final num totalPrice;

  const OrderSummaryCard({
    super.key,
    required this.productPrice,
    required this.deliveryPrice,
    required this.discount,
    required this.totalPrice,
  });

  String _format(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملخص الطلب',
          style: AppStyles.font16BoldDark,
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.primaryVeryLight,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primaryTint,
              width: 1.r,
            ),
          ),
          child: Column(
            children: [
              _buildRow('إجمالي المنتجات', '${_format(productPrice)} ر.س'),
              SizedBox(height: 10.h),
              _buildRow(
                'سعر التوصيل',
                deliveryPrice == 0 ? 'مجاناً' : '${_format(deliveryPrice)} ر.س',
              ),
              if (discount > 0) ...[
                SizedBox(height: 10.h),
                _buildRow(
                  'الخصم',
                  '-${_format(discount)} ر.س',
                  valueColor: AppColors.red,
                ),
              ],
              Divider(
                color: AppColors.primaryTint,
                height: 20.h,
                thickness: 1.r,
              ),
              _buildRow(
                'المجموع',
                '${_format(totalPrice)} ر.س',
                titleStyle: AppStyles.font16BoldPrimary,
                valueStyle: AppStyles.font16BoldPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
    String title,
    String value, {
    Color? valueColor,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ??
              AppStyles.font14RegularDark.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              AppStyles.font14BoldDark.copyWith(
                color: valueColor ?? AppColors.textDark,
              ),
        ),
      ],
    );
  }
}
