class DriverRegisterResponseModel {
  final String? status;
  final String? message;
  final dynamic data;
  final dynamic devMessage;

  DriverRegisterResponseModel({
    this.status,
    this.message,
    this.data,
    this.devMessage,
  });

  factory DriverRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return DriverRegisterResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString() ?? json['msg']?.toString(),
      data: json['data'],
      devMessage: json['dev_message'],
    );
  }
}
