import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/home/logic/home_cubit.dart';
import 'package:sala_thimar/_features/client/home/logic/home_state.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/home_categories_section.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/home_header.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/home_products_section.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/home_search_bar.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/home_slider_section.dart';
import 'package:sala_thimar/_features/client/home/presentation/components/search_results_section.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..initHomeData(),
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                HomeHeader(),
                16.verticalSpacing,
                const HomeSearchBar(),
                18.verticalSpacing,
                // ── Search mode: show results only ──────────────────────────
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
                    // ── Normal home mode ─────────────────────────────────────
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
    );
  }
}
