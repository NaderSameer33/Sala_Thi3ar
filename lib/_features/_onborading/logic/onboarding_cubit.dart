import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';
import '../../../core/caching/shared_pref_service.dart';
import '../../../core/constants/constant.dart';
import '../../../core/routers/app_router_name.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void selectRole(UserRole role) {
    emit(state.copyWith(selectedRole: role));
  }

  Future<String> completeOnboarding() async {
    emit(state.copyWith(isSubmitting: true));

    final roleString = state.selectedRole == UserRole.client
        ? 'client'
        : 'driver';
    await SharedPrefService.setString(AppConstant.userRole, roleString);
    await SharedPrefService.setBool(AppConstant.isFirst, false);

    emit(state.copyWith(isSubmitting: false));

    return state.selectedRole == UserRole.client
        ? AppRouterName.clientLogin
        : AppRouterName.driverLogin;
  }
}
