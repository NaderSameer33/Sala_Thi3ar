import 'package:equatable/equatable.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/models/slider_model.dart';

enum RequestState { initial, loading, success, error }

class HomeState extends Equatable {
  final RequestState slidersState;
  final List<SliderModel> sliders;
  final String sliderFailureMessage;

  final RequestState categoriesState;
  final List<CategoryModel> categories;
  final String categoriesFaliureMessage;
  final int? selectedCategoryId;

  final RequestState productsState;
  final List<ProductModel> products;
  final String productsFailureMessage;

  final RequestState searchState;
  final List<ProductModel> searchResults;
  final String searchFailureMessage;
  final String searchKeyword;

  const HomeState({
    this.slidersState = RequestState.initial,
    this.sliders = const [],
    this.sliderFailureMessage = '',
    this.categoriesState = RequestState.initial,
    this.categories = const [],
    this.categoriesFaliureMessage = '',
    this.selectedCategoryId,
    this.productsState = RequestState.initial,
    this.products = const [],
    this.productsFailureMessage = '',
    this.searchState = RequestState.initial,
    this.searchResults = const [],
    this.searchFailureMessage = '',
    this.searchKeyword = '',
  });

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
      sliderFailureMessage: slidersMessage ?? sliderFailureMessage,
      categoriesState: categoriesState ?? this.categoriesState,
      categories: categories ?? this.categories,
      categoriesFaliureMessage: categoriesMessage ?? categoriesFaliureMessage,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      productsState: productsState ?? this.productsState,
      products: products ?? this.products,
      productsFailureMessage: productsMessage ?? productsFailureMessage,
      searchState: searchState ?? this.searchState,
      searchResults: searchResults ?? this.searchResults,
      searchFailureMessage: searchMessage ?? this.searchFailureMessage,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }

  @override
  List<Object?> get props => [
    slidersState,
    sliders,
    sliderFailureMessage,
    categoriesState,
    categories,
    categoriesFaliureMessage,
    selectedCategoryId,
    productsState,
    products,
    productsFailureMessage,
    searchState,
    searchResults,
    searchFailureMessage,
    searchKeyword,
  ];
}
