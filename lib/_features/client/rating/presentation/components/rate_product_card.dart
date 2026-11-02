import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/orders/data/models/order_details_model.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class RateProductCard extends StatefulWidget {
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
  State<RateProductCard> createState() => _RateProductCardState();
}

class _RateProductCardState extends State<RateProductCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.comment);
  }

  @override
  void didUpdateWidget(covariant RateProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comment != widget.comment &&
        _controller.text != widget.comment) {
      _controller.text = widget.comment;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                      widget.product.title.isNotEmpty
                          ? widget.product.title
                          : 'طماطم',
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
                          '${widget.product.price} ر.س',
                          style: AppStyles.font16BoldPrimary,
                        ),
                        8.horizontalSpace,
                        Text(
                          '${(widget.product.price * 1.25).toInt()} ر.س',
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
              final isSelected = starIndex <= widget.rating;
              return GestureDetector(
                onTap: () => widget.onRatingChanged(starIndex),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isSelected ? AppColors.orange : AppColors.border,
                    size: 30.r,
                  ),
                ),
              );
            }),
          ),
          14.verticalSpacing,
          Container(
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: TextField(
              controller: _controller,
              onChanged: widget.onCommentChanged,
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
      child: widget.product.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
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
