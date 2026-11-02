import 'dart:async';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sala_thimar/core/base/safe_cubit.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/models/slider_model.dart';
import '../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with SafeEmitMixin {
  final HomeRepo homeRepo;

  Timer? _searchDebounce;

  HomeCubit(this.homeRepo) : super(const HomeState());

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> initHomeData() async {
    determineUserLocation();
    await Future.wait([getSliders(), getCategories(), getProducts()]);
  }

  Future<void> refreshHomeData() async {
    await Future.wait([
      determineUserLocation(),
      getSliders(),
      getCategories(),
      getProducts(),
    ]);
  }

  Future<void> determineUserLocation() async {
    emit(state.copyWith(locationState: RequestState.loading));
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            locationState: RequestState.error,
            userCity: 'الموقع غير مفعل',
          ),
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              locationState: RequestState.error,
              userCity: 'حدد موقعك',
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            locationState: RequestState.error,
            userCity: 'حدد موقعك',
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        locale: const Locale('ar'),
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city =
            (place.locality != null && place.locality!.trim().isNotEmpty)
                ? place.locality!.trim()
                : (place.subAdministrativeArea != null &&
                   place.subAdministrativeArea!.trim().isNotEmpty)
                ? place.subAdministrativeArea!.trim()
                : (place.administrativeArea != null &&
                   place.administrativeArea!.trim().isNotEmpty)
                ? place.administrativeArea!.trim()
                : '';

        final sub =
            (place.subLocality != null && place.subLocality!.trim().isNotEmpty)
                ? place.subLocality!.trim()
                : '';

        String displayLocation = city;
        if (sub.isNotEmpty && city.isNotEmpty && sub != city) {
          displayLocation = '$sub - $city';
        } else if (displayLocation.isEmpty) {
          displayLocation = sub.isNotEmpty ? sub : 'موقعي الحالي';
        }

        emit(
          state.copyWith(
            locationState: RequestState.success,
            userCity: displayLocation,
          ),
        );
      } else {
        emit(
          state.copyWith(
            locationState: RequestState.success,
            userCity: 'موقعي الحالي',
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          locationState: RequestState.error,
          userCity: state.userCity.isNotEmpty ? state.userCity : 'حدد موقعك',
        ),
      );
    }
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
