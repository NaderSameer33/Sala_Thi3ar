import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/add_address_request_body.dart';
import '../data/repos/addresses_repo.dart';
import 'addresses_state.dart';

class AddressesCubit extends Cubit<AddressesState> {
  final AddressesRepo _addressesRepo;

  AddressesCubit(this._addressesRepo) : super(const AddressesState());

  void resetActionStatus() {
    emit(state.copyWith(
      actionStatus: AddressActionStatus.initial,
      actionMessage: '',
      actionType: AddressActionType.none,
      clearDeletingId: true,
    ));
  }

  Future<void> getAddresses() async {
    emit(state.copyWith(
      status: AddressesStatus.loading,
    ));
    final result = await _addressesRepo.getAddresses();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AddressesStatus.error,
        errorMessage: failure.message,
      )),
      (addresses) => emit(state.copyWith(
        status: AddressesStatus.success,
        addresses: addresses,
      )),
    );
  }

  Future<bool> addAddress(AddAddressRequestBody body) async {
    emit(state.copyWith(
      actionStatus: AddressActionStatus.loading,
      actionType: AddressActionType.add,
    ));
    final result = await _addressesRepo.addAddress(body);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          actionStatus: AddressActionStatus.error,
          actionType: AddressActionType.add,
          errorMessage: failure.message,
        ));
        return false;
      },
      (message) {
        emit(state.copyWith(
          actionStatus: AddressActionStatus.success,
          actionType: AddressActionType.add,
          actionMessage: message,
        ));
        getAddresses();
        return true;
      },
    );
  }

  Future<bool> updateAddress(int id, AddAddressRequestBody body) async {
    emit(state.copyWith(
      actionStatus: AddressActionStatus.loading,
      actionType: AddressActionType.update,
    ));
    final result = await _addressesRepo.updateAddress(id, body);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          actionStatus: AddressActionStatus.error,
          actionType: AddressActionType.update,
          errorMessage: failure.message,
        ));
        return false;
      },
      (message) {
        emit(state.copyWith(
          actionStatus: AddressActionStatus.success,
          actionType: AddressActionType.update,
          actionMessage: message,
        ));
        getAddresses();
        return true;
      },
    );
  }

  Future<bool> deleteAddress(int id) async {
    emit(state.copyWith(
      actionStatus: AddressActionStatus.loading,
      actionType: AddressActionType.delete,
      deletingId: id,
    ));
    final result = await _addressesRepo.deleteAddress(id);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          actionStatus: AddressActionStatus.error,
          actionType: AddressActionType.delete,
          errorMessage: failure.message,
          clearDeletingId: true,
        ));
        return false;
      },
      (message) {
        emit(state.copyWith(
          actionStatus: AddressActionStatus.success,
          actionType: AddressActionType.delete,
          actionMessage: message,
          clearDeletingId: true,
        ));
        getAddresses();
        return true;
      },
    );
  }
}
