import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCashOption(
            isSelected: selectedMethod == 'cash',
            onTap: () => onMethodChanged('cash'),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildCardOption(
            method: 'visa',
            isSelected: selectedMethod == 'visa',
            onTap: () => onMethodChanged('visa'),
            child: Text(
              'VISA',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w900,
                fontSize: 18.sp,
                color: const Color(0xFF1A1F71),
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildCardOption(
            method: 'mastercard',
            isSelected: selectedMethod == 'mastercard',
            onTap: () => onMethodChanged('mastercard'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18.r,
                  height: 18.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEB001B),
                    shape: BoxShape.circle,
                  ),
                ),
                Transform.translate(
                  offset: Offset(-6.w, 0),
                  child: Container(
                    width: 18.r,
                    height: 18.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF79E1B).withAlpha(220),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCashOption({
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5.r : 1.r,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payments_outlined,
              size: 20.r,
              color: isSelected ? AppColors.primary : AppColors.textGray,
            ),
            SizedBox(width: 6.w),
            Text(
              'كاش',
              style: isSelected
                  ? AppStyles.font14BoldPrimary
                  : AppStyles.font14RegularGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardOption({
    required String method,
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5.r : 1.r,
          ),
        ),
        child: child,
      ),
    );
  }
}

