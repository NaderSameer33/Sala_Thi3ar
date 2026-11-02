import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';

class RateSuccessDialog extends StatelessWidget {
  final VoidCallback? onDismiss;
  final String title;
  final String message;
  final String buttonText;

  const RateSuccessDialog({
    super.key,
    this.onDismiss,
    this.title = 'شكراً لتقييمك! 🎉',
    this.message = 'تمت إضافة تقييمك للمنتج بنجاح، رأيك يساعدنا ويساعد باقي العملاء',
    this.buttonText = 'حسناً',
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onDismiss,
    String title = 'شكراً لتقييمك! 🎉',
    String message = 'تمت إضافة تقييمك للمنتج بنجاح، رأيك يساعدنا ويساعد باقي العملاء',
    String buttonText = 'حسناً',
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => RateSuccessDialog(
        onDismiss: onDismiss,
        title: title,
        message: message,
        buttonText: buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      contentPadding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 22.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76.r,
            height: 76.r,
            decoration: const BoxDecoration(
              color: AppColors.primaryTint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 48.r,
            ),
          ),
          18.verticalSpacing,
          Text(
            title,
            style: AppStyles.font18BoldPrimary,
            textAlign: TextAlign.center,
          ),
          8.verticalSpacing,
          Text(
            message,
            style: AppStyles.font14RegularDark,
            textAlign: TextAlign.center,
          ),
          22.verticalSpacing,
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: buttonText,
              backgroundColor: AppColors.primary,
              onPressed: () {
                Navigator.of(context).pop();
                onDismiss?.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}
