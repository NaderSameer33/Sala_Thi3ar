import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/core/base/safe_cubit.dart';
import '../../../core/caching/shared_pref_service.dart';
import '../../../core/constants/constant.dart';
import '../../../core/routers/app_router_name.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> with SafeEmitMixin {
  OnboardingCubit() : super(const OnboardingState());

  Future<String> completeOnboarding() async {
    emit(state.copyWith(isSubmitting: true));

    await SharedPrefService.setBool(AppConstant.isFirst, false);

    emit(state.copyWith(isSubmitting: false));

    return AppRouterName.clientLogin;
  }
}
