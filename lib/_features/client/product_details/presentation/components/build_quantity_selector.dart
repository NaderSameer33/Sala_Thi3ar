import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_cubit.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_state.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class BuildQuantitySelector extends StatelessWidget {
  const BuildQuantitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (prev, curr) => prev.quantity != curr.quantity,
      builder: (context, state) {
        final cubit = context.read<ProductDetailsCubit>();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: cubit.decrementQuantity,
                child: Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.remove,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Text(
                  '${state.quantity}',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: cubit.incrementQuantity,
                child: Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: AppColors.primary, size: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}