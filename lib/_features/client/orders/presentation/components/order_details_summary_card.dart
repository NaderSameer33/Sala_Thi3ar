import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/order_details_model.dart';

class OrderDetailsSummaryCard extends StatelessWidget {
  final OrderDetailsModel order;

  const OrderDetailsSummaryCard({
    super.key,
    required this.order,
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
          style: TextStyle(
            fontFamily: AppStyles.fontFamily,
            color: AppColors.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        10.verticalSpacing,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
              _buildRow('إجمالي المنتجات', '${_format(order.orderPrice)} ر.س'),
              12.verticalSpacing,
              _buildRow('سعر التوصيل', '${_format(order.deliveryPrice)} ر.س'),
              12.verticalSpacing,
              _buildRow(
                'المجموع',
                '${_format(order.totalPrice)} ر.س',
                titleStyle: AppStyles.font16BoldPrimary,
                valueStyle: AppStyles.font16BoldPrimary,
              ),
              16.verticalSpacing,
              _buildPaymentRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
    String title,
    String value, {
    TextStyle? titleStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ?? AppStyles.font14RegularDark,
        ),
        Text(
          value,
          style: valueStyle ?? AppStyles.font14RegularDark.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'تم الدفع بواسطة',
          style: TextStyle(
            fontFamily: AppStyles.fontFamily,
            color: AppColors.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        10.horizontalSpace,
        _buildPaymentBadge(order.payType),
      ],
    );
  }

  Widget _buildPaymentBadge(String payType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        payType.toUpperCase().contains('CASH') ? 'كاش' : 'VISA',
        style: TextStyle(
          fontFamily: AppStyles.fontFamily,
          color: const Color(0xFF1A1F71),
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

