import 'package:dio/dio.dart';

class ChargeWalletRequestBody {
  final num amount;
  final String transactionId;

  const ChargeWalletRequestBody({
    required this.amount,
    required this.transactionId,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'amount': amount.toString(),
      'transaction_id': transactionId,
    });
  }
}

