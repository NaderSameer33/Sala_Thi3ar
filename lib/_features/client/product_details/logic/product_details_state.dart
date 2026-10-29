import 'package:equatable/equatable.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import 'package:sala_thimar/_features/client/product_details/data/models/product_rate_model.dart';

enum ProductDetailsStateStatus { initial, loading, success, error }

class ProductDetailsState extends Equatable {
  final ProductDetailsStateStatus status;
  final ProductModel? product;
  final String errorMessage;

  final ProductDetailsStateStatus ratesStatus;
  final List<ProductRateModel> rates;
  final String ratesErrorMessage;

  final ProductDetailsStateStatus similarStatus;
  final List<ProductModel> similarProducts;
  final String similarErrorMessage;

  final int quantity;

  const ProductDetailsState({
    this.status = ProductDetailsStateStatus.initial,
    this.product,
    this.errorMessage = '',
    this.ratesStatus = ProductDetailsStateStatus.initial,
    this.rates = const [],
    this.ratesErrorMessage = '',
    this.similarStatus = ProductDetailsStateStatus.initial,
    this.similarProducts = const [],
    this.similarErrorMessage = '',
    this.quantity = 1,
  });

  double get totalPrice {
    final price = product?.price ?? 0.0;
    return price * quantity;
  }

  ProductDetailsState copyWith({
    ProductDetailsStateStatus? status,
    ProductModel? product,
    String? errorMessage,
    ProductDetailsStateStatus? ratesStatus,
    List<ProductRateModel>? rates,
    String? ratesErrorMessage,
    ProductDetailsStateStatus? similarStatus,
    List<ProductModel>? similarProducts,
    String? similarErrorMessage,
    int? quantity,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
      ratesStatus: ratesStatus ?? this.ratesStatus,
      rates: rates ?? this.rates,
      ratesErrorMessage: ratesErrorMessage ?? this.ratesErrorMessage,
      similarStatus: similarStatus ?? this.similarStatus,
      similarProducts: similarProducts ?? this.similarProducts,
      similarErrorMessage: similarErrorMessage ?? this.similarErrorMessage,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        status,
        product,
        errorMessage,
        ratesStatus,
        rates,
        ratesErrorMessage,
        similarStatus,
        similarProducts,
        similarErrorMessage,
        quantity,
      ];
}
