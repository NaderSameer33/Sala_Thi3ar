import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/edit_profile_request_body.dart';
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

  Future<void> getCities() async {
    final result = await accountRepo.getCities();

    result.fold(
      (failure) => null,
      (cities) {
        emit(state.copyWith(cities: cities));
      },
    );
  }

  Future<void> editProfile(EditProfileRequestBody body) async {
    emit(state.copyWith(editProfileStatus: AccountEditProfileStatus.loading));

    final result = await accountRepo.editProfile(body);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            editProfileStatus: AccountEditProfileStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedProfile) {
        emit(
          state.copyWith(
            editProfileStatus: AccountEditProfileStatus.success,
            profile: updatedProfile,
            editProfileMessage: 'تم تعديل البيانات بنجاح',
            errorMessage: '',
          ),
        );
      },
    );
  }

  void resetEditProfileStatus() {
    emit(state.copyWith(editProfileStatus: AccountEditProfileStatus.initial));
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
