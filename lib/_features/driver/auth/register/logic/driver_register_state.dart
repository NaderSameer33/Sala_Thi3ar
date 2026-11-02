import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:sala_thimar/_features/client/account/data/models/user_profile_model.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/car_model_item.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/driver_register_response_model.dart';

enum DriverRegisterStatus { initial, loading, success, error }

class DriverRegisterState extends Equatable {
  final int currentStep;
  final DriverRegisterStatus status;
  final String errorMessage;
  final DriverRegisterResponseModel? response;

  final List<UserProfileCity> cities;
  final UserProfileCity? selectedCity;
  final bool isCitiesLoading;

  final List<CarModelItem> carModels;
  final CarModelItem? selectedModel;
  final bool isModelsLoading;

  final double? lat;
  final double? lng;
  final String locationAddress;
  final bool isLocating;

  final File? carLicenceImage;
  final File? carFormImage;
  final File? carInsuranceImage;
  final File? carFrontImage;
  final File? carBackImage;

  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;
  final bool isTermsAccepted;

  const DriverRegisterState({
    this.currentStep = 1,
    this.status = DriverRegisterStatus.initial,
    this.errorMessage = '',
    this.response,
    this.cities = const [],
    this.selectedCity,
    this.isCitiesLoading = false,
    this.carModels = const [],
    this.selectedModel,
    this.isModelsLoading = false,
    this.lat,
    this.lng,
    this.locationAddress = '',
    this.isLocating = false,
    this.carLicenceImage,
    this.carFormImage,
    this.carInsuranceImage,
    this.carFrontImage,
    this.carBackImage,
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
    this.isTermsAccepted = false,
  });

  bool get isLoading => status == DriverRegisterStatus.loading;

  DriverRegisterState copyWith({
    int? currentStep,
    DriverRegisterStatus? status,
    String? errorMessage,
    DriverRegisterResponseModel? response,
    List<UserProfileCity>? cities,
    UserProfileCity? Function()? selectedCity,
    bool? isCitiesLoading,
    List<CarModelItem>? carModels,
    CarModelItem? Function()? selectedModel,
    bool? isModelsLoading,
    double? Function()? lat,
    double? Function()? lng,
    String? locationAddress,
    bool? isLocating,
    File? Function()? carLicenceImage,
    File? Function()? carFormImage,
    File? Function()? carInsuranceImage,
    File? Function()? carFrontImage,
    File? Function()? carBackImage,
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
    bool? isTermsAccepted,
  }) {
    return DriverRegisterState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      response: response ?? this.response,
      cities: cities ?? this.cities,
      selectedCity: selectedCity != null ? selectedCity() : this.selectedCity,
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      carModels: carModels ?? this.carModels,
      selectedModel: selectedModel != null ? selectedModel() : this.selectedModel,
      isModelsLoading: isModelsLoading ?? this.isModelsLoading,
      lat: lat != null ? lat() : this.lat,
      lng: lng != null ? lng() : this.lng,
      locationAddress: locationAddress ?? this.locationAddress,
      isLocating: isLocating ?? this.isLocating,
      carLicenceImage:
          carLicenceImage != null ? carLicenceImage() : this.carLicenceImage,
      carFormImage: carFormImage != null ? carFormImage() : this.carFormImage,
      carInsuranceImage:
          carInsuranceImage != null ? carInsuranceImage() : this.carInsuranceImage,
      carFrontImage: carFrontImage != null ? carFrontImage() : this.carFrontImage,
      carBackImage: carBackImage != null ? carBackImage() : this.carBackImage,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ?? this.isConfirmPasswordObscure,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        status,
        errorMessage,
        response,
        cities,
        selectedCity,
        isCitiesLoading,
        carModels,
        selectedModel,
        isModelsLoading,
        lat,
        lng,
        locationAddress,
        isLocating,
        carLicenceImage,
        carFormImage,
        carInsuranceImage,
        carFrontImage,
        carBackImage,
        isPasswordObscure,
        isConfirmPasswordObscure,
        isTermsAccepted,
      ];
}
