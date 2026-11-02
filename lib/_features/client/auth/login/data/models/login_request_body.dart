import 'dart:io';
import 'package:dio/dio.dart';

class LoginRequestBody {
  final String phone;
  final String password;
  final String? deviceToken;
  final String type;
  final String userType;
  final String? lat;
  final String? lng;

  LoginRequestBody({
    required this.phone,
    required this.password,
    this.deviceToken,
    String? type,
    this.userType = 'client',
    this.lat,
    this.lng,
  }) : type = type ?? (Platform.isIOS ? 'ios' : 'android');

  FormData toFormData() {
    final map = <String, dynamic>{
      'phone': phone,
      'password': password,
      'device_token': deviceToken ?? 'test',
      'type': type,
      'user_type': userType,
    };
    if (lat != null && lat!.isNotEmpty) {
      map['lat'] = lat;
    }
    if (lng != null && lng!.isNotEmpty) {
      map['lng'] = lng;
    }
    return FormData.fromMap(map);
  }
}
