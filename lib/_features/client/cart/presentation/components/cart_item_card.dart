import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/cart_item_model.dart';
import '../../logic/cart_cubit.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final bool isLoading;

  const CartItemCard({
    super.key,
    required this.item,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 82.w,
              height: 82.h,
              color: const Color(0xFFF9F9F9),
              child: item.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.image,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(color: AppColors.inputFill),
                      errorWidget: (_, _, _) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textLightGray,
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textLightGray,
                    ),
            ),
          ),
          12.horizontalSpacing,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppStyles.font14BoldPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpacing,
                Text(
                  '${item.formattedPrice} ر.س',
                  style: AppStyles.font14BoldPrimary,
                ),
                8.verticalSpacing,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F9F1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.primaryTint, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => context.read<CartCubit>().decrementAmount(
                                item,
                              ),
                        child: Container(
                          width: 26.w,
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: const Icon(
                            Icons.remove,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          '${item.amount}',
                          style: AppStyles.font14BoldPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => context.read<CartCubit>().incrementAmount(
                                item,
                              ),
                        child: Container(
                          width: 26.w,
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          8.horizontalSpacing,
          GestureDetector(
            onTap: isLoading
                ? null
                : () => context.read<CartCubit>().deleteItem(item.id),
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFFF4848),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
