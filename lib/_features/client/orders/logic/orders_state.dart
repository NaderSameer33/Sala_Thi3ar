import 'package:equatable/equatable.dart';
import '../data/models/order_model.dart';

enum OrdersTab { current, finished }
enum OrdersStatus { initial, loading, success, error }
enum CreateOrderStatus { initial, loading, success, error }

class OrdersState extends Equatable {
  final OrdersTab activeTab;
  final OrdersStatus currentStatus;
  final OrdersStatus finishedStatus;
  final CreateOrderStatus createOrderStatus;
  final List<OrderModel> currentOrders;
  final List<OrderModel> finishedOrders;
  final String errorMessage;
  final String orderSuccessMessage;

  const OrdersState({
    this.activeTab = OrdersTab.current,
    this.currentStatus = OrdersStatus.initial,
    this.finishedStatus = OrdersStatus.initial,
    this.createOrderStatus = CreateOrderStatus.initial,
    this.currentOrders = const [],
    this.finishedOrders = const [],
    this.errorMessage = '',
    this.orderSuccessMessage = '',
  });

  bool get isCurrentLoading => currentStatus == OrdersStatus.loading;
  bool get isFinishedLoading => finishedStatus == OrdersStatus.loading;
  bool get isCreatingOrder => createOrderStatus == CreateOrderStatus.loading;
  bool get isLoading => activeTab == OrdersTab.current ? isCurrentLoading : isFinishedLoading;

  List<OrderModel> get displayedOrders =>
      activeTab == OrdersTab.current ? currentOrders : finishedOrders;

  OrdersState copyWith({
    OrdersTab? activeTab,
    OrdersStatus? currentStatus,
    OrdersStatus? finishedStatus,
    CreateOrderStatus? createOrderStatus,
    List<OrderModel>? currentOrders,
    List<OrderModel>? finishedOrders,
    String? errorMessage,
    String? orderSuccessMessage,
  }) {
    return OrdersState(
      activeTab: activeTab ?? this.activeTab,
      currentStatus: currentStatus ?? this.currentStatus,
      finishedStatus: finishedStatus ?? this.finishedStatus,
      createOrderStatus: createOrderStatus ?? this.createOrderStatus,
      currentOrders: currentOrders ?? this.currentOrders,
      finishedOrders: finishedOrders ?? this.finishedOrders,
      errorMessage: errorMessage ?? this.errorMessage,
      orderSuccessMessage: orderSuccessMessage ?? this.orderSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        currentStatus,
        finishedStatus,
        createOrderStatus,
        currentOrders,
        finishedOrders,
        errorMessage,
        orderSuccessMessage,
      ];
}
