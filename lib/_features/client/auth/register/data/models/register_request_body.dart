import 'package:dio/dio.dart';

class RegisterRequestBody {
  final String fullname;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String? cityId;
  final String? countryId;
  final String gender;
  final String lat;
  final String lng;

  RegisterRequestBody({
    required this.fullname,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.cityId,
    this.countryId,
    this.gender = 'female',
    this.lat = '250.0515',
    this.lng = '290.45',
  });

  FormData toFormData() {
    final map = <String, dynamic>{
      'fullname': fullname,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'gender': gender,
      'lat': lat,
      'lng': lng,
    };
    if (cityId != null && cityId!.isNotEmpty) {
      map['city_id'] = cityId;
      map['country_id'] = countryId ?? '1';
    }
    return FormData.fromMap(map);
  }
}
