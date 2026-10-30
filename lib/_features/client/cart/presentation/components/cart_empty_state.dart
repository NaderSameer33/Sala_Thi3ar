import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 60.h),
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
                Icons.shopping_cart_outlined,
                size: 45,
                color: AppColors.primary,
              ),
            ),
            20.verticalSpacing,
            Text(
              'السلة فارغة حالياً',
              style: AppStyles.font18BoldPrimary,
            ),
            8.verticalSpacing,
            Text(
              'تصفح المنتجات وأضف ما تحتاجه إلى سلتك',
              textAlign: TextAlign.center,
              style: AppStyles.font13RegularGray,
            ),
            24.verticalSpacing,
            AppButton(
              text: 'تصفح المنتجات',
              onPressed: () => context.pop(),
              width: 170.w,
              height: 48.h,
              borderRadius: 12.r,
              textStyle: AppStyles.font14BoldWhite,
            ),
          ],
        ),
      ),
    );
  }
}
