import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class AddToCartBottomSheet extends StatelessWidget {
  final String title;
  final String imageUrl;
  final num price;
  final int amount;

  const AddToCartBottomSheet({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.amount,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required num price,
    required int amount,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddToCartBottomSheet(
        title: title,
        imageUrl: imageUrl,
        price: price,
        amount: amount,
      ),
    );
  }

  String _formatPrice(num val) {
    if (val % 1 == 0) return val.toInt().toString();
    return val.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'تم إضافة المنتج بنجاح',
                  style: AppStyles.font16BoldPrimary,
                ),
                10.horizontalSpace,
                Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.check,
                    size: 15.r,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            18.verticalSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72.r,
                  height: 72.r,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
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
                16.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isNotEmpty ? title : 'طماطم',
                      style: AppStyles.font16BoldPrimary,
                    ),
                    4.verticalSpacing,
                    Text(
                      'الكمية : $amount',
                      style: AppStyles.font12RegularGray.copyWith(
                        color: AppColors.textLightGray,
                      ),
                    ),
                    4.verticalSpacing,
                    Text(
                      '${_formatPrice(price)}ر.س',
                      style: AppStyles.font16BoldPrimary,
                    ),
                  ],
                ),
              ],
            ),
            24.verticalSpacing,
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push(AppRouterName.cart);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'التحويل إلى السلة',
                        style: AppStyles.font14BoldWhite,
                      ),
                    ),
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.primary,
                          width: 1.2.r,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'تصفح العروض',
                        style: AppStyles.font14BoldPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
