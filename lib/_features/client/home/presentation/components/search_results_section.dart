import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import 'build_home_error_state.dart';
import 'search_resullt_view.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.searchState != curr.searchState ||
          prev.searchResults != curr.searchResults ||
          prev.searchKeyword != curr.searchKeyword,
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        if (!state.isSearching) return const SizedBox.shrink();

        if (state.searchState == RequestState.error) {
          return BuildHomeErrorState(message: state.searchFailureMessage);
        }

        if (state.searchState == RequestState.success &&
            state.searchResults.isEmpty) {
          return _buildEmpty(state.searchKeyword);
        }

        final isLoading = state.searchState == RequestState.loading;
        final dummySearchProducts = cubit.dummySearchProducts;
        final products = isLoading ? dummySearchProducts : state.searchResults;

        return Skeletonizer(
          enabled: isLoading,
          child: SearchResulltView(isLoading: isLoading, products: products),
        );
      },
    );
  }

  Widget _buildEmpty(String keyword) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: AppColors.textLightGray.withValues(alpha: 0.5),
          ),
          12.verticalSpacing,
          Text(
            'لا توجد نتائج لـ "$keyword"',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: AppColors.textLightGray,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
