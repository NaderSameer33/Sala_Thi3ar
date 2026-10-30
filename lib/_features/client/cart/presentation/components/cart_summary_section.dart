import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../logic/cart_cubit.dart';
import '../../logic/cart_state.dart';

class CartSummarySection extends StatelessWidget {
  const CartSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final isLoading = state.status == CartStatus.loading && state.cartData == null;
        final cartData = isLoading ? cubit.dummyCartData : state.cartData;

        if (cartData == null) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'جميع الأسعار تشمل قيمة الضريبة المضافة ${((cartData.vat) * 100).toInt()} %',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              12.verticalSpacing,
              Skeletonizer(
                enabled: isLoading,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F8EE),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    children: [
                      _buildRow(
                        label: 'إجمالي المنتجات',
                        value: '${cartData.formattedSubtotal} ر.س',
                      ),
                      8.verticalSpacing,
                      _buildRow(
                        label: 'الخصم',
                        value: '-${cartData.formattedDiscount} ر.س',
                      ),
                      10.verticalSpacing,
                      const Divider(color: Color(0xFFE2EED9), height: 1),
                      10.verticalSpacing,
                      _buildRow(
                        label: 'المجموع',
                        value: '${cartData.formattedTotal} ر.س',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: isTotal ? 15.sp : 13.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textDark,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: isTotal ? 15.sp : 13.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

