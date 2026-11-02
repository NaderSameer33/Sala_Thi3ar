import 'package:equatable/equatable.dart';
import 'package:sala_thimar/_features/client/account/data/models/user_profile_model.dart';
import '../data/models/register_response_model.dart';

abstract class ClientRegisterState extends Equatable {
  const ClientRegisterState();

  @override
  List<Object?> get props => [];
}

class ClientRegisterInitial extends ClientRegisterState {}

class ClientRegisterLoading extends ClientRegisterState {}

class ClientRegisterSuccess extends ClientRegisterState {
  final RegisterResponseModel registerResponse;

  const ClientRegisterSuccess(this.registerResponse);

  @override
  List<Object?> get props => [registerResponse];
}

class ClientRegisterError extends ClientRegisterState {
  final String message;

  const ClientRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientRegisterPasswordVisibilityChanged extends ClientRegisterState {
  final bool isObscure;

  const ClientRegisterPasswordVisibilityChanged(this.isObscure);

  @override
  List<Object?> get props => [isObscure];
}

class ClientRegisterConfirmPasswordVisibilityChanged extends ClientRegisterState {
  final bool isObscure;

  const ClientRegisterConfirmPasswordVisibilityChanged(this.isObscure);

  @override
  List<Object?> get props => [isObscure];
}

class ClientRegisterCitiesLoaded extends ClientRegisterState {
  final List<UserProfileCity> cities;

  const ClientRegisterCitiesLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class ClientRegisterCitySelected extends ClientRegisterState {
  final UserProfileCity city;

  const ClientRegisterCitySelected(this.city);

  @override
  List<Object?> get props => [city];
}
