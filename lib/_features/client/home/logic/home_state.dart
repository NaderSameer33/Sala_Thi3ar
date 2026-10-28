import 'package:equatable/equatable.dart';
import 'package:sala_thimar/_features/client/home/data/models/category_model.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import 'package:sala_thimar/_features/client/home/data/models/slider_model.dart';

enum RequestState { initial, loading, success, error }

class HomeState extends Equatable {
  // Sliders
  final RequestState slidersState;
  final List<SliderModel> sliders;
  final String slidersMessage;

  // Categories
  final RequestState categoriesState;
  final List<CategoryModel> categories;
  final String categoriesMessage;
  final int? selectedCategoryId;

  // Products
  final RequestState productsState;
  final List<ProductModel> products;
  final String productsMessage;

  // Search
  final RequestState searchState;
  final List<ProductModel> searchResults;
  final String searchMessage;
  final String searchKeyword;

  const HomeState({
    this.slidersState = RequestState.initial,
    this.sliders = const [],
    this.slidersMessage = '',
    this.categoriesState = RequestState.initial,
    this.categories = const [],
    this.categoriesMessage = '',
    this.selectedCategoryId,
    this.productsState = RequestState.initial,
    this.products = const [],
    this.productsMessage = '',
    this.searchState = RequestState.initial,
    this.searchResults = const [],
    this.searchMessage = '',
    this.searchKeyword = '',
  });

  /// Whether the user is actively searching (keyword is non-empty)
  bool get isSearching => searchKeyword.isNotEmpty;

  bool get isInitialLoading =>
      slidersState == RequestState.loading &&
      categoriesState == RequestState.loading &&
      productsState == RequestState.loading;

  HomeState copyWith({
    RequestState? slidersState,
    List<SliderModel>? sliders,
    String? slidersMessage,
    RequestState? categoriesState,
    List<CategoryModel>? categories,
    String? categoriesMessage,
    int? Function()? selectedCategoryId,
    RequestState? productsState,
    List<ProductModel>? products,
    String? productsMessage,
    RequestState? searchState,
    List<ProductModel>? searchResults,
    String? searchMessage,
    String? searchKeyword,
  }) {
    return HomeState(
      slidersState: slidersState ?? this.slidersState,
      sliders: sliders ?? this.sliders,
      slidersMessage: slidersMessage ?? this.slidersMessage,
      categoriesState: categoriesState ?? this.categoriesState,
      categories: categories ?? this.categories,
      categoriesMessage: categoriesMessage ?? this.categoriesMessage,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      productsState: productsState ?? this.productsState,
      products: products ?? this.products,
      productsMessage: productsMessage ?? this.productsMessage,
      searchState: searchState ?? this.searchState,
      searchResults: searchResults ?? this.searchResults,
      searchMessage: searchMessage ?? this.searchMessage,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }

  @override
  List<Object?> get props => [
        slidersState,
        sliders,
        slidersMessage,
        categoriesState,
        categories,
        categoriesMessage,
        selectedCategoryId,
        productsState,
        products,
        productsMessage,
        searchState,
        searchResults,
        searchMessage,
        searchKeyword,
      ];
}
