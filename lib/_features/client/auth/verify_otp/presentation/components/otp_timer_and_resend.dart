import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';

class OtpTimerAndResend extends StatelessWidget {
  final CountDownController controller;
  final bool isTimerCompleted;
  final bool isLoading;
  final VoidCallback onResend;
  final VoidCallback onTimerCompleted;

  const OtpTimerAndResend({
    super.key,
    required this.controller,
    required this.isTimerCompleted,
    required this.isLoading,
    required this.onResend,
    required this.onTimerCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'لم تستلم الكود ؟',
          style: AppStyles.font14RegularGray,
        ),
        4.verticalSpacing,
        Text(
          'يمكنك إعادة إرسال الكود بعد',
          style: AppStyles.font14RegularGray,
        ),
        16.verticalSpacing,
        CircularCountDownTimer(
          duration: 65,
          initialDuration: 0,
          controller: controller,
          width: 66.w,
          height: 66.h,
          ringColor: AppColors.border,
          fillColor: AppColors.primary,
          strokeWidth: 2.5,
          strokeCap: StrokeCap.round,
          textStyle: AppStyles.font14BoldDark.copyWith(
            color: AppColors.primary,
          ),
          textFormat: CountdownTextFormat.MM_SS,
          isReverse: true,
          isReverseAnimation: true,
          isTimerTextShown: true,
          autoStart: true,
          onComplete: onTimerCompleted,
        ),
        16.verticalSpacing,
        InkWell(
          onTap: isTimerCompleted && !isLoading ? onResend : null,
          borderRadius: BorderRadius.circular(15.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: isTimerCompleted
                    ? AppColors.primary
                    : AppColors.inputBorder,
                width: 1.5,
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 18.w,
                    height: 18.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                : Text(
                    'إعادة الإرسال',
                    style: AppStyles.font14BoldPrimary.copyWith(
                      color: isTimerCompleted
                          ? AppColors.primary
                          : AppColors.textLightGray,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
