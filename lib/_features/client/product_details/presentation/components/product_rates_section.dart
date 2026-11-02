import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_cubit.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_state.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'rate_list_view.dart';
import 'rate_product_bottom_sheet.dart';

class ProductRatesSection extends StatelessWidget {
  const ProductRatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (prev, curr) =>
          prev.ratesStatus != curr.ratesStatus ||
          prev.rates != curr.rates ||
          prev.product != curr.product,
      builder: (context, state) {
        final cubit = context.read<ProductDetailsCubit>();
        final isLoading =
            state.ratesStatus == ProductDetailsStateStatus.loading;
        final product = state.product;

        if (product == null) {
          return const SizedBox.shrink();
        }

        if (!isLoading && state.rates.isEmpty) {
          return _buildEmptyRatingsState(context, product, cubit);
        }

        final rates = isLoading ? cubit.dummyRates : state.rates;

        return Skeletonizer(
          enabled: isLoading,
          child: RateListView(
            isLoading: isLoading,
            rates: rates,
            onRatePressed: () => _openRateSheet(context, product, cubit),
          ),
        );
      },
    );
  }

  void _openRateSheet(
    BuildContext context,
    ProductModel product,
    ProductDetailsCubit cubit,
  ) {
    RateProductBottomSheet.show(
      context,
      productId: product.id,
      productTitle: product.title,
      productImage: product.mainImage.isNotEmpty
          ? product.mainImage
          : (product.images.isNotEmpty ? product.images.first.url : null),
      productPrice: product.formattedPrice,
      onRatingSuccess: () => cubit.getProductRates(product.id),
    );
  }

  Widget _buildEmptyRatingsState(
    BuildContext context,
    ProductModel product,
    ProductDetailsCubit cubit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => _openRateSheet(context, product, cubit),
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.primaryVeryLight,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.primaryTint),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Icon(
                      Icons.star_rounded,
                      color: AppColors.orange,
                      size: 22.r,
                    ),
                  ),
                ),
              ),
              8.verticalSpacing,
              Text(
                'كن أول من يقيّم هذا المنتج!',
                style: AppStyles.font14BoldDark,
              ),
              4.verticalSpacing,
              Text(
                'شارك تجربتك مع هذا المنتج وساعد الآخرين في الشراء',
                style: AppStyles.font12RegularGray,
                textAlign: TextAlign.center,
              ),
              12.verticalSpacing,
              SizedBox(
                height: 38.h,
                child: ElevatedButton.icon(
                  onPressed: () => _openRateSheet(context, product, cubit),
                  icon: Icon(
                    Icons.rate_review_rounded,
                    size: 16.r,
                    color: AppColors.white,
                  ),
                  label: Text(
                    'تقييم المنتج الآن',
                    style: AppStyles.font14BoldWhite,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
