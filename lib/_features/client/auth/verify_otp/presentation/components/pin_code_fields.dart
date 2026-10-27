import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class PinCodeFields extends StatelessWidget {
  final PinInputController controller;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const PinCodeFields({
    super.key,
    required this.controller,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: MaterialPinField(
        
          length: 4,
          pinController: controller,
          keyboardType: TextInputType.number,
          onCompleted: onCompleted,
          onChanged: onChanged,
          theme: MaterialPinTheme(
            
            shape: MaterialPinShape.outlined,
            cellSize: Size(70.w, 60.h),
            spacing: 12.w,
            borderRadius: BorderRadius.circular(15.r),
            borderWidth: 1,
            focusedBorderWidth: 1.5,
            borderColor: AppColors.inputBorder,
            focusedBorderColor: AppColors.primary,
            filledBorderColor: AppColors.primary,
            fillColor: AppColors.inputFill,
            focusedFillColor: AppColors.inputFill,
            filledFillColor: AppColors.inputFill,
            cursorColor: AppColors.primary,
            textStyle: AppStyles.font20BoldDark.copyWith(
              color: AppColors.primary,
            ),
            entryAnimation: MaterialPinAnimation.fade,
          ),
        ),
      ),
    );
  }
}
