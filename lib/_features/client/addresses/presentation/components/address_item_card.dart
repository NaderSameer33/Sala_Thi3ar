import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/address_model.dart';

class AddressItemCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const AddressItemCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final typeName = address.type == 'home' || address.type == 'المنزل'
        ? 'المنزل'
        : (address.type == 'work' || address.type == 'العمل' ? 'العمل' : address.type);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryLight.withAlpha(120),
          width: 1.2.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeName,
                  style: AppStyles.font16BoldPrimary,
                ),
                SizedBox(height: 6.h),
                Text(
                  'العنوان : ${address.location.isNotEmpty ? address.location : address.description}',
                  style: AppStyles.font14RegularDark.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (address.description.isNotEmpty && address.description != address.location) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'الوصف : ${address.description}',
                    style: AppStyles.font12RegularGray,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 4.h),
                Text(
                  'رقم الجوال : ${address.phone}',
                  style: AppStyles.font12RegularGray,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: isDeleting ? null : onDelete,
                child: Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: AppColors.redLight,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: isDeleting
                      ? SizedBox(
                          width: 16.r,
                          height: 16.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.red,
                          ),
                        )
                      : Image.asset(
                          'assets/images/Trash-2.png',
                          width: 16.r,
                          height: 16.r,
                          color: AppColors.red,
                        ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/Edit - 3.png',
                    width: 16.r,
                    height: 16.r,
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
}
