import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../home/presentation/components/build_product_item.dart';
import '../../logic/category_products_cubit.dart';
import '../../logic/category_products_state.dart';

class CategoryProductsGrid extends StatelessWidget {
  const CategoryProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status || prev.products != curr.products,
      builder: (context, state) {
        if (state.status == CategoryProductsStatus.error) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage.isNotEmpty
                        ? state.errorMessage
                        : 'فشل تحميل المنتجات',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.textLightGray,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  12.verticalSpacing,
                  InkWell(
                    onTap: () =>
                        context.read<CategoryProductsCubit>().fetchProducts(),
                    child: Text(
                      'إعادة المحاولة',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final isLoading = state.status == CategoryProductsStatus.loading;
        final products =
            isLoading ? CategoryProductsCubit.dummyProducts : state.products;

        if (!isLoading && products.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    color: AppColors.textLightGray.withValues(alpha: 0.5),
                    size: 64,
                  ),
                  12.verticalSpacing,
                  Text(
                    'لا توجد منتجات متاحة في هذا القسم',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.textLightGray,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
                childAspectRatio: 0.67,
              ),
              itemBuilder: (context, index) {
                return BuildProductItem(
                  product: products[index],
                  heroTagPrefix: 'cat_${state.categoryId}',
                );
              },
            ),
          ),
        );
      },
    );
  }
}

