import 'package:equatable/equatable.dart';
import 'package:sala_thimar/_features/client/auth/login/data/models/login_response_model.dart';

abstract class ClientLoginState extends Equatable {
  const ClientLoginState();

  @override
  List<Object?> get props => [];
}

class ClientLoginInitial extends ClientLoginState {}

class ClientLoginLoading extends ClientLoginState {}

class ClientLoginSuccess extends ClientLoginState {
  final LoginResponseModel loginResponse;

  const ClientLoginSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}

class ClientLoginError extends ClientLoginState {
  final String message;

  const ClientLoginError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientLoginPasswordVisibilityChanged extends ClientLoginState {
  final bool isObscure;

  const ClientLoginPasswordVisibilityChanged(this.isObscure);

  @override
  List<Object?> get props => [isObscure];
}
