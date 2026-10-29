import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../logic/category_products_cubit.dart';
import '../components/category_products_grid.dart';
import '../components/category_products_header.dart';
import '../components/category_search_bar_with_filter.dart';

class CategoryProductsView extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsView({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoryProductsCubit>()
        ..init(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      child: const _CategoryProductsViewBody(),
    );
  }
}

class _CategoryProductsViewBody extends StatelessWidget {
  const _CategoryProductsViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryProductsCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => cubit.fetchProducts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CategoryProductsHeader(title: cubit.state.categoryName),
                12.verticalSpacing,
                const CategorySearchBarWithFilter(),
                const CategoryProductsGrid(),
                24.verticalSpacing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
