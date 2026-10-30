import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/orders_repo.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo _ordersRepo;

  OrdersCubit(this._ordersRepo) : super(const OrdersState());

  void changeTab(OrdersTab tab) {
    emit(state.copyWith(activeTab: tab));
    if (tab == OrdersTab.current && state.currentStatus == OrdersStatus.initial) {
      getCurrentOrders();
    } else if (tab == OrdersTab.finished && state.finishedStatus == OrdersStatus.initial) {
      getFinishedOrders();
    }
  }

  Future<void> getCurrentOrders() async {
    emit(state.copyWith(currentStatus: OrdersStatus.loading));
    final result = await _ordersRepo.getCurrentOrders();
    result.fold(
      (failure) => emit(state.copyWith(
        currentStatus: OrdersStatus.error,
        errorMessage: failure.message,
      )),
      (orders) => emit(state.copyWith(
        currentStatus: OrdersStatus.success,
        currentOrders: orders,
      )),
    );
  }

  Future<void> getFinishedOrders() async {
    emit(state.copyWith(finishedStatus: OrdersStatus.loading));
    final result = await _ordersRepo.getFinishedOrders();
    result.fold(
      (failure) => emit(state.copyWith(
        finishedStatus: OrdersStatus.error,
        errorMessage: failure.message,
      )),
      (orders) => emit(state.copyWith(
        finishedStatus: OrdersStatus.success,
        finishedOrders: orders,
      )),
    );
  }

  Future<void> refresh() async {
    if (state.activeTab == OrdersTab.current) {
      await getCurrentOrders();
    } else {
      await getFinishedOrders();
    }
  }
}
