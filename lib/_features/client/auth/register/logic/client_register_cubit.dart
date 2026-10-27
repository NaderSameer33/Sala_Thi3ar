import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/auth/register/data/models/register_request_body.dart';
import 'package:sala_thimar/_features/client/auth/register/data/repos/client_register_repo.dart';
import 'package:sala_thimar/_features/client/auth/register/logic/client_register_state.dart';

class ClientRegisterCubit extends Cubit<ClientRegisterState> {
  final ClientRegisterRepo clientRegisterRepo;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  ClientRegisterCubit(this.clientRegisterRepo) : super(ClientRegisterInitial());

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    emit(ClientRegisterPasswordVisibilityChanged(isPasswordObscure));
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscure = !isConfirmPasswordObscure;
    emit(ClientRegisterConfirmPasswordVisibilityChanged(isConfirmPasswordObscure));
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    emit(ClientRegisterLoading());

    final requestBody = RegisterRequestBody(
      fullname: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      gender: 'female',
      lat: '250.0515',
      lng: '290.45',
    );

    final result = await clientRegisterRepo.register(requestBody);

    result.fold(
      (failure) => emit(ClientRegisterError(failure.message)),
      (response) => emit(ClientRegisterSuccess(response)),
    );
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
