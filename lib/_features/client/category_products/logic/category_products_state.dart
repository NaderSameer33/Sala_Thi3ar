import 'package:equatable/equatable.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';

enum CategoryProductsStatus { initial, loading, success, error }

class CategoryProductsState extends Equatable {
  final CategoryProductsStatus status;
  final List<ProductModel> products;
  final String errorMessage;
  final int categoryId;
  final String categoryName;
  final String keyword;
  final String? filter;
  final double? minPrice;
  final double? maxPrice;
  final double apiMinPrice;
  final double apiMaxPrice;

  const CategoryProductsState({
    this.status = CategoryProductsStatus.initial,
    this.products = const [],
    this.errorMessage = '',
    this.categoryId = 0,
    this.categoryName = '',
    this.keyword = '',
    this.filter,
    this.minPrice,
    this.maxPrice,
    this.apiMinPrice = 0.0,
    this.apiMaxPrice = 1000.0,
  });

  bool get hasActiveFilter =>
      filter != null || minPrice != null || maxPrice != null;

  CategoryProductsState copyWith({
    CategoryProductsStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    int? categoryId,
    String? categoryName,
    String? keyword,
    String? Function()? filter,
    double? Function()? minPrice,
    double? Function()? maxPrice,
    double? apiMinPrice,
    double? apiMaxPrice,
  }) {
    return CategoryProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      keyword: keyword ?? this.keyword,
      filter: filter != null ? filter() : this.filter,
      minPrice: minPrice != null ? minPrice() : this.minPrice,
      maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
      apiMinPrice: apiMinPrice ?? this.apiMinPrice,
      apiMaxPrice: apiMaxPrice ?? this.apiMaxPrice,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        errorMessage,
        categoryId,
        categoryName,
        keyword,
        filter,
        minPrice,
        maxPrice,
        apiMinPrice,
        apiMaxPrice,
      ];
}
