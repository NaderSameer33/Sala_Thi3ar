import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/product_details/data/models/product_rate_model.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class RateCard extends StatelessWidget {
  const RateCard({super.key, required this.rate});
  final ProductRateModel rate; 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStarRating(rate.value),
              Row(
                children: [
                  Text(
                    rate.clientName.isNotEmpty ? rate.clientName : 'عميل',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.textDark,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.horizontalSpacing,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: CachedNetworkImage(
                      imageUrl: rate.clientImage,
                      width: 28.w,
                      height: 28.h,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          Container(color: AppColors.inputFill),
                      errorWidget: (_, _, _) => const Icon(
                        Icons.account_circle,
                        color: AppColors.textLightGray,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          8.verticalSpacing,
          Text(
            rate.comment.isNotEmpty
                ? rate.comment
                : 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة.',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: AppColors.textLightGray,
              fontSize: 11.sp,
              height: 1.4,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(num value) {
    final rating = value.clamp(0, 5).toInt();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFilled = index < rating;
        return Icon(
          isFilled ? Icons.star : Icons.star_border,
          color: const Color(0xFFFFB300),
          size: 14,
        );
      }),
    );
  }
}