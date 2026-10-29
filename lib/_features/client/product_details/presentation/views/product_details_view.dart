import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/product_bottom_cart_bar.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/product_description_section.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/product_images_slider.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/product_main_info.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/product_rates_section.dart';
import 'package:sala_thimar/_features/client/product_details/presentation/components/product_similar_section.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_cubit.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_state.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductModel product;
  final String heroTag;

  const ProductDetailsView({
    super.key,
    required this.product,
    this.heroTag = '',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductDetailsCubit>()..init(product),
      child: _ProductDetailsViewBody(
        heroTag: heroTag.isNotEmpty
            ? heroTag
            : 'home_product_image_${product.id}',
      ),
    );
  }
}

class _ProductDetailsViewBody extends StatelessWidget {
  final String heroTag;

  const _ProductDetailsViewBody({required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const ProductBottomCartBar(),
      body: SafeArea(
        child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          buildWhen: (prev, curr) => prev.product != curr.product,
          builder: (context, state) {
            final product = state.product;
            if (product == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProductImagesSlider(
                    product: product,
                    heroTag: heroTag,
                  ),
                  16.verticalSpacing,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProductMainInfo(product: product),
                        16.verticalSpacing,
                        const Divider(color: AppColors.inputBorder, height: 1),
                        16.verticalSpacing,
                        ProductDescriptionSection(
                          code: product.code,
                          description: product.description,
                        ),
                        20.verticalSpacing,
                        const ProductRatesSection(),
                      ],
                    ),
                  ),
                  20.verticalSpacing,
                  const ProductSimilarSection(),
                  24.verticalSpacing,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
