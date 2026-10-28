import 'package:dio/dio.dart';

class ResetPasswordRequestBody {
  final String phone;
  final String code;
  final String password;

  const ResetPasswordRequestBody({
    required this.phone,
    required this.code,
    required this.password,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'phone': phone,
      'code': code,
      'password': password,
    });
  }
}
