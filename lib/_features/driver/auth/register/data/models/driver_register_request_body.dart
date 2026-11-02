import 'dart:io';
import 'package:dio/dio.dart';

class DriverRegisterRequestBody {
  final String fullname;
  final String phone;
  final String cityId;
  final String lat;
  final String lng;
  final String location;
  final String identityNumber;
  final String email;
  final String password;
  final String passwordConfirmation;
  final File? carLicenceImage;
  final File? carFormImage;
  final File? carInsuranceImage;
  final File? carFrontImage;
  final File? carBackImage;
  final String carType;
  final String modelId;
  final String iban;
  final String bankName;

  DriverRegisterRequestBody({
    required this.fullname,
    required this.phone,
    required this.cityId,
    required this.lat,
    required this.lng,
    required this.location,
    required this.identityNumber,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.carLicenceImage,
    this.carFormImage,
    this.carInsuranceImage,
    this.carFrontImage,
    this.carBackImage,
    required this.carType,
    required this.modelId,
    required this.iban,
    required this.bankName,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'fullname': fullname,
      'phone': phone,
      'city_id': cityId,
      'lat': lat,
      'lng': lng,
      'location': location,
      'identity_number': identityNumber,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'car_type': carType,
      'model_id': modelId,
      'iban': iban,
      'bank_name': bankName,
    };

    if (carLicenceImage != null) {
      final fileName = carLicenceImage!.path.split(RegExp(r'[\\/]')).last;
      map['car_licence_image'] = await MultipartFile.fromFile(
        carLicenceImage!.path,
        filename: fileName,
      );
    }
    if (carFormImage != null) {
      final fileName = carFormImage!.path.split(RegExp(r'[\\/]')).last;
      map['car_form_image'] = await MultipartFile.fromFile(
        carFormImage!.path,
        filename: fileName,
      );
    }
    if (carInsuranceImage != null) {
      final fileName = carInsuranceImage!.path.split(RegExp(r'[\\/]')).last;
      map['car_insurance_image'] = await MultipartFile.fromFile(
        carInsuranceImage!.path,
        filename: fileName,
      );
    }
    if (carFrontImage != null) {
      final fileName = carFrontImage!.path.split(RegExp(r'[\\/]')).last;
      map['car_front_image'] = await MultipartFile.fromFile(
        carFrontImage!.path,
        filename: fileName,
      );
    }
    if (carBackImage != null) {
      final fileName = carBackImage!.path.split(RegExp(r'[\\/]')).last;
      map['car_back_image'] = await MultipartFile.fromFile(
        carBackImage!.path,
        filename: fileName,
      );
    }

    return FormData.fromMap(map);
  }
}
