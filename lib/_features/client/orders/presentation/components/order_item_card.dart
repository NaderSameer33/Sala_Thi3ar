import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/order_model.dart';

class OrderItemCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderItemCard({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: AppStyles.font12RegularGray.copyWith(
                      color: order.statusTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              order.date.isNotEmpty ? order.date : '27 يونيو, 2021',
              style: AppStyles.font12RegularGray,
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.totalPrice} ر.س',
                  style: AppStyles.font16BoldPrimary,
                ),
                _buildThumbnailsRow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailsRow() {
    final images = order.productImages;

    if (images.isEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '+2',
              style: AppStyles.font10BoldWhite.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          _buildThumbnailItem(assetPath: 'assets/images/tomato.png'),
        ],
      );
    }

    final displayImages = images.take(3).toList();
    final remainingCount = images.length - displayImages.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (remainingCount > 0) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '+$remainingCount',
              style: AppStyles.font10BoldWhite.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 4.w),
        ],
        ...displayImages.map(
          (url) => Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: _buildThumbnailItem(imageUrl: url),
          ),
        ),
      ],
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
