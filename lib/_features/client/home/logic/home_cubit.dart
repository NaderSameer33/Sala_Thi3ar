import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/home/data/repos/home_repo.dart';
import 'package:sala_thimar/_features/client/home/logic/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  /// Debounce timer for the search input
  Timer? _searchDebounce;

  HomeCubit(this.homeRepo) : super(const HomeState());

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> initHomeData() async {
    await Future.wait([
      getSliders(),
      getCategories(),
      getProducts(),
    ]);
  }

  /// Pull-to-refresh handler
  Future<void> refreshHomeData() async {
    await Future.wait([
      getSliders(),
      getCategories(),
      getProducts(categoryId: state.selectedCategoryId),
    ]);
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

  void filterByCategory(int? categoryId) {
    if (state.selectedCategoryId == categoryId) {
      // Deselect category -> show all products
      emit(state.copyWith(selectedCategoryId: () => null));
      getProducts();
    } else {
      // Select category -> show filtered products
      emit(state.copyWith(selectedCategoryId: () => categoryId));
      getProducts(categoryId: categoryId);
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────────

  /// Called on every keystroke; debounces 400 ms before hitting the API.
  void onSearchChanged(String keyword) {
    _searchDebounce?.cancel();

    final trimmed = keyword.trim();

    if (trimmed.isEmpty) {
      clearSearch();
      return;
    }

    emit(state.copyWith(
      searchKeyword: trimmed,
      searchState: RequestState.loading,
    ));

    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _fetchSearch(trimmed);
    });
  }

  /// Clears the search and restores normal home view.
  void clearSearch() {
    _searchDebounce?.cancel();
    emit(state.copyWith(
      searchKeyword: '',
      searchState: RequestState.initial,
      searchResults: [],
      searchMessage: '',
    ));
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
}
