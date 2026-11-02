import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class OrderDetailsHeader extends StatelessWidget {
  const OrderDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'تفاصيل الطلب',
              style: AppStyles.font18BoldPrimary,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16.r,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

