import 'dart:io';
import 'package:dio/dio.dart';

class VerifyOtpRequestBody {
  final String code;
  final String phone;
  final String? deviceToken;
  final String type;

  VerifyOtpRequestBody({
    required this.code,
    required this.phone,
    this.deviceToken,
    String? type,
  }) : type = type ?? (Platform.isIOS ? 'ios' : 'android');

  FormData toFormData() {
    return FormData.fromMap({
      'code': code,
      'phone': phone,
      'device_token': deviceToken ?? 'test',
      'type': type,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'phone': phone,
      'device_token': deviceToken ?? 'test',
      'type': type,
    };
  }
}
