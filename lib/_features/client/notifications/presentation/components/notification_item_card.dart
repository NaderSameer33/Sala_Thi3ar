import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/notification_model.dart';

class NotificationItemCard extends StatelessWidget {
  final NotificationItemModel notification;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const NotificationItemCard({
    super.key,
    required this.notification,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.redLight,
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Icon(
          Icons.delete_outline,
          color: AppColors.red,
          size: 26.r,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.border
                  : AppColors.primary.withAlpha(50),
              width: 1.r,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppStyles.font14BoldDark,
                    ),
                    4.verticalSpacing,
                    Text(
                      notification.body,
                      style: AppStyles.font12RegularGray.copyWith(
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    6.verticalSpacing,
                    Text(
                      notification.createdAt,
                      style: TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        color: AppColors.textLightGray,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final hasImage = notification.image.isNotEmpty;

    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: AppColors.primaryTint,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: hasImage
          ? CachedNetworkImage(
              imageUrl: notification.image,
              fit: BoxFit.contain,
              errorWidget: (context, url, error) => _buildFallbackIcon(),
            )
          : _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    final title = notification.title.toLowerCase();
    final type = notification.notifyType.toLowerCase();

    if (type.contains('offer') || title.contains('عروض') || title.contains('خصم')) {
      return Container(
        width: 26.r,
        height: 26.r,
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(30),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '%',
          style: TextStyle(
            fontFamily: AppStyles.fontFamily,
            color: AppColors.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (type.contains('order') || title.contains('طلب')) {
      return Icon(
        Icons.receipt_long,
        color: AppColors.primary,
        size: 22.r,
      );
    }

    return Icon(
      Icons.notifications_active_outlined,
      color: AppColors.primary,
      size: 22.r,
    );
  }
}

