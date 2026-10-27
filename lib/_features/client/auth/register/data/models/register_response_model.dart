class RegisterResponseModel {
  final String? status;
  final String? message;
  final dynamic data;
  final dynamic devMessage;

  RegisterResponseModel({
    this.status,
    this.message,
    this.data,
    this.devMessage,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString() ?? json['msg']?.toString(),
      data: json['data'],
      devMessage: json['dev_message'],
    );
  }


}
