import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/product_details/data/models/product_rate_model.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/rate_card.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class RateListView extends StatelessWidget {
  final bool isLoading;
  final List<ProductRateModel> rates;
  final VoidCallback? onRatePressed;

  const RateListView({
    super.key,
    required this.isLoading,
    required this.rates,
    this.onRatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (onRatePressed != null) ...[
                  InkWell(
                    onTap: onRatePressed,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTint,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 0.8.r,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.primary,
                            size: 16.r,
                          ),
                          4.horizontalSpace,
                          Text(
                            'أضف تقييمك',
                            style: TextStyle(
                              fontFamily: AppStyles.fontFamily,
                              color: AppColors.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                ],
                Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontFamily: AppStyles.fontFamily,
                    color: AppColors.textLightGray,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            Text(
              'التقييمات',
              style: TextStyle(
                fontFamily: AppStyles.fontFamily,
                color: AppColors.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        12.verticalSpacing,
        SizedBox(
          height: 110.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: isLoading
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemCount: rates.length,
            separatorBuilder: (_, _) => 12.horizontalSpacing,
            itemBuilder: (context, index) {
              return RateCard(rate: rates[index]);
            },
          ),
        ),
      ],
    );
  }
}
