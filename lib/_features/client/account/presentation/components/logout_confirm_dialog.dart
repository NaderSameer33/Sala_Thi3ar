import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';

class LogoutConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final bool isLoading;

  const LogoutConfirmDialog({
    super.key,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.redLight,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/Turn off.png',
                  width: 28.r,
                  height: 28.r,
                  color: AppColors.red,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            16.verticalSpacing,
            Text(
              'تسجيل الخروج',
              style: AppStyles.font18BoldDark,
            ),
            8.verticalSpacing,
            Text(
              'هل أنت متأكد من تسجيل الخروج من حسابك؟',
              style: AppStyles.font14RegularGray,
              textAlign: TextAlign.center,
            ),
            20.verticalSpacing,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: AppStyles.font14MediumDark,
                    ),
                  ),
                ),
                12.horizontalSpacing,
                Expanded(
                  child: AppButton(
                    text: 'تأكيد',
                    backgroundColor: AppColors.red,
                    textStyle: AppStyles.font15BoldWhite,
                    isLoading: isLoading,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
