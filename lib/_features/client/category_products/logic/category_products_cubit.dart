import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import '../data/repos/category_products_repo.dart';
import 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final CategoryProductsRepo repo;
  Timer? _debounce;

  CategoryProductsCubit(this.repo) : super(const CategoryProductsState());

  static final List<ProductModel> dummyProducts = List.generate(
    6,
    (index) => const ProductModel(
      id: -1,
      categoryId: 1,
      title: 'اسم المنتج التجريبي',
      description: '',
      code: '',
      priceBeforeDiscount: 100.0,
      price: 80.0,
      discount: 0.2,
      amount: 10,
      isActive: 1,
      isFavorite: false,
      unit: ProductUnitModel(id: 1, name: 'كيلو', type: 'kg'),
      images: [],
      mainImage: '',
      createdAt: '',
    ),
  );

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  void init({
    required int categoryId,
    required String categoryName,
  }) {
    emit(state.copyWith(
      categoryId: categoryId,
      categoryName: categoryName,
    ));
    fetchProducts();
  }

  void onSearchChanged(String keyword) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      emit(state.copyWith(keyword: keyword));
      fetchProducts();
    });
  }

  void applyFilter({
    String? filter,
    double? minPrice,
    double? maxPrice,
  }) {
    emit(state.copyWith(
      filter: () => filter,
      minPrice: () => minPrice,
      maxPrice: () => maxPrice,
    ));
    fetchProducts();
  }

  void clearFilter() {
    emit(state.copyWith(
      filter: () => null,
      minPrice: () => null,
      maxPrice: () => null,
    ));
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    emit(state.copyWith(status: CategoryProductsStatus.loading));

    final result = await repo.getCategoryProducts(
      categoryId: state.categoryId,
      keyword: state.keyword,
      filter: state.filter,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoryProductsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: CategoryProductsStatus.success,
          products: response.data,
          apiMinPrice: response.minPrice > 0 ? response.minPrice : 0.0,
          apiMaxPrice: response.maxPrice > 0 ? response.maxPrice : 1000.0,
        ),
      ),
    );
  }
}
