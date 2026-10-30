import 'package:equatable/equatable.dart';
import '../data/models/wallet_transaction_model.dart';

enum WalletStatus { initial, loading, success, error }
enum TransactionsStatus { initial, loading, success, error }
enum ChargeStatus { initial, loading, success, error }

class WalletState extends Equatable {
  final WalletStatus walletStatus;
  final TransactionsStatus transactionsStatus;
  final ChargeStatus chargeStatus;
  final num walletBalance;
  final List<WalletTransactionModel> recentTransactions;
  final List<WalletTransactionModel> allTransactions;
  final String errorMessage;
  final String chargeMessage;

  const WalletState({
    this.walletStatus = WalletStatus.initial,
    this.transactionsStatus = TransactionsStatus.initial,
    this.chargeStatus = ChargeStatus.initial,
    this.walletBalance = 0,
    this.recentTransactions = const [],
    this.allTransactions = const [],
    this.errorMessage = '',
    this.chargeMessage = '',
  });

  bool get isWalletLoading => walletStatus == WalletStatus.loading;
  bool get isTransactionsLoading => transactionsStatus == TransactionsStatus.loading;
  bool get isCharging => chargeStatus == ChargeStatus.loading;

  WalletState copyWith({
    WalletStatus? walletStatus,
    TransactionsStatus? transactionsStatus,
    ChargeStatus? chargeStatus,
    num? walletBalance,
    List<WalletTransactionModel>? recentTransactions,
    List<WalletTransactionModel>? allTransactions,
    String? errorMessage,
    String? chargeMessage,
  }) {
    return WalletState(
      walletStatus: walletStatus ?? this.walletStatus,
      transactionsStatus: transactionsStatus ?? this.transactionsStatus,
      chargeStatus: chargeStatus ?? this.chargeStatus,
      walletBalance: walletBalance ?? this.walletBalance,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      allTransactions: allTransactions ?? this.allTransactions,
      errorMessage: errorMessage ?? this.errorMessage,
      chargeMessage: chargeMessage ?? this.chargeMessage,
    );
  }

  @override
  List<Object?> get props => [
    walletStatus,
    transactionsStatus,
    chargeStatus,
    walletBalance,
    recentTransactions,
    allTransactions,
    errorMessage,
    chargeMessage,
  ];
}

