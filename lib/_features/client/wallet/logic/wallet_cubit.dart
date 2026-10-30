import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/charge_wallet_request_body.dart';
import '../data/repos/wallet_repo.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepo walletRepo;

  WalletCubit(this.walletRepo) : super(const WalletState());

  Future<void> getWallet() async {
    emit(
      state.copyWith(
        walletStatus: WalletStatus.loading,
        chargeStatus: ChargeStatus.initial,
      ),
    );

    final result = await walletRepo.getWallet();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            walletStatus: WalletStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (walletResponse) {
        emit(
          state.copyWith(
            walletStatus: WalletStatus.success,
            walletBalance: walletResponse.walletBalance,
            recentTransactions: walletResponse.transactions,
            errorMessage: '',
          ),
        );
      },
    );
  }

  Future<void> getWalletTransactions() async {
    emit(state.copyWith(transactionsStatus: TransactionsStatus.loading));

    final result = await walletRepo.getWalletTransactions();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            transactionsStatus: TransactionsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (transactions) {
        emit(
          state.copyWith(
            transactionsStatus: TransactionsStatus.success,
            allTransactions: transactions,
            errorMessage: '',
          ),
        );
      },
    );
  }

  Future<void> chargeWallet(num amount) async {
    emit(state.copyWith(chargeStatus: ChargeStatus.loading));

    final transactionId = DateTime.now().millisecondsSinceEpoch.toString();
    final body = ChargeWalletRequestBody(
      amount: amount,
      transactionId: transactionId,
    );

    final result = await walletRepo.chargeWallet(body);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            chargeStatus: ChargeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (message) {
        emit(
          state.copyWith(
            chargeStatus: ChargeStatus.success,
            chargeMessage: message,
            errorMessage: '',
          ),
        );
      },
    );
  }

  void resetChargeStatus() {
    emit(state.copyWith(chargeStatus: ChargeStatus.initial));
  }
}
