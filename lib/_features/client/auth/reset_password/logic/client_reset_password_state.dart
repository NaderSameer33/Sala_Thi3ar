import 'package:equatable/equatable.dart';

abstract class ClientResetPasswordState extends Equatable {
  const ClientResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ClientResetPasswordInitial extends ClientResetPasswordState {}

class ClientResetPasswordLoading extends ClientResetPasswordState {}

class ClientResetPasswordSuccess extends ClientResetPasswordState {
  final String message;

  const ClientResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientResetPasswordError extends ClientResetPasswordState {
  final String message;

  const ClientResetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientResetPasswordVisibilityChanged extends ClientResetPasswordState {
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;

  const ClientResetPasswordVisibilityChanged({
    required this.isPasswordObscure,
    required this.isConfirmPasswordObscure,
  });

  @override
  List<Object?> get props => [isPasswordObscure, isConfirmPasswordObscure];
}
