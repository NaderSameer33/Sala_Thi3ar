import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/order_details_model.dart';
import 'order_products_bottom_sheet.dart';

class OrderDetailsInfoCard extends StatelessWidget {
  final OrderDetailsModel order;

  const OrderDetailsInfoCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border,
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب #${order.id}',
                style: AppStyles.font16BoldDark,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: order.statusBackgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  order.statusTitle,
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    color: order.statusTextColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          4.verticalSpacing,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.date.isNotEmpty ? order.date : '27 يونيو، 2021',
                style: AppStyles.font12RegularGray,
              ),
              Text(
                '${order.totalPrice} ر.س',
                style: AppStyles.font16BoldPrimary,
              ),
            ],
          ),
          12.verticalSpacing,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildThumbnailsRow(context),
              InkWell(
                onTap: () {
                  if (order.products.isNotEmpty) {
                    OrderProductsBottomSheet.show(context, order.products);
                  }
                },
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  width: 26.r,
                  height: 26.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 13.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailsRow(BuildContext context) {
    final products = order.products;

    if (products.isEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThumbnailItem(assetPath: 'assets/images/tomato.png'),
          4.horizontalSpace,
          _buildThumbnailItem(assetPath: 'assets/images/category_vegetables.png'),
          4.horizontalSpace,
          _buildThumbnailItem(assetPath: 'assets/images/category_fruits.png'),
          4.horizontalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              '+2',
              style: TextStyle(
                fontFamily: AppStyles.fontFamily,
                color: AppColors.primary,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    final display = products.take(3).toList();
    final remaining = products.length - display.length;

    return GestureDetector(
      onTap: () => OrderProductsBottomSheet.show(context, products),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...display.map(
            (p) => Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: _buildThumbnailItem(imageUrl: p.imageUrl),
            ),
          ),
          if (remaining > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.primaryTint,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '+$remaining',
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  color: AppColors.primary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThumbnailItem({String? imageUrl, String? assetPath}) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/tomato.png',
                fit: BoxFit.contain,
              ),
            )
          : Image.asset(
              assetPath ?? 'assets/images/tomato.png',
              fit: BoxFit.contain,
            ),
    );
  }
}

