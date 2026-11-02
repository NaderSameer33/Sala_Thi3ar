import 'package:equatable/equatable.dart';
import '../../../../client/auth/login/data/models/login_response_model.dart';

abstract class DriverLoginState extends Equatable {
  const DriverLoginState();

  @override
  List<Object?> get props => [];
}

class DriverLoginInitial extends DriverLoginState {}

class DriverLoginLoading extends DriverLoginState {}

class DriverLoginSuccess extends DriverLoginState {
  final LoginResponseModel loginResponse;

  const DriverLoginSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}

class DriverLoginError extends DriverLoginState {
  final String message;

  const DriverLoginError(this.message);

  @override
  List<Object?> get props => [message];
}

class DriverLoginPasswordVisibilityChanged extends DriverLoginState {
  final bool isObscure;

  const DriverLoginPasswordVisibilityChanged(this.isObscure);

  @override
  List<Object?> get props => [isObscure];
}
