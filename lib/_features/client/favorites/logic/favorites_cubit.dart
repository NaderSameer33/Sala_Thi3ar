import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import '../data/repos/favorites_repo.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo repo;

  FavoritesCubit(this.repo) : super(const FavoritesState());

  final List<ProductModel> dummyFavorites = List.generate(
    6,
    (index) => ProductModel(
      id: -(index + 1),
      categoryId: 1,
      title: 'منتج تجريبي',
      description: '',
      code: '',
      priceBeforeDiscount: 56.0,
      price: 45.0,
      discount: 0.2,
      amount: 10,
      isActive: 1,
      isFavorite: true,
      images: const [],
      mainImage: '',
      createdAt: '',
    ),
  );

  Future<void> getFavorites() async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    final result = await repo.getFavorites();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (products) {
        final ids = products.map((p) => p.id).toSet();
        emit(
          state.copyWith(
            status: FavoritesStatus.success,
            favorites: products,
            favoriteProductIds: ids,
          ),
        );
      },
    );
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (product.id <= 0) return;

    final productId = product.id;
    final isCurrentlyFav = state.isProductFavorite(productId);

    final updatedIds = Set<int>.from(state.favoriteProductIds);
    List<ProductModel> updatedFavorites = List<ProductModel>.from(state.favorites);

    if (isCurrentlyFav) {
      updatedIds.remove(productId);
      updatedFavorites.removeWhere((p) => p.id == productId);
    } else {
      updatedIds.add(productId);
      if (!updatedFavorites.any((p) => p.id == productId)) {
        updatedFavorites.insert(0, product.copyWith(isFavorite: true));
      }
    }

    emit(state.copyWith(
      favoriteProductIds: updatedIds,
      favorites: updatedFavorites,
      togglingProductId: () => productId,
    ));

    final result = isCurrentlyFav
        ? await repo.removeFromFavorite(productId)
        : await repo.addToFavorite(productId);

    result.fold(
      (failure) {
        final revertedIds = Set<int>.from(state.favoriteProductIds);
        List<ProductModel> revertedFavorites = List<ProductModel>.from(state.favorites);

        if (isCurrentlyFav) {
          revertedIds.add(productId);
          if (!revertedFavorites.any((p) => p.id == productId)) {
            revertedFavorites.insert(0, product.copyWith(isFavorite: true));
          }
        } else {
          revertedIds.remove(productId);
          revertedFavorites.removeWhere((p) => p.id == productId);
        }

        emit(state.copyWith(
          favoriteProductIds: revertedIds,
          favorites: revertedFavorites,
          togglingProductId: () => null,
          message: failure.message,
        ));
      },
      (successMessage) {
        emit(state.copyWith(
          togglingProductId: () => null,
          message: successMessage,
        ));
      },
    );
  }
}
