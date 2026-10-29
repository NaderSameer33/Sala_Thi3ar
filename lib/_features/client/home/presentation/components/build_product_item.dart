import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../data/models/product_model.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';

class BuildProductItem extends StatelessWidget {
  final ProductModel product;
  final String heroTagPrefix;

  const BuildProductItem({
    super.key,
    required this.product,
    this.heroTagPrefix = 'home',
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = '${heroTagPrefix}_product_image_${product.id}';
    final shouldHero = product.id > 0;

    return GestureDetector(
      onTap: () {
        if (!shouldHero) return;
        context.push(
          AppRouterName.productDetails,
          extra: {
            'product': product,
            'heroTag': heroTag,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(9.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: shouldHero
                          ? Hero(
                              tag: heroTag,
                              child: _buildImage(),
                            )
                          : _buildImage(),
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            bottomRight: Radius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          '${product.discountPercent}%',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            8.verticalSpacing,
            Text(
              product.title,
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
            2.verticalSpacing,
            Text(
              'السعر / 1 ${product.unitName.isNotEmpty ? product.unitName : 'كجم'}',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textLightGray,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
            6.verticalSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${product.formattedPrice} ر.س',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: AppColors.primary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        4.horizontalSpacing,
                        Flexible(
                          child: Text(
                            '${product.formattedPriceBeforeDiscount} ر.س',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: AppColors.textLightGray,
                              fontSize: 10.sp,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: product.mainImage,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(color: AppColors.inputFill),
      errorWidget: (_, _, _) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textLightGray,
          size: 32,
        ),
      ),
    );
  }
}
