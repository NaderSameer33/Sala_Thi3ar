import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import 'package:sala_thimar/_features/client/product_details/data/models/product_rate_model.dart';
import 'package:sala_thimar/_features/client/product_details/data/repos/product_details_repo.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsRepo repo;

  ProductDetailsCubit(this.repo) : super(const ProductDetailsState());

  void init(ProductModel initialProduct) {
    emit(state.copyWith(
      status: ProductDetailsStateStatus.success,
      product: initialProduct,
      quantity: 1,
    ));
    getProductDetails(initialProduct.id);
    getProductRates(initialProduct.id);
    getSimilarProducts(initialProduct.categoryId);
  }

  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  Future<void> getProductDetails(int productId) async {
    if (state.product == null) {
      emit(state.copyWith(status: ProductDetailsStateStatus.loading));
    }

    final result = await repo.getProductDetails(productId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: state.product != null
              ? ProductDetailsStateStatus.success
              : ProductDetailsStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (product) {
        emit(
          state.copyWith(
            status: ProductDetailsStateStatus.success,
            product: product,
          ),
        );
        if (state.similarProducts.isEmpty) {
          getSimilarProducts(product.categoryId);
        }
      },
    );
  }
     final List<ProductRateModel> dummyRates = List.generate(
    3,
    (index) => const ProductRateModel(
      value: 5,
      comment: 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة.',
      clientName: 'اسم العميل التجريبي',
      clientImage: '',
    ),
  );

  Future<void> getProductRates(int productId) async {
    emit(state.copyWith(ratesStatus: ProductDetailsStateStatus.loading));

    final result = await repo.getProductRates(productId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          ratesStatus: ProductDetailsStateStatus.error,
          ratesErrorMessage: failure.message,
        ),
      ),
      (rates) => emit(
        state.copyWith(
          ratesStatus: ProductDetailsStateStatus.success,
          rates: rates,
        ),
      ),
    );
  }

  Future<void> getSimilarProducts(int? categoryId) async {
    emit(state.copyWith(similarStatus: ProductDetailsStateStatus.loading));

    final result = await repo.getSimilarProducts(categoryId: categoryId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          similarStatus: ProductDetailsStateStatus.error,
          similarErrorMessage: failure.message,
        ),
      ),
      (products) {
        final currentId = state.product?.id;
        final filtered = currentId != null
            ? products.where((p) => p.id != currentId).toList()
            : products;
        emit(
          state.copyWith(
            similarStatus: ProductDetailsStateStatus.success,
            similarProducts: filtered,
          ),
        );
      },
    );
  }
}
