import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/account/data/models/user_profile_model.dart';
import 'package:sala_thimar/core/base/safe_cubit.dart';
import '../data/models/register_request_body.dart';
import '../data/repos/client_register_repo.dart';
import 'client_register_state.dart';

class ClientRegisterCubit extends Cubit<ClientRegisterState> with SafeEmitMixin {
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

  List<UserProfileCity> cities = [];
  UserProfileCity? selectedCity;

  ClientRegisterCubit(this.clientRegisterRepo) : super(ClientRegisterInitial()) {
    loadCities();
  }

  Future<void> loadCities() async {
    final result = await clientRegisterRepo.getCities();
    result.fold(
      (_) {},
      (loadedCities) {
        cities = loadedCities;
        emit(ClientRegisterCitiesLoaded(loadedCities));
      },
    );
  }

  void selectCity(UserProfileCity city) {
    selectedCity = city;
    cityController.text = city.name;
    emit(ClientRegisterCitySelected(city));
  }

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
      cityId: selectedCity?.id.toString(),
      countryId: '1',
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
