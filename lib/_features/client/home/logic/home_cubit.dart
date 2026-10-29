import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/models/slider_model.dart';
import '../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  Timer? _searchDebounce;

  HomeCubit(this.homeRepo) : super(const HomeState());

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> initHomeData() async {
    await Future.wait([getSliders(), getCategories(), getProducts()]);
  }

  Future<void> refreshHomeData() async {
    await initHomeData();
  }

  List<SliderModel> dummySlider() {
    return [SliderModel(id: 1, media: '')];
  }

  Future<void> getSliders() async {
    emit(state.copyWith(slidersState: RequestState.loading));

    final result = await homeRepo.getSliders();

    result.fold(
      (failure) => emit(
        state.copyWith(
          slidersState: RequestState.error,
          slidersMessage: failure.message,
        ),
      ),
      (slidersList) => emit(
        state.copyWith(
          slidersState: RequestState.success,
          sliders: slidersList,
        ),
      ),
    );
  }

  Future<void> getCategories() async {
    emit(state.copyWith(categoriesState: RequestState.loading));

    final result = await homeRepo.getCategories();

    result.fold(
      (failure) => emit(
        state.copyWith(
          categoriesState: RequestState.error,
          categoriesMessage: failure.message,
        ),
      ),
      (categoriesList) => emit(
        state.copyWith(
          categoriesState: RequestState.success,
          categories: categoriesList,
        ),
      ),
    );
  }

  final List<CategoryModel> dummyCategories = List.generate(
    6,
    (index) => const CategoryModel(id: -1, name: 'اسم القسم', media: ''),
  );

  Future<void> getProducts({
    int? categoryId,
    Map<String, dynamic>? queryParameters,
  }) async {
    emit(state.copyWith(productsState: RequestState.loading));

    final params = Map<String, dynamic>.from(queryParameters ?? {});
    final targetCategory = categoryId ?? state.selectedCategoryId;
    if (targetCategory != null) {
      params['category_id'] = targetCategory;
    }

    final result = await homeRepo.getProducts(
      queryParameters: params.isNotEmpty ? params : null,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          productsState: RequestState.error,
          productsMessage: failure.message,
        ),
      ),
      (productsList) => emit(
        state.copyWith(
          productsState: RequestState.success,
          products: productsList,
        ),
      ),
    );
  }

  final List<ProductModel> dummyProducts = List.generate(
    4,
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

  void filterByCategory(int? categoryId) {
    if (state.selectedCategoryId == categoryId) {
      emit(state.copyWith(selectedCategoryId: () => null));
      getProducts();
    } else {
      emit(state.copyWith(selectedCategoryId: () => categoryId));
      getProducts(categoryId: categoryId);
    }
  }

  void onSearchChanged(String keyword) {
    _searchDebounce?.cancel();

    final trimmed = keyword.trim();

    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }

    emit(
      state.copyWith(searchKeyword: trimmed, searchState: RequestState.loading),
    );

    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _fetchSearch(trimmed);
    });
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    emit(
      state.copyWith(
        searchKeyword: '',
        searchState: RequestState.initial,
        searchResults: [],
        searchMessage: '',
      ),
    );
  }

  Future<void> _fetchSearch(String keyword) async {
    final result = await homeRepo.search(keyword);

    result.fold(
      (failure) => emit(
        state.copyWith(
          searchState: RequestState.error,
          searchMessage: failure.message,
        ),
      ),
      (results) => emit(
        state.copyWith(
          searchState: RequestState.success,
          searchResults: results,
        ),
      ),
    );
  }
   final List<ProductModel> dummySearchProducts = List.generate(
    4,
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
}
