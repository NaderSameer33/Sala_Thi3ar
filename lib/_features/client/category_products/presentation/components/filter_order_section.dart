import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';

class FilterOrderSection extends StatelessWidget {
  final String? selectedFilter;
  final ValueChanged<String?> onChanged;

  const FilterOrderSection({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'الترتيب',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: AppColors.textDark,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        12.verticalSpacing,
        _buildOption(
          title: 'السعر الأقل للأعلى',
          value: 'asc',
        ),
        8.verticalSpacing,
        _buildOption(
          title: 'من السعر الأعلى للأقل',
          value: 'desc',
        ),
      ],
    );
  }

  Widget _buildOption({
    required String title,
    required String value,
  }) {
    final isSelected = selectedFilter == value;

    return GestureDetector(
      onTap: () => onChanged(isSelected ? null : value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: isSelected ? AppColors.primary : AppColors.textLightGray,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          10.horizontalSpacing,
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.inputBorder,
                width: 1.5,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

