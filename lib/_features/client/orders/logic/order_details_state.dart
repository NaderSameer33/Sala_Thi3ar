import 'package:equatable/equatable.dart';
import '../data/models/order_details_model.dart';

enum OrderDetailsStatus { initial, loading, success, error }
enum OrderCancelStatus { initial, loading, success, error }

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  final OrderCancelStatus cancelStatus;
  final OrderDetailsModel? orderDetails;
  final String errorMessage;
  final String cancelMessage;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    this.cancelStatus = OrderCancelStatus.initial,
    this.orderDetails,
    this.errorMessage = '',
    this.cancelMessage = '',
  });

  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    OrderCancelStatus? cancelStatus,
    OrderDetailsModel? orderDetails,
    String? errorMessage,
    String? cancelMessage,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      cancelStatus: cancelStatus ?? this.cancelStatus,
      orderDetails: orderDetails ?? this.orderDetails,
      errorMessage: errorMessage ?? this.errorMessage,
      cancelMessage: cancelMessage ?? this.cancelMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        cancelStatus,
        orderDetails,
        errorMessage,
        cancelMessage,
      ];
}

