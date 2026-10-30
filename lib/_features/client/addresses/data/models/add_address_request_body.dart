import 'package:dio/dio.dart';

class AddAddressRequestBody {
  final String type;
  final String phone;
  final String description;
  final String location;
  final double lat;
  final double lng;
  final int isDefault;

  const AddAddressRequestBody({
    required this.type,
    required this.phone,
    required this.description,
    required this.location,
    required this.lat,
    required this.lng,
    this.isDefault = 1,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'type': type,
      'phone': phone,
      'description': description,
      'location': location,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'is_default': isDefault.toString(),
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'phone': phone,
      'description': description,
      'location': location,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'is_default': isDefault.toString(),
    };
  }
}

