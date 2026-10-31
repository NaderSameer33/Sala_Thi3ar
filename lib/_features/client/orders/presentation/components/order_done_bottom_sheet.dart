import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';

class OrderDoneBottomSheet extends StatelessWidget {
  const OrderDoneBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => const OrderDoneBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 130.r,
            height: 130.r,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.primaryVeryLight,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/vegetables_basket.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'شكرا لك لقد تم تنفيذ طلبك بنجاح',
            textAlign: TextAlign.center,
            style: AppStyles.font18BoldPrimary,
          ),
          SizedBox(height: 8.h),
          Text(
            'يمكنك متابعة حالة الطلب او الرجوع للرئيسية',
            textAlign: TextAlign.center,
            style: AppStyles.font14RegularGray,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'الرئيسية',
                  backgroundColor: AppColors.white,
                  textStyle: AppStyles.font16BoldPrimary,
                  borderSide: const BorderSide(color: AppColors.primary),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(AppRouterName.home);
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppButton(
                  text: 'طلباتي',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(AppRouterName.myOrders);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

