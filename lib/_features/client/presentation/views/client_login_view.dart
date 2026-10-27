import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class ClientLoginView extends StatelessWidget {
  const ClientLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تسجيل دخول العميل',
          style: AppStyles.font18BoldDark,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 16.h),
            Text(
              'واجهة العميل',
              style: AppStyles.font20BoldDark,
            ),
          ],
        ),
      ),
    );
  }
}
