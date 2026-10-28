import 'package:equatable/equatable.dart';

abstract class ClientForgetPasswordState extends Equatable {
  const ClientForgetPasswordState();

  @override
  List<Object?> get props => [];
}

class ClientForgetPasswordInitial extends ClientForgetPasswordState {}

class ClientForgetPasswordLoading extends ClientForgetPasswordState {}

class ClientForgetPasswordSuccess extends ClientForgetPasswordState {
  final String message;

  const ClientForgetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientForgetPasswordError extends ClientForgetPasswordState {
  final String message;

  const ClientForgetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
