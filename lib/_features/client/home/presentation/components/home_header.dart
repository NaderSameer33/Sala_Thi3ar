import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../cart/logic/cart_cubit.dart';
import '../../../cart/logic/cart_state.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/app_logo.png',
            height: 40.h,
            fit: BoxFit.contain,
          ),
          2.horizontalSpace,
          Text('سلة ثمار', style: AppStyles.font14BoldPrimary),
          Expanded(
            child: Column(
              children: [
                Text(
                  'التوصيل إلى',
                  style: AppStyles.font12RegularGray.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                2.verticalSpacing,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'شارع الملك فهد - جدة',
                      style: AppStyles.font14RegularDark,
                    ),
                    4.horizontalSpacing,
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push(AppRouterName.cart),
            child: Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: AppColors.primaryTint,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset('assets/icons/Bag.svg'),
                  BlocBuilder<CartCubit, CartState>(
                    buildWhen: (prev, curr) =>
                        prev.cartData?.items.length !=
                        curr.cartData?.items.length,
                    builder: (context, state) {
                      final count = state.cartData?.items.length ?? 0;
                      return Positioned(
                        top: 4.h,
                        right: 4.w,
                        child: Container(
                          padding: EdgeInsets.all(3.r),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
