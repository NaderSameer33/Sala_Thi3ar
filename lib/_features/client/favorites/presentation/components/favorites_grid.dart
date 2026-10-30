import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../home/presentation/components/build_product_item.dart';
import '../../logic/favorites_cubit.dart';
import '../../logic/favorites_state.dart';

class FavoritesGrid extends StatelessWidget {
  const FavoritesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status || prev.favorites != curr.favorites,
      builder: (context, state) {
        if (state.status == FavoritesStatus.error && state.favorites.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage.isNotEmpty
                        ? state.errorMessage
                        : 'فشل تحميل المفضلة',
                    style: AppStyles.font14RegularGray,
                    textAlign: TextAlign.center,
                  ),
                  12.verticalSpacing,
                  InkWell(
                    onTap: () => context.read<FavoritesCubit>().getFavorites(),
                    child: Text(
                      'إعادة المحاولة',
                      style: AppStyles.font14BoldPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final cubit = context.read<FavoritesCubit>();
        final isLoading =
            state.status == FavoritesStatus.loading && state.favorites.isEmpty;
        final products = isLoading ? cubit.dummyFavorites : state.favorites;

        return Skeletonizer(
          enabled: isLoading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.65,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return BuildProductItem(
                  product: products[index],
                  heroTagPrefix: 'fav_${products[index].id}',
                );
              },
            ),
          ),
        );
      },
    );
  }
}
