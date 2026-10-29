import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/product_model.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import 'build_home_error_state.dart';
import 'build_product_grid_view.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeProductsSection extends StatelessWidget {
  const HomeProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.productsState != curr.productsState ||
          prev.products != curr.products,
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        if (state.productsState == RequestState.error) {
          return BuildHomeErrorState(
            message: state.productsFailureMessage,
            onTap: () => cubit.getProducts(),
          );
        }

        if (state.productsState == RequestState.success &&
            state.products.isEmpty) {
          return const SizedBox.shrink();
        }

        final isLoading = state.productsState == RequestState.loading;
        final dummyProducts = cubit.dummyProducts;
        final products = isLoading ? dummyProducts : state.products;

        return Skeletonizer(
          enabled: isLoading,
          child: Buildproductgridview(products: products, isLoading: isLoading)
        );
      },
    );
  }

 
}
