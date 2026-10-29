import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/app_input.dart';
import '../../logic/category_products_cubit.dart';
import '../../logic/category_products_state.dart';
import 'category_filter_bottom_sheet.dart';

class CategorySearchBarWithFilter extends StatefulWidget {
  const CategorySearchBarWithFilter({super.key});

  @override
  State<CategorySearchBarWithFilter> createState() =>
      _CategorySearchBarWithFilterState();
}

class _CategorySearchBarWithFilterState
    extends State<CategorySearchBarWithFilter> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
      buildWhen: (prev, curr) =>
          prev.hasActiveFilter != curr.hasActiveFilter ||
          prev.keyword != curr.keyword,
      builder: (context, state) {
        final cubit = context.read<CategoryProductsCubit>();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final filterData = await CategoryFilterBottomSheet.show(
                    context: context,
                    minPrice: state.apiMinPrice,
                    maxPrice: state.apiMaxPrice,
                    currentMinPrice: state.minPrice,
                    currentMaxPrice: state.maxPrice,
                    currentFilter: state.filter,
                  );

                  if (filterData != null) {
                    cubit.applyFilter(
                      filter: filterData.filter,
                      minPrice: filterData.minPrice,
                      maxPrice: filterData.maxPrice,
                    );
                  }
                },
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 24,
                        ),
                        if (state.hasActiveFilter)
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              12.horizontalSpacing,
              Expanded(
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AppInput(
                    controller: _controller,
                    hintText: 'ابحث عن ماتريد؟',
                    onChanged: (val) => cubit.onSearchChanged(val),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: Image.asset(
                        'assets/images/Search.png',
                        width: 20.w,
                        height: 20.h,
                        color: AppColors.primary,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    suffixIcon: state.keyword.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.textLightGray,
                              size: 18,
                            ),
                            onPressed: () {
                              _controller.clear();
                              cubit.onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
