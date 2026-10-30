import 'package:equatable/equatable.dart';
import '../data/models/user_profile_model.dart';

enum AccountStatus { initial, loading, success, error }
enum AccountLogoutStatus { initial, loading, success, error }
enum AccountEditProfileStatus { initial, loading, success, error }

class AccountState extends Equatable {
  final AccountStatus status;
  final AccountLogoutStatus logoutStatus;
  final AccountEditProfileStatus editProfileStatus;
  final UserProfileModel? profile;
  final List<UserProfileCity> cities;
  final String errorMessage;
  final String logoutMessage;
  final String editProfileMessage;

  const AccountState({
    this.status = AccountStatus.initial,
    this.logoutStatus = AccountLogoutStatus.initial,
    this.editProfileStatus = AccountEditProfileStatus.initial,
    this.profile,
    this.cities = const [],
    this.errorMessage = '',
    this.logoutMessage = '',
    this.editProfileMessage = '',
  });

  bool get isLoading => status == AccountStatus.loading;
  bool get isLogoutLoading => logoutStatus == AccountLogoutStatus.loading;
  bool get isEditProfileLoading => editProfileStatus == AccountEditProfileStatus.loading;

  AccountState copyWith({
    AccountStatus? status,
    AccountLogoutStatus? logoutStatus,
    AccountEditProfileStatus? editProfileStatus,
    UserProfileModel? profile,
    List<UserProfileCity>? cities,
    String? errorMessage,
    String? logoutMessage,
    String? editProfileMessage,
  }) {
    return AccountState(
      status: status ?? this.status,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      editProfileStatus: editProfileStatus ?? this.editProfileStatus,
      profile: profile ?? this.profile,
      cities: cities ?? this.cities,
      errorMessage: errorMessage ?? this.errorMessage,
      logoutMessage: logoutMessage ?? this.logoutMessage,
      editProfileMessage: editProfileMessage ?? this.editProfileMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    logoutStatus,
    editProfileStatus,
    profile,
    cities,
    errorMessage,
    logoutMessage,
    editProfileMessage,
  ];
}
