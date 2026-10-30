import 'package:equatable/equatable.dart';
import '../data/models/cart_data_model.dart';

enum CartStatus { initial, loading, success, error }

enum CuponStatus { intinal, loading, success, error }

class CartState extends Equatable {
  final CartStatus status;
  final CartDataModel? cartData;
  final String errorMessage;
  final bool isMutating;
  final int? mutatingProductId;
  final String mutationMessage;
  final CuponStatus cuponStatus;
  final String couponMessage;
  final String? appliedCoupon;

  const CartState({
    this.cuponStatus = CuponStatus.intinal,
    this.status = CartStatus.initial,
    this.cartData,
    this.errorMessage = '',
    this.isMutating = false,
    this.mutatingProductId,
    this.mutationMessage = '',
    this.couponMessage = '',
    this.appliedCoupon,
  });

  bool get isEmpty => cartData == null || cartData!.items.isEmpty;

  CartState copyWith({
    CartStatus? status,
    CartDataModel? cartData,
    String? errorMessage,
    bool? isMutating,
    int? Function()? mutatingProductId,
    String? mutationMessage,
    String? couponMessage,
    String? Function()? appliedCoupon,
    CuponStatus? cuponStatus,
  }) {
    return CartState(
      cuponStatus: cuponStatus ?? this.cuponStatus,
      status: status ?? this.status,
      cartData: cartData ?? this.cartData,
      errorMessage: errorMessage ?? this.errorMessage,
      isMutating: isMutating ?? this.isMutating,
      mutatingProductId: mutatingProductId != null
          ? mutatingProductId()
          : this.mutatingProductId,
      mutationMessage: mutationMessage ?? this.mutationMessage,
      couponMessage: couponMessage ?? this.couponMessage,
      appliedCoupon: appliedCoupon != null
          ? appliedCoupon()
          : this.appliedCoupon,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cartData,
    errorMessage,
    isMutating,
    mutatingProductId,
    mutationMessage,
    couponMessage,
    appliedCoupon,
    cuponStatus,
  ];
}
