import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';

class FilterPriceRangeSection extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const FilterPriceRangeSection({
    super.key,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'السعر',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: AppColors.textDark,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        8.verticalSpacing,
        RangeSlider(
          values: values,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.primaryTint,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${values.start.round()} ر.س',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textLightGray,
                fontSize: 12.sp,
              ),
            ),
            Text(
              '${values.end.round()} ر.س',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textLightGray,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

