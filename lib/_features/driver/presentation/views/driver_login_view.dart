import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class DriverLoginView extends StatelessWidget {
  const DriverLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تسجيل دخول المندوب',
          style: AppStyles.font18BoldDark,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 64.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 16.h),
            Text(
              'واجهة المندوب / السائق',
              style: AppStyles.font20BoldDark,
            ),
          ],
        ),
      ),
    );
  }
}
