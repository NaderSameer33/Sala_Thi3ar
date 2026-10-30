import 'wallet_transaction_model.dart';

class WalletResponseModel {
  final num walletBalance;
  final List<WalletTransactionModel> transactions;
  final String status;
  final String message;

  const WalletResponseModel({
    required this.walletBalance,
    required this.transactions,
    this.status = '',
    this.message = '',
  });

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    final rawBalance = json['wallet'];
    final balance = num.tryParse(rawBalance?.toString() ?? '0') ?? 0;

    final rawList = json['data'];
    List<WalletTransactionModel> transactions = [];
    if (rawList is List) {
      transactions = rawList
          .map((item) => WalletTransactionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return WalletResponseModel(
      walletBalance: balance,
      transactions: transactions,
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  static const dummy = WalletResponseModel(
    walletBalance: 255,
    transactions: [
      WalletTransactionModel.dummy,
      WalletTransactionModel.dummy,
    ],
  );
}

