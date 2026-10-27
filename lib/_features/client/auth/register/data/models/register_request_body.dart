import 'package:dio/dio.dart';

class RegisterRequestBody {
  final String fullname;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String gender;
  final String lat;
  final String lng;

  RegisterRequestBody({
    required this.fullname,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.gender = 'female',
    this.lat = '250.0515',
    this.lng = '290.45',
  });

  FormData toFormData() {
    return FormData.fromMap({
      'fullname': fullname,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'gender': gender,
      'lat': lat,
      'lng': lng,
    });
  }

  
}
