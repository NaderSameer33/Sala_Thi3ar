import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class AddressTypeToggle extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const AddressTypeToggle({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'نوع العنوان',
          style: AppStyles.font14RegularDark.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        _buildTypeButton(
          type: 'home',
          title: 'المنزل',
          isSelected: selectedType == 'home',
        ),
        SizedBox(width: 8.w),
        _buildTypeButton(
          type: 'work',
          title: 'العمل',
          isSelected: selectedType == 'work',
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String type,
    required String title,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.r,
          ),
        ),
        child: Text(
          title,
          style: isSelected
              ? AppStyles.font14RegularDark.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                )
              : AppStyles.font14RegularGray,
        ),
      ),
    );
  }
}
