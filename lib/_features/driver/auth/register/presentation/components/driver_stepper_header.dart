import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';

class DriverStepperHeader extends StatelessWidget {
  final int currentStep;

  const DriverStepperHeader({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/app_logo.png',
          height: 90.h,
          fit: BoxFit.contain,
        ),
        8.verticalSpacing,
        Text(
          'مرحبا بك مرة أخرى',
          style: AppStyles.font16BoldPrimary,
          textAlign: TextAlign.center,
        ),
        4.verticalSpacing,
        Text(
          'يمكنك تسجيل حساب جديد الآن',
          style: AppStyles.font12RegularGray,
          textAlign: TextAlign.center,
        ),
        20.verticalSpacing,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStepItem(
                stepNumber: 1,
                label: 'البيانات الشخصية',
                isActive: true,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Row(
                    children: List.generate(
                      10,
                      (index) => Expanded(
                        child: Container(
                          height: 1.5.h,
                          margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                          color: currentStep >= 2
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildStepItem(
                stepNumber: 2,
                label: 'بيانات السيارة',
                isActive: currentStep >= 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required int stepNumber,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : const Color(0xFFE2E5E8),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              '$stepNumber',
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textLightGray,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        6.verticalSpacing,
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.primary : AppColors.textLightGray,
          ),
        ),
      ],
    );
  }
}
