import 'dart:io';
import 'package:dio/dio.dart';

class LoginRequestBody {
  final String phone;
  final String password;
  final String? deviceToken;
  final String type;
  final String userType;

  LoginRequestBody({
    required this.phone,
    required this.password,
    this.deviceToken,
    String? type,
    this.userType = 'client',
  }) : type = type ?? (Platform.isIOS ? 'ios' : 'android');

  FormData toFormData() {
    return FormData.fromMap({
      'phone': phone,
      'password': password,
      'device_token': deviceToken ?? 'test',
      'type': type,
      'user_type': userType,
    });
  }
}
