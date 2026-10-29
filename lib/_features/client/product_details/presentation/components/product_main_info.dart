import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/build_quantity_selector.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../home/data/models/product_model.dart';

class ProductMainInfo extends StatelessWidget {
  final ProductModel product;

  const ProductMainInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                product.title,
                style: AppStyles.font18BoldDark.copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.right,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: TextDirection.rtl,
                children: [
                  if (product.hasDiscount) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTint,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        '${product.discountPercent}%-',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: AppColors.primary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    8.horizontalSpacing,
                    Text(
                      '${product.formattedPriceBeforeDiscount} ر.س',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: AppColors.textLightGray,
                        fontSize: 13.sp,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    8.horizontalSpacing,
                  ],
                  Text(
                    '${product.formattedPrice} ر.س',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        8.verticalSpacing,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BuildQuantitySelector(),
            Text(
              'السعر / 1 ${product.unitName.isNotEmpty ? product.unitName : 'كجم'}',
              style: AppStyles.font14RegularGray,
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }
}
