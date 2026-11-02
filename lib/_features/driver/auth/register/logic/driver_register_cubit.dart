import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sala_thimar/core/base/safe_cubit.dart';
import 'package:sala_thimar/_features/client/account/data/models/user_profile_model.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/car_model_item.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/driver_register_request_body.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/repos/driver_register_repo.dart';
import 'package:sala_thimar/_features/driver/auth/register/logic/driver_register_state.dart';

class DriverRegisterCubit extends Cubit<DriverRegisterState> with SafeEmitMixin {
  final DriverRegisterRepo repo;

  final GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController identityNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  DriverRegisterCubit(this.repo) : super(const DriverRegisterState());

  void init() {
    loadCities();
    loadCarModels();
    determineLocation();
  }

  Future<void> loadCities() async {
    emit(state.copyWith(isCitiesLoading: true));
    final result = await repo.getCities();
    result.fold(
      (_) => emit(state.copyWith(isCitiesLoading: false)),
      (cities) => emit(state.copyWith(cities: cities, isCitiesLoading: false)),
    );
  }

  Future<void> loadCarModels() async {
    emit(state.copyWith(isModelsLoading: true));
    final result = await repo.getCarModels();
    result.fold(
      (_) => emit(state.copyWith(isModelsLoading: false)),
      (models) => emit(state.copyWith(carModels: models, isModelsLoading: false)),
    );
  }

  void selectCity(UserProfileCity city) {
    cityController.text = city.name;
    emit(state.copyWith(selectedCity: () => city));
  }

  void selectCarModel(CarModelItem model) {
    carModelController.text = model.name;
    emit(state.copyWith(selectedModel: () => model));
  }

  Future<void> determineLocation() async {
    emit(state.copyWith(isLocating: true));
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(isLocating: false));
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(isLocating: false));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(isLocating: false));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        locale: const Locale('ar'),
      );

      String formatted = '';
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = <String>[];
        if (p.locality != null && p.locality!.trim().isNotEmpty) {
          parts.add(p.locality!.trim());
        }
        if (p.subLocality != null && p.subLocality!.trim().isNotEmpty) {
          parts.add(p.subLocality!.trim());
        }
        if (p.street != null && p.street!.trim().isNotEmpty) {
          parts.add(p.street!.trim());
        }
        formatted = parts.join(' - ');
      }

      final displayLocation = formatted.isNotEmpty ? formatted : 'الموقع الحالي';
      locationController.text = displayLocation;

      emit(
        state.copyWith(
          lat: () => position.latitude,
          lng: () => position.longitude,
          locationAddress: displayLocation,
          isLocating: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLocating: false));
    }
  }

  Future<void> pickImageForField(int fieldIndex, ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked == null) return;
      final file = File(picked.path);

      switch (fieldIndex) {
        case 1:
          emit(state.copyWith(carLicenceImage: () => file));
          break;
        case 2:
          emit(state.copyWith(carFormImage: () => file));
          break;
        case 3:
          emit(state.copyWith(carInsuranceImage: () => file));
          break;
        case 4:
          emit(state.copyWith(carFrontImage: () => file));
          break;
        case 5:
          emit(state.copyWith(carBackImage: () => file));
          break;
      }
    } catch (_) {}
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(isConfirmPasswordObscure: !state.isConfirmPasswordObscure));
  }

  void toggleTermsAccepted() {
    emit(state.copyWith(isTermsAccepted: !state.isTermsAccepted));
  }

  bool validateStep1() {
    return formKeyStep1.currentState?.validate() ?? false;
  }

  void nextStep() {
    if (validateStep1()) {
      emit(state.copyWith(currentStep: 2));
    }
  }

  void previousStep() {
    emit(state.copyWith(currentStep: 1));
  }

  Future<void> submitRegister() async {
    if (!formKeyStep2.currentState!.validate()) return;

    if (!state.isTermsAccepted) {
      emit(
        state.copyWith(
          status: DriverRegisterStatus.error,
          errorMessage: 'يرجى الموافقة على الشروط والأحكام للمتابعة',
        ),
      );
      return;
    }

    if (state.carLicenceImage == null ||
        state.carFormImage == null ||
        state.carInsuranceImage == null ||
        state.carFrontImage == null ||
        state.carBackImage == null) {
      emit(
        state.copyWith(
          status: DriverRegisterStatus.error,
          errorMessage: 'يرجى إرفاق جميع صور مستندات وبيانات السيارة المطلوبة',
        ),
      );
      return;
    }

    emit(state.copyWith(status: DriverRegisterStatus.loading));

    final cityId = state.selectedCity?.id.toString() ??
        (state.cities.isNotEmpty ? state.cities.first.id.toString() : '8');

    final modelId = state.selectedModel?.id.toString() ??
        (state.carModels.isNotEmpty ? state.carModels.first.id.toString() : '3');

    final requestBody = DriverRegisterRequestBody(
      fullname: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      cityId: cityId,
      lat: state.lat?.toString() ?? '55.572512',
      lng: state.lng?.toString() ?? '454.51617',
      location: locationController.text.trim().isNotEmpty
          ? locationController.text.trim()
          : (state.locationAddress.isNotEmpty ? state.locationAddress : 'cairo'),
      identityNumber: identityNumberController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      carLicenceImage: state.carLicenceImage,
      carFormImage: state.carFormImage,
      carInsuranceImage: state.carInsuranceImage,
      carFrontImage: state.carFrontImage,
      carBackImage: state.carBackImage,
      carType: carTypeController.text.trim(),
      modelId: modelId,
      iban: ibanController.text.trim(),
      bankName: bankNameController.text.trim(),
    );

    final result = await repo.register(requestBody);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DriverRegisterStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: DriverRegisterStatus.success,
          response: response,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    locationController.dispose();
    identityNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    carTypeController.dispose();
    carModelController.dispose();
    ibanController.dispose();
    bankNameController.dispose();
    return super.close();
  }
}
