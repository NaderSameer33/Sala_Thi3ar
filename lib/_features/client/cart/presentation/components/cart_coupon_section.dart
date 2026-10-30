import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../logic/cart_cubit.dart';
import '../../logic/cart_state.dart';

class CartCouponSection extends StatefulWidget {
  const CartCouponSection({super.key});

  @override
  State<CartCouponSection> createState() => _CartCouponSectionState();
}

class _CartCouponSectionState extends State<CartCouponSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: const Color(0xFFF1F1F1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13.sp,
                  color: AppColors.textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'عندك كوبون ؟ ادخل رقم الكوبون',
                  hintStyle: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12.sp,
                    color: AppColors.textLightGray,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                final coupon = _controller.text.trim();
                if (coupon.isNotEmpty) {
                  context.read<CartCubit>().applyCoupon(coupon);
                }
              },
              child: Container(
                width: 82.w,
                height: 42.h,
                margin: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: BlocConsumer<CartCubit, CartState>(
                  listenWhen: (prev, curr) =>
                      curr.couponMessage.isNotEmpty &&
                      (prev.cuponStatus != curr.cuponStatus ||
                          prev.couponMessage != curr.couponMessage),
                  listener: (context, state) {
                    if (state.cuponStatus == CuponStatus.success) {
                      toastification.show(
                        context: context,
                        type: ToastificationType.success,
                        title: Text(
                          state.couponMessage,
                          style: const TextStyle(fontFamily: 'Tajawal'),
                        ),
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    } else if (state.cuponStatus == CuponStatus.error) {
                      toastification.show(
                        context: context,
                        type: ToastificationType.error,
                        title: Text(
                          state.couponMessage,
                          style: const TextStyle(fontFamily: 'Tajawal'),
                        ),
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.cuponStatus == CuponStatus.loading) {
                      return SizedBox(
                        width: 18.w,
                        height: 18.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      );
                    }
                    return Text(
                      'تطبيق',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
