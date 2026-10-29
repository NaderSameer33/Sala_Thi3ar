import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_cubit.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_state.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class ProductBottomCartBar extends StatelessWidget {
  const ProductBottomCartBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (prev, curr) =>
          prev.quantity != curr.quantity || prev.product != curr.product,
      builder: (context, state) {
        final totalFormatted = state.totalPrice.toStringAsFixed(
          state.totalPrice % 1 == 0 ? 0 : 2,
        );

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 52.h,
              child: Container(
                height: 60.h,
                width: 80.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w),

                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15.r),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 35.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Image.asset(
                            'assets/images/Shopping Cart.png',
                            width: 20.w,
                            height: 20.h,
                            color: Colors.white,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        5.horizontalSpace,
                        Text(
                          'إضافة إلى السلة',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        8.horizontalSpacing,
                      ],
                    ),
                    Text(
                      '$totalFormatted ر.س',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
