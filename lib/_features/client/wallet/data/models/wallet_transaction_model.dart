class WalletTransactionModel {
  final int id;
  final num amount;
  final num beforeCharge;
  final num afterCharge;
  final String date;
  final String statusTrans;
  final String status;
  final String transactionType;
  final String modelType;
  final int modelId;
  final String state;

  const WalletTransactionModel({
    required this.id,
    required this.amount,
    this.beforeCharge = 0,
    this.afterCharge = 0,
    required this.date,
    required this.statusTrans,
    this.status = '',
    this.transactionType = 'charge',
    this.modelType = '',
    this.modelId = 0,
    this.state = '',
  });

  bool get isCharge =>
      transactionType.toLowerCase() == 'charge' ||
      statusTrans.contains('شحن');

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      amount: num.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      beforeCharge: num.tryParse(json['before_charge']?.toString() ?? '0') ?? 0,
      afterCharge: num.tryParse(json['after_charge']?.toString() ?? '0') ?? 0,
      date: json['date']?.toString() ?? '',
      statusTrans: json['status_trans']?.toString() ?? 'شحن المحفظة',
      status: json['status']?.toString() ?? '',
      transactionType: json['transaction_type']?.toString() ?? 'charge',
      modelType: json['model_type']?.toString() ?? '',
      modelId: json['model_id'] is int
          ? json['model_id'] as int
          : int.tryParse(json['model_id']?.toString() ?? '0') ?? 0,
      state: json['state']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'before_charge': beforeCharge,
      'after_charge': afterCharge,
      'date': date,
      'status_trans': statusTrans,
      'status': status,
      'transaction_type': transactionType,
      'model_type': modelType,
      'model_id': modelId,
      'state': state,
    };
  }

  static const dummy = WalletTransactionModel(
    id: 1,
    amount: 255,
    beforeCharge: 0,
    afterCharge: 255,
    date: '27 يونيو, 2021',
    statusTrans: 'شحن المحفظة',
    transactionType: 'charge',
  );
}

