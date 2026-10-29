import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../data/models/category_model.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class BuildCategoryItem extends StatelessWidget {
  const BuildCategoryItem({
    super.key,
    required this.isLoading,
    required this.isSelected,
    required this.category,
  });
  final bool isLoading, isSelected;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              context.push(
                AppRouterName.categoryProducts,
                extra: category,
              );
            },
      child: Column(
        children: [
          Container(
            width: 65.w,
            height: 65.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.primaryTint,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: category.media,
                fit: BoxFit.cover,
                width: 65.w,
                height: 65.h,
                placeholder: (_, _) => Container(
                  width: 65.w,
                  height: 65.h,
                  color: AppColors.inputFill,
                ),
                errorWidget: (_, _, _) => Padding(
                  padding: EdgeInsets.all(14.r),
                  child: const Icon(
                    Icons.category_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          6.verticalSpacing,
          SizedBox(
            width: 65.w,
            child: Text(
              category.name,
              style: AppStyles.font12RegularGray.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
