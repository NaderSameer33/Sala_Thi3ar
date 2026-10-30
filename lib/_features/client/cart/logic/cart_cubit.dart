import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/cart_data_model.dart';
import '../data/models/cart_item_model.dart';
import '../data/repos/cart_repo.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo repo;

  CartCubit(this.repo) : super(const CartState());

  final CartDataModel dummyCartData = CartDataModel(
    items: List.generate(
      4,
      (index) => const CartItemModel(
        id: -1,
        title: 'اسم المنتج التجريبي',
        image: '',
        amount: 2,
        priceBeforeDiscount: 56.0,
        discount: 11.0,
        price: 45.0,
        remainingAmount: 10,
      ),
    ),
    totalPriceBeforeDiscount: 180.0,
    totalDiscount: 40.0,
    totalPriceWithVat: 140.0,
    deliveryCost: 0.0,
    freeDeliveryPrice: 500.0,
    vat: 0.15,
    isVip: 0,
    vipMessage: '',
    status: 'success',
    message: '',
  );

  Future<void> getCart() async {
    emit(state.copyWith(
      status: CartStatus.loading,
      mutationMessage: '',
    ));

    final result = await repo.getCart();

    result.fold(
      (failure) => emit(
        state.copyWith(status: CartStatus.error, errorMessage: failure.message),
      ),
      (data) =>
          emit(state.copyWith(status: CartStatus.success, cartData: data)),
    );
  }

  Future<void> addToCart({required int productId, int amount = 1}) async {
    emit(state.copyWith(
      isMutating: true,
      mutatingProductId: () => productId,
      mutationMessage: '',
    ));

    final result = await repo.addToCart(productId: productId, amount: amount);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isMutating: false,
          mutatingProductId: () => null,
          mutationMessage: failure.message,
        ),
      ),
      (message) {
        emit(
          state.copyWith(
            isMutating: false,
            mutatingProductId: () => null,
            mutationMessage: message,
          ),
        );
        getCart();
      },
    );
  }

  Future<void> updateItemAmount({
    required int itemId,
    required int newAmount,
  }) async {
    if (newAmount < 1) return;

    final currentData = state.cartData;
    if (currentData != null) {
      final updatedItems = currentData.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(amount: newAmount);
        }
        return item;
      }).toList();
      emit(state.copyWith(cartData: currentData.copyWith(items: updatedItems)));
    }

    final result = await repo.updateItemAmount(
      itemId: itemId,
      amount: newAmount,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(mutationMessage: failure.message));
        getCart();
      },
      (message) {
        getCart();
      },
    );
  }

  Future<void> incrementAmount(CartItemModel item) async {
    if (item.id <= 0) return;
    await updateItemAmount(itemId: item.id, newAmount: item.amount + 1);
  }

  Future<void> decrementAmount(CartItemModel item) async {
    if (item.id <= 0) return;
    if (item.amount > 1) {
      await updateItemAmount(itemId: item.id, newAmount: item.amount - 1);
    } else {
      await deleteItem(item.id);
    }
  }

  Future<void> deleteItem(int itemId) async {
    if (itemId <= 0) return;

    final currentData = state.cartData;
    if (currentData != null) {
      final updatedItems = currentData.items
          .where((element) => element.id != itemId)
          .toList();
      emit(state.copyWith(cartData: currentData.copyWith(items: updatedItems)));
    }

    final result = await repo.deleteItem(itemId);

    result.fold(
      (failure) {
        emit(state.copyWith(mutationMessage: failure.message));
        getCart();
      },
      (message) {
        emit(state.copyWith(mutationMessage: message));
        getCart();
      },
    );
  }

  Future<void> applyCoupon(String coupon) async {
    final trimmed = coupon.trim();
    if (trimmed.isEmpty) return;

    emit(state.copyWith(
      cuponStatus: CuponStatus.loading,
      couponMessage: '',
    ));

    final result = await repo.applyCoupon(trimmed);

    result.fold(
      (failure) => emit(
        state.copyWith(
          cuponStatus: CuponStatus.error,
          couponMessage: failure.message,
        ),
      ),
      (message) {
        emit(
          state.copyWith(
            cuponStatus: CuponStatus.success,
            couponMessage: message,
            appliedCoupon: () => trimmed,
          ),
        );
        getCart();
      },
    );
  }

  void resetCouponStatus() {
    if (state.cuponStatus != CuponStatus.intinal || state.couponMessage.isNotEmpty) {
      emit(state.copyWith(
        cuponStatus: CuponStatus.intinal,
        couponMessage: '',
      ));
    }
  }
}
