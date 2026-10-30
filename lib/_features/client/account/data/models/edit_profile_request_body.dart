import 'package:dio/dio.dart';

class EditProfileRequestBody {
  final String fullname;
  final String phone;
  final int? cityId;
  final String? password;
  final String? passwordConfirmation;
  final String? imagePath;

  const EditProfileRequestBody({
    required this.fullname,
    required this.phone,
    this.cityId,
    this.password,
    this.passwordConfirmation,
    this.imagePath,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'fullname': fullname,
      'phone': phone,
    };

    if (cityId != null) {
      map['city_id'] = cityId.toString();
    }

    if (password != null && password!.isNotEmpty) {
      map['password'] = password;
      map['password_confirmation'] = passwordConfirmation ?? password;
    }

    if (imagePath != null && imagePath!.isNotEmpty) {
      map['image'] = await MultipartFile.fromFile(
        imagePath!,
        filename: imagePath!.split(RegExp(r'[\\/]')).last,
      );
    }

    return FormData.fromMap(map);
  }
}

