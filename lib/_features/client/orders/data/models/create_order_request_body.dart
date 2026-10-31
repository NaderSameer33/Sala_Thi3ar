import 'package:dio/dio.dart';

class CreateOrderRequestBody {
  final int addressId;
  final String date;
  final String time;
  final String note;
  final String payType;
  final String? transactionId;
  final String? couponCode;
  final int? cityId;
  final int? countryId;

  const CreateOrderRequestBody({
    required this.addressId,
    required this.date,
    required this.time,
    this.note = '',
    required this.payType,
    this.transactionId,
    this.couponCode,
    this.cityId,
    this.countryId = 1,
  });

  FormData toFormData() {
    final map = <String, dynamic>{
      'address_id': addressId.toString(),
      'date': date,
      'time': time,
      'note': note,
      'pay_type': payType,
    };
    if (transactionId != null && transactionId!.isNotEmpty) {
      map['transaction_id'] = transactionId;
    }
    if (couponCode != null && couponCode!.isNotEmpty) {
      map['coupon_code'] = couponCode;
    }
    if (cityId != null) {
      map['city_id'] = cityId.toString();
    }
    if (countryId != null) {
      map['country_id'] = countryId.toString();
    }
    return FormData.fromMap(map);
  }
}

