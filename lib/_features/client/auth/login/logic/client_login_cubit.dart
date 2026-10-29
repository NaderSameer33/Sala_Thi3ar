import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/login_request_body.dart';
import '../data/repos/client_login_repo.dart';
import 'client_login_state.dart';

class ClientLoginCubit extends Cubit<ClientLoginState> {
  final ClientLoginRepo clientLoginRepo;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordObscure = true;

  ClientLoginCubit(this.clientLoginRepo) : super(ClientLoginInitial());

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    emit(ClientLoginPasswordVisibilityChanged(isPasswordObscure));
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    emit(ClientLoginLoading());

    final requestBody = LoginRequestBody(
      phone: phoneController.text.trim(),
      password: passwordController.text,
      userType: 'client',
    );

    final result = await clientLoginRepo.login(requestBody);

    result.fold(
      (failure) => emit(ClientLoginError(failure.message)),
      (response) => emit(ClientLoginSuccess(response)),
    );
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
