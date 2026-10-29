import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/product_model.dart';
import 'build_product_grid_view.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';

class SearchResulltView extends StatelessWidget {
  const SearchResulltView({
    super.key,
    required this.isLoading,
    required this.products,
  });
  final bool isLoading;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'نتائج البحث',
            style: AppStyles.font16BoldDark,
            textAlign: TextAlign.right,
          ),
        ),
        14.verticalSpacing,
        Buildproductgridview(isLoading: isLoading, products: products),
      ],
    );
  }
}
