import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'build_product_grid_view.dart';

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
    return Buildproductgridview(
      title: 'نتائج البحث',
      isLoading: isLoading,
      products: products,
    );
  }
}
