import 'package:equatable/equatable.dart';
import '../data/models/order_model.dart';

enum OrdersTab { current, finished }
enum OrdersStatus { initial, loading, success, error }

class OrdersState extends Equatable {
  final OrdersTab activeTab;
  final OrdersStatus currentStatus;
  final OrdersStatus finishedStatus;
  final List<OrderModel> currentOrders;
  final List<OrderModel> finishedOrders;
  final String errorMessage;

  const OrdersState({
    this.activeTab = OrdersTab.current,
    this.currentStatus = OrdersStatus.initial,
    this.finishedStatus = OrdersStatus.initial,
    this.currentOrders = const [],
    this.finishedOrders = const [],
    this.errorMessage = '',
  });

  bool get isCurrentLoading => currentStatus == OrdersStatus.loading;
  bool get isFinishedLoading => finishedStatus == OrdersStatus.loading;
  bool get isLoading => activeTab == OrdersTab.current ? isCurrentLoading : isFinishedLoading;

  List<OrderModel> get displayedOrders =>
      activeTab == OrdersTab.current ? currentOrders : finishedOrders;

  OrdersState copyWith({
    OrdersTab? activeTab,
    OrdersStatus? currentStatus,
    OrdersStatus? finishedStatus,
    List<OrderModel>? currentOrders,
    List<OrderModel>? finishedOrders,
    String? errorMessage,
  }) {
    return OrdersState(
      activeTab: activeTab ?? this.activeTab,
      currentStatus: currentStatus ?? this.currentStatus,
      finishedStatus: finishedStatus ?? this.finishedStatus,
      currentOrders: currentOrders ?? this.currentOrders,
      finishedOrders: finishedOrders ?? this.finishedOrders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        currentStatus,
        finishedStatus,
        currentOrders,
        finishedOrders,
        errorMessage,
      ];
}
