import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../data/models/verify_otp_request_body.dart';
import '../data/repos/client_verify_otp_repo.dart';
import 'client_verify_otp_state.dart';

class ClientVerifyOtpCubit extends Cubit<ClientVerifyOtpState> {
  final ClientVerifyOtpRepo verifyOtpRepo;
  final String phone;
  final bool isForgetPassword;

  final PinInputController pinController = PinInputController();
  final CountDownController countDownController = CountDownController();
  bool isTimerCompleted = false;

  ClientVerifyOtpCubit({
    required this.verifyOtpRepo,
    required this.phone,
    this.isForgetPassword = false,
  }) : super(ClientVerifyOtpInitial());

  void onTimerComplete() {
    isTimerCompleted = true;
    emit(ClientOtpTimerComplete());
  }

  Future<void> verifyOtp() async {
    final code = pinController.text.trim();
    if (code.length < 4) {
      emit(const ClientVerifyOtpError('يرجى إدخال الكود المكون من 4 أرقام كاملاً'));
      return;
    }

    emit(ClientVerifyOtpLoading());

    if (isForgetPassword) {
      final result = await verifyOtpRepo.checkCode(phone: phone, code: code);
      result.fold(
        (failure) => emit(ClientVerifyOtpError(failure.message)),
        (_) => emit(ClientCheckCodeSuccess(code)),
      );
      return;
    }

    final requestBody = VerifyOtpRequestBody(
      code: code,
      phone: phone,
    );

    final result = await verifyOtpRepo.verifyOtp(requestBody);

    result.fold(
      (failure) => emit(ClientVerifyOtpError(failure.message)),
      (response) => emit(ClientVerifyOtpSuccess(response)),
    );
  }

  Future<void> resendOtp() async {
    if (!isTimerCompleted) return;

    emit(ClientResendOtpLoading());

    final result = await verifyOtpRepo.resendOtp(phone);

    result.fold(
      (failure) => emit(ClientResendOtpError(failure.message)),
      (message) {
        isTimerCompleted = false;
        countDownController.restart(duration: 65);
        emit(ClientResendOtpSuccess(message));
      },
    );
  }

  @override
  Future<void> close() {
    pinController.dispose();
    return super.close();
  }
}
