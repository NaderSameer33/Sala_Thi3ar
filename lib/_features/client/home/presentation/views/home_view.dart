import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../cart/logic/cart_cubit.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import '../components/home_categories_section.dart';
import '../components/home_header.dart';
import '../components/home_products_section.dart';
import '../components/home_search_bar.dart';
import '../components/home_slider_section.dart';
import '../components/search_results_section.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeCubit>()..initHomeData()),
        BlocProvider.value(value: getIt<CartCubit>()),
      ],
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

  @override
  Widget build(BuildContext context) {
    return SkeletonizerConfig(
      data: const SkeletonizerConfigData(
        effectResolver: _silverShimmerEffectResolver,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HomeHeader(),
                  16.verticalSpacing,
                  const HomeSearchBar(),
                  18.verticalSpacing,
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (prev, curr) =>
                        prev.isSearching != curr.isSearching,
                    builder: (context, state) {
                      if (state.isSearching) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SearchResultsSection(),
                            24.verticalSpacing,
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const HomeSliderSection(),
                          24.verticalSpacing,
                          const HomeCategoriesSection(),
                          24.verticalSpacing,
                          const HomeProductsSection(),
                          24.verticalSpacing,
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

PaintingEffect _silverShimmerEffectResolver(Brightness brightness) {
  return const ShimmerEffect(
    baseColor: Color(0xFFDCE0E5),
    highlightColor: Color(0xFFF7F8FA),
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    duration: Duration(milliseconds: 1400),
  );
}
