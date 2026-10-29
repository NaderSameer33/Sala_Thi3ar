import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/category_model.dart';
import 'build_category_item.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';

class HomeCategorisListView extends StatelessWidget {
  const HomeCategorisListView({
    super.key,
    required this.isLoading,
    required this.categories, required this.selectedCategoryId,
  });
  final bool isLoading;
  final List<CategoryModel> categories;
  final int selectedCategoryId ; 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'الأقسام',
            style: AppStyles.font16BoldDark,
            textAlign: TextAlign.right,
          ),
        ),
        12.verticalSpacing,
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: isLoading
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, _) => 20.horizontalSpacing,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategoryId == category.id;
              return BuildCategoryItem(
                isLoading: isLoading,
                isSelected: isSelected,
                category: category,
              );
            },
          ),
        ),
      ],
    );
  }
}
