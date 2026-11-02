import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/order_details_model.dart';

class OrderProductsBottomSheet extends StatelessWidget {
  final List<OrderProductItemModel> products;

  const OrderProductsBottomSheet({
    super.key,
    required this.products,
  });

  static Future<void> show(
    BuildContext context,
    List<OrderProductItemModel> products,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OrderProductsBottomSheet(products: products),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.75.sh),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.verticalSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'منتجات الطلب (${products.length})',
                  style: AppStyles.font16BoldDark,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textGray),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            12.verticalSpacing,
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.divider,
                  height: 18.h,
                ),
                itemBuilder: (context, index) {
                  final p = products[index];
                  return Row(
                    children: [
                      Container(
                        width: 52.r,
                        height: 52.r,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: p.imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: p.imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/tomato.png',
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Image.asset(
                                'assets/images/tomato.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title.isNotEmpty ? p.title : 'منتج رقم ${p.id}',
                              style: AppStyles.font14BoldDark,
                            ),
                            4.verticalSpacing,
                            Text(
                              'الكمية: ${p.amount}',
                              style: AppStyles.font12RegularGray,
                            ),
                          ],
                        ),
                      ),
                      if (p.price > 0)
                        Text(
                          '${p.price} ر.س',
                          style: AppStyles.font14BoldPrimary,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

