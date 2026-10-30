import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
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
                style: AppStyles.font14RegularDark,
                decoration: InputDecoration(
                  hintText: 'عندك كوبون ؟ ادخل رقم الكوبون',
                  hintStyle: AppStyles.font12RegularGray,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.r),
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
                        style: AppStyles.font14BoldDark,
                      ),
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                  } else if (state.cuponStatus == CuponStatus.error) {
                    toastification.show(
                      context: context,
                      type: ToastificationType.error,
                      title: Text(
                        state.couponMessage,
                        style: AppStyles.font14BoldDark,
                      ),
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state.cuponStatus == CuponStatus.loading;
                  return AppButton(
                    text: 'تطبيق',
                    isLoading: isLoading,
                    width: 82.w,
                    height: 42.h,
                    borderRadius: 12.r,
                    textStyle: AppStyles.font14BoldWhite,
                    onPressed: () {
                      final coupon = _controller.text.trim();
                      if (coupon.isNotEmpty) {
                        context.read<CartCubit>().applyCoupon(coupon);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
