import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/order_details_model.dart';

class RateProductCard extends StatelessWidget {
  final OrderProductItemModel product;
  final int rating;
  final String comment;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<String> onCommentChanged;

  const RateProductCard({
    super.key,
    required this.product,
    required this.rating,
    required this.comment,
    required this.onRatingChanged,
    required this.onCommentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProductImage(),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title.isNotEmpty ? product.title : 'طماطم',
                      style: AppStyles.font16BoldPrimary,
                    ),
                    2.verticalSpacing,
                    Text(
                      'السعر / 1كجم',
                      style: AppStyles.font12RegularGray,
                    ),
                    4.verticalSpacing,
                    Row(
                      children: [
                        Text(
                          '${product.price} ر.س',
                          style: AppStyles.font16BoldPrimary,
                        ),
                        8.horizontalSpace,
                        Text(
                          '${(product.price * 1.25).toInt()} ر.س',
                          style: AppStyles.font12RegularGray.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textLightGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          14.verticalSpacing,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isSelected = starIndex <= rating;
              return GestureDetector(
                onTap: () => onRatingChanged(starIndex),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    color: isSelected ? AppColors.orange : AppColors.border,
                    size: 26.r,
                  ),
                ),
              );
            }),
          ),
          14.verticalSpacing,
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: TextEditingController(text: comment)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: comment.length),
                ),
              onChanged: onCommentChanged,
              maxLines: 3,
              style: AppStyles.font14RegularDark,
              decoration: InputDecoration(
                hintText: 'تعليق المنتج',
                hintStyle: AppStyles.font12RegularGray.copyWith(
                  color: AppColors.textLightGray,
                ),
                contentPadding: EdgeInsets.all(12.r),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 68.r,
      height: 68.r,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: product.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: product.imageUrl,
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
    );
  }
}

