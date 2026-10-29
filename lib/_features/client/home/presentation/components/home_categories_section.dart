import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import 'build_home_error_state.dart';
import 'home_categoris_list_view.dart';

import 'package:skeletonizer/skeletonizer.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.categoriesState != curr.categoriesState ||
          prev.categories != curr.categories ||
          prev.selectedCategoryId != curr.selectedCategoryId,
      builder: (context, state) {
        if (state.categoriesState == RequestState.error) {
          return BuildHomeErrorState(
            message: state.categoriesFaliureMessage,
            onTap: () => cubit.getCategories(),
          );
        }

        if (state.categoriesState == RequestState.success &&
            state.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        final isLoading = state.categoriesState == RequestState.loading;
        final categories = isLoading ? cubit.dummyCategories : state.categories;

        return Skeletonizer(
          enabled: isLoading,
          child: HomeCategorisListView(
            isLoading: isLoading,
            categories: categories,
            selectedCategoryId: state.selectedCategoryId ?? -1,
          ),
        );
      },
    );
  }
}
