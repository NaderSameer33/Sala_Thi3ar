import 'package:equatable/equatable.dart';
import '../data/models/address_model.dart';

enum AddressesStatus { initial, loading, success, error }
enum AddressActionStatus { initial, loading, success, error }
enum AddressActionType { none, add, update, delete }

class AddressesState extends Equatable {
  final AddressesStatus status;
  final AddressActionStatus actionStatus;
  final AddressActionType actionType;
  final List<AddressModel> addresses;
  final String errorMessage;
  final String actionMessage;
  final int? deletingId;

  const AddressesState({
    this.status = AddressesStatus.initial,
    this.actionStatus = AddressActionStatus.initial,
    this.actionType = AddressActionType.none,
    this.addresses = const [],
    this.errorMessage = '',
    this.actionMessage = '',
    this.deletingId,
  });

  bool get isLoading => status == AddressesStatus.loading;
  bool get isActionLoading => actionStatus == AddressActionStatus.loading;

  AddressesState copyWith({
    AddressesStatus? status,
    AddressActionStatus? actionStatus,
    AddressActionType? actionType,
    List<AddressModel>? addresses,
    String? errorMessage,
    String? actionMessage,
    int? deletingId,
    bool clearDeletingId = false,
  }) {
    return AddressesState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      actionType: actionType ?? this.actionType,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage ?? this.errorMessage,
      actionMessage: actionMessage ?? this.actionMessage,
      deletingId: clearDeletingId ? null : (deletingId ?? this.deletingId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        actionType,
        addresses,
        errorMessage,
        actionMessage,
        deletingId,
      ];
}
