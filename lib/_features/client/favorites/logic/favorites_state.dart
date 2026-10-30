import 'package:equatable/equatable.dart';
import '../../home/data/models/product_model.dart';

enum FavoritesStatus { initial, loading, success, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<ProductModel> favorites;
  final String errorMessage;
  final Set<int> favoriteProductIds;
  final int? togglingProductId;
  final String message;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.errorMessage = '',
    this.favoriteProductIds = const {},
    this.togglingProductId,
    this.message = '',
  });

  bool isProductFavorite(int productId) => favoriteProductIds.contains(productId);

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<ProductModel>? favorites,
    String? errorMessage,
    Set<int>? favoriteProductIds,
    int? Function()? togglingProductId,
    String? message,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      togglingProductId: togglingProductId != null
          ? togglingProductId()
          : this.togglingProductId,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    favorites,
    errorMessage,
    favoriteProductIds,
    togglingProductId,
    message,
  ];
}

