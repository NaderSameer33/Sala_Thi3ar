import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String code;
  final String description;

  const ProductDescriptionSection({
    super.key,
    required this.code,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (code.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                code,
                style: AppStyles.font14RegularGray,
              ),
              8.horizontalSpacing,
              Text(
                'كود المنتج',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppColors.primary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          16.verticalSpacing,
        ],
        Text(
          'تفاصيل المنتج',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: AppColors.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        8.verticalSpacing,
        Text(
          description.isNotEmpty
              ? description
              : 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة.',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: AppColors.textLightGray,
            fontSize: 13.sp,
            height: 1.6,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

