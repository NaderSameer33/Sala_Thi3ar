import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sala_thimar/_features/client/home/data/models/category_model.dart';
import 'package:sala_thimar/_features/client/home/logic/home_cubit.dart';
import 'package:sala_thimar/_features/client/home/logic/home_state.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.categoriesState != curr.categoriesState ||
          prev.categories != curr.categories ||
          prev.selectedCategoryId != curr.selectedCategoryId,
      builder: (context, state) {
        if (state.categoriesState == RequestState.error) {
          return _buildError(context, state.categoriesMessage);
        }

        if (state.categoriesState == RequestState.success) {
          if (state.categories.isEmpty) {
            return const SizedBox.shrink();
          }
          return _buildContent(state.categories, state.selectedCategoryId);
        }

        return _buildSkeleton();
      },
    );
  }

  Widget _buildContent(
    List<CategoryModel> categories,
    int? selectedCategoryId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'الأقسام',
            style: AppStyles.font16BoldDark,
            textAlign: TextAlign.right,
          ),
        ),
        12.verticalSpacing,
        // Horizontal scrollable list
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, _) => 20.horizontalSpacing,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategoryId == category.id;
              return _buildCategoryItem(context, category, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    CategoryModel category,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => context.read<HomeCubit>().filterByCategory(category.id),
      child: Column(
        children: [
          // Circular image
          Container(
            width: 65.w,
            height: 65.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.primaryTint,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: category.media,
                fit: BoxFit.cover,
                width: 65.w,
                height: 65.h,
                placeholder: (_, _) => Skeletonizer(
                  enabled: true,
                  child: Container(
                    width: 65.w,
                    height: 65.h,
                    color: AppColors.inputFill,
                  ),
                ),
                errorWidget: (_, _, _) => Padding(
                  padding: EdgeInsets.all(14.r),
                  child: const Icon(
                    Icons.category_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          6.verticalSpacing,
          // Category name
          SizedBox(
            width: 65.w,
            child: Text(
              category.name,
              style: AppStyles.font12RegularGray.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              width: 60.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
          12.verticalSpacing,
          SizedBox(
            height: 100.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (_, _) => 12.horizontalSpacing,
              itemBuilder: (_, _) => Column(
                children: [
                  Container(
                    width: 65.w,
                    height: 65.h,
                    decoration: const BoxDecoration(
                      color: AppColors.inputFill,
                      shape: BoxShape.circle,
                    ),
                  ),
                  6.verticalSpacing,
                  Container(
                    width: 48.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.textLightGray,
                fontSize: 13.sp,
              ),
            ),
            8.horizontalSpacing,
            InkWell(
              onTap: () => context.read<HomeCubit>().getCategories(),
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppColors.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
