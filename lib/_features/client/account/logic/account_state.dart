import 'package:equatable/equatable.dart';
import '../data/models/user_profile_model.dart';

enum AccountStatus { initial, loading, success, error }
enum AccountLogoutStatus { initial, loading, success, error }

class AccountState extends Equatable {
  final AccountStatus status;
  final AccountLogoutStatus logoutStatus;
  final UserProfileModel? profile;
  final String errorMessage;
  final String logoutMessage;

  const AccountState({
    this.status = AccountStatus.initial,
    this.logoutStatus = AccountLogoutStatus.initial,
    this.profile,
    this.errorMessage = '',
    this.logoutMessage = '',
  });

  bool get isLoading => status == AccountStatus.loading;
  bool get isLogoutLoading => logoutStatus == AccountLogoutStatus.loading;

  AccountState copyWith({
    AccountStatus? status,
    AccountLogoutStatus? logoutStatus,
    UserProfileModel? profile,
    String? errorMessage,
    String? logoutMessage,
  }) {
    return AccountState(
      status: status ?? this.status,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      logoutMessage: logoutMessage ?? this.logoutMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    logoutStatus,
    profile,
    errorMessage,
    logoutMessage,
  ];
}

