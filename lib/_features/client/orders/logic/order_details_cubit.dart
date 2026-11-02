import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/order_details_model.dart';
import '../data/models/order_model.dart';
import '../data/repos/orders_repo.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrdersRepo _ordersRepo;

  OrderDetailsCubit(this._ordersRepo) : super(const OrderDetailsState());

  void init(int orderId, [OrderModel? initialOrder]) {
    if (initialOrder != null) {
      emit(state.copyWith(
        orderDetails: OrderDetailsModel.fromOrderModel(initialOrder),
        status: OrderDetailsStatus.loading,
      ));
    } else {
      emit(state.copyWith(status: OrderDetailsStatus.loading));
    }
    fetchOrderDetails(orderId);
  }

  Future<void> fetchOrderDetails(int orderId) async {
    final result = await _ordersRepo.getOrderDetails(orderId);
    result.fold(
      (failure) {
        if (state.orderDetails == null) {
          emit(state.copyWith(
            status: OrderDetailsStatus.error,
            errorMessage: failure.message,
          ));
        } else {
          emit(state.copyWith(status: OrderDetailsStatus.success));
        }
      },
      (details) => emit(state.copyWith(
        status: OrderDetailsStatus.success,
        orderDetails: details,
      )),
    );
  }

  Future<void> cancelOrder(int orderId) async {
    emit(state.copyWith(cancelStatus: OrderCancelStatus.loading));
    final result = await _ordersRepo.cancelOrder(orderId);
    result.fold(
      (failure) => emit(state.copyWith(
        cancelStatus: OrderCancelStatus.error,
        errorMessage: failure.message,
      )),
      (message) {
        final current = state.orderDetails;
        OrderDetailsModel? updated;
        if (current != null) {
          updated = OrderDetailsModel(
            id: current.id,
            status: 'canceled',
            statusTranslated: 'طلب ملغي',
            date: current.date,
            orderPrice: current.orderPrice,
            deliveryPrice: current.deliveryPrice,
            totalPrice: current.totalPrice,
            payType: current.payType,
            addressTitle: current.addressTitle,
            addressDescription: current.addressDescription,
            addressLocation: current.addressLocation,
            lat: current.lat,
            lng: current.lng,
            products: current.products,
          );
        }
        emit(state.copyWith(
          cancelStatus: OrderCancelStatus.success,
          cancelMessage: message,
          orderDetails: updated ?? current,
        ));
      },
    );
  }

  void resetCancelStatus() {
    emit(state.copyWith(cancelStatus: OrderCancelStatus.initial));
  }
}

