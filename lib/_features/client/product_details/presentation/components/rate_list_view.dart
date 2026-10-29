import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/product_details/data/models/product_rate_model.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/rate_card.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class RateListView extends StatelessWidget {
  const RateListView({super.key, required this.isLoading, required this.rates});
  final bool isLoading;
  final List<ProductRateModel> rates;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'عرض الكل',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textLightGray,
                fontSize: 13.sp,
              ),
            ),
            Text(
              'التقييمات',
              style: TextStyle(
                fontFamily: 'Tajawal',
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
