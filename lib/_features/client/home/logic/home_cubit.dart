import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/home/data/repos/home_repo.dart';
import 'package:sala_thimar/_features/client/home/logic/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(const HomeState());

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
}
