import 'package:dio/dio.dart';

class SendContactRequestBody {
  final String fullname;
  final String phone;
  final String title;
  final String content;

  const SendContactRequestBody({
    required this.fullname,
    required this.phone,
    required this.title,
    required this.content,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'fullname': fullname,
      'phone': phone,
      'title': title,
      'content': content,
    });
  }
}

