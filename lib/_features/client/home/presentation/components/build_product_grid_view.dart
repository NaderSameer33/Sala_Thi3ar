import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/product_model.dart';
import 'build_product_item.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_styles.dart';

class Buildproductgridview extends StatelessWidget {
  const Buildproductgridview({
    super.key,
    required this.products,
    required this.isLoading,
  });
  final List<ProductModel> products;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'الأصناف',
            style: AppStyles.font16BoldDark,
            textAlign: TextAlign.right,
          ),
        ),
        14.verticalSpacing,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: isLoading
                ? const NeverScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14.w,
              mainAxisSpacing: 14.h,
              childAspectRatio: 0.67,
            ),
            itemBuilder: (context, index) {
              return BuildProductItem(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}
