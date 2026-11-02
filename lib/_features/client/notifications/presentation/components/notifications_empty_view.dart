import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class NotificationsEmptyView extends StatelessWidget {
  final VoidCallback onRefresh;

  const NotificationsEmptyView({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: AppColors.primaryTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 42.r,
                color: AppColors.primary,
              ),
            ),
            16.verticalSpacing,
            Text(
              'لا توجد إشعارات حالياً',
              style: AppStyles.font16BoldDark,
            ),
            8.verticalSpacing,
            Text(
              'ستظهر هنا جميع التحديثات والإشعارات الخاصة بطلباتك وعروضنا الجديدة',
              style: AppStyles.font12RegularGray,
              textAlign: TextAlign.center,
            ),
            20.verticalSpacing,
            ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              ),
              child: Text(
                'تحديث',
                style: AppStyles.font14BoldWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

