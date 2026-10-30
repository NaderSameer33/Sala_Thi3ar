import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.w,
              height: 90.h,
              decoration: const BoxDecoration(
                color: AppColors.primaryTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 45,
                color: AppColors.primary,
              ),
            ),
            20.verticalSpacing,
            Text(
              'قائمة المفضلة فارغة',
              style: AppStyles.font18BoldPrimary,
            ),
            8.verticalSpacing,
            Text(
              'لم تقم بإضافة أي منتجات إلى المفضلة حتى الآن',
              textAlign: TextAlign.center,
              style: AppStyles.font13RegularGray,
            ),
          ],
        ),
      ),
    );
  }
}

