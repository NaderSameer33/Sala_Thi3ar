import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/app_validator.dart';

class ProfilePhoneInput extends StatelessWidget {
  final TextEditingController controller;

  const ProfilePhoneInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 72.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primary.withAlpha(120),
              width: 1.2.r,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF007A3D),
                  borderRadius: BorderRadius.circular(3.r),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/flag.png',
                  fit: BoxFit.contain,
                ),
              ),
              3.verticalSpacing,
              Text(
                '+966',
                style: AppStyles.font12RegularGray.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        10.horizontalSpacing,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primary.withAlpha(120),
                width: 1.2.r,
              ),
            ),

            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'رقم الجوال',
                        style: AppStyles.font12RegularGray.copyWith(
                          color: AppColors.textLightGray,
                        ),
                      ),
                      2.verticalSpacing,
                      TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.phone,
                        validator: AppValidator.validatePhone,
                        style: AppStyles.font14BoldPrimary.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                8.horizontalSpacing,
                Image.asset(
                  'assets/images/Call - Calling.png',
                  width: 22.r,
                  height: 22.r,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
