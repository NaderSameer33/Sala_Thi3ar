import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/account_repo.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepo accountRepo;

  AccountCubit(this.accountRepo) : super(const AccountState());

  Future<void> getProfile() async {
    emit(state.copyWith(status: AccountStatus.loading));

    final result = await accountRepo.getProfile();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AccountStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (profile) {
        emit(
          state.copyWith(
            status: AccountStatus.success,
            profile: profile,
            errorMessage: '',
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(logoutStatus: AccountLogoutStatus.loading));

    final result = await accountRepo.logout();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            logoutStatus: AccountLogoutStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (message) {
        emit(
          state.copyWith(
            logoutStatus: AccountLogoutStatus.success,
            logoutMessage: message,
          ),
        );
      },
    );
  }

  void resetLogoutStatus() {
    emit(state.copyWith(logoutStatus: AccountLogoutStatus.initial));
  }
}

