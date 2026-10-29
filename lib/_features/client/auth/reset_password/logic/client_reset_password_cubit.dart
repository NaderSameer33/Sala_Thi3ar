import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/reset_password_request_body.dart';
import '../data/repos/client_reset_password_repo.dart';
import 'client_reset_password_state.dart';

class ClientResetPasswordCubit extends Cubit<ClientResetPasswordState> {
  final ClientResetPasswordRepo resetPasswordRepo;
  final String phone;
  final String code;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  ClientResetPasswordCubit({
    required this.resetPasswordRepo,
    required this.phone,
    required this.code,
  }) : super(ClientResetPasswordInitial());

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    emit(
      ClientResetPasswordVisibilityChanged(
        isPasswordObscure: isPasswordObscure,
        isConfirmPasswordObscure: isConfirmPasswordObscure,
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscure = !isConfirmPasswordObscure;
    emit(
      ClientResetPasswordVisibilityChanged(
        isPasswordObscure: isPasswordObscure,
        isConfirmPasswordObscure: isConfirmPasswordObscure,
      ),
    );
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    emit(ClientResetPasswordLoading());

    final requestBody = ResetPasswordRequestBody(
      phone: phone,
      code: code,
      password: passwordController.text,
    );

    final result = await resetPasswordRepo.resetPassword(requestBody);

    result.fold(
      (failure) => emit(ClientResetPasswordError(failure.message)),
      (message) => emit(ClientResetPasswordSuccess(message)),
    );
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
