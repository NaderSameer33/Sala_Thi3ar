import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/auth/forget_password/data/repos/client_forget_password_repo.dart';
import 'package:sala_thimar/_features/client/auth/forget_password/logic/client_forget_password_state.dart';

class ClientForgetPasswordCubit extends Cubit<ClientForgetPasswordState> {
  final ClientForgetPasswordRepo forgetPasswordRepo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  ClientForgetPasswordCubit(this.forgetPasswordRepo)
      : super(ClientForgetPasswordInitial());

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;

    emit(ClientForgetPasswordLoading());

    final phone = phoneController.text.trim();
    final result = await forgetPasswordRepo.sendOtp(phone);

    result.fold(
      (failure) => emit(ClientForgetPasswordError(failure.message)),
      (message) => emit(ClientForgetPasswordSuccess(message)),
    );
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    return super.close();
  }
}
