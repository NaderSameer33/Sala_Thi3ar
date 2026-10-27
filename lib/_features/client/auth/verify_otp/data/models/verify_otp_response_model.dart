import 'package:sala_thimar/_features/client/auth/login/data/models/login_response_model.dart';

class VerifyOtpResponseModel {
  final String? status;
  final String? message;
  final UserData? data;

  VerifyOtpResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString() ?? json['msg']?.toString(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? UserData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
