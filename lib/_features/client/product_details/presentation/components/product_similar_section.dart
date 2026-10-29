import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/build_product_item.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_cubit.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_state.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';

class ProductSimilarSection extends StatelessWidget {
  const ProductSimilarSection({super.key});

  static final List<ProductModel> _dummySimilarProducts = List.generate(
    4,
    (index) => const ProductModel(
      id: -1,
      categoryId: 1,
      title: 'اسم المنتج التجريبي',
      description: '',
      code: '',
      priceBeforeDiscount: 100.0,
      price: 80.0,
      discount: 0.2,
      amount: 10,
      isActive: 1,
      isFavorite: false,
      unit: ProductUnitModel(id: 1, name: 'كيلو', type: 'kg'),
      images: [],
      mainImage: '',
      createdAt: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (prev, curr) =>
          prev.similarStatus != curr.similarStatus ||
          prev.similarProducts != curr.similarProducts,
      builder: (context, state) {
        final isLoading =
            state.similarStatus == ProductDetailsStateStatus.loading;

        if (!isLoading && state.similarProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        final products =
            isLoading ? _dummySimilarProducts : state.similarProducts;

        return Skeletonizer(
          enabled: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'منتجات مشابهة',
                  style: AppStyles.font16BoldDark,
                  textAlign: TextAlign.right,
                ),
              ),
              14.verticalSpacing,
              SizedBox(
                height: 250.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  physics: isLoading
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  itemCount: products.length,
                  separatorBuilder: (_, _) => 14.horizontalSpacing,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 160.w,
                      child: BuildProductItem(
                        product: products[index],
                        heroTagPrefix: 'similar',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
