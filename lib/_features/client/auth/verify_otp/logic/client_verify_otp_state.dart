import 'package:equatable/equatable.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/data/models/verify_otp_response_model.dart';

abstract class ClientVerifyOtpState extends Equatable {
  const ClientVerifyOtpState();

  @override
  List<Object?> get props => [];
}

class ClientVerifyOtpInitial extends ClientVerifyOtpState {}

class ClientVerifyOtpLoading extends ClientVerifyOtpState {}

class ClientVerifyOtpSuccess extends ClientVerifyOtpState {
  final VerifyOtpResponseModel response;

  const ClientVerifyOtpSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ClientCheckCodeSuccess extends ClientVerifyOtpState {
  final String code;

  const ClientCheckCodeSuccess(this.code);

  @override
  List<Object?> get props => [code];
}

class ClientVerifyOtpError extends ClientVerifyOtpState {
  final String message;

  const ClientVerifyOtpError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientResendOtpLoading extends ClientVerifyOtpState {}

class ClientResendOtpSuccess extends ClientVerifyOtpState {
  final String message;

  const ClientResendOtpSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientResendOtpError extends ClientVerifyOtpState {
  final String message;

  const ClientResendOtpError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientOtpTimerComplete extends ClientVerifyOtpState {}
