import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/core/base/safe_cubit.dart';
import '../../../core/caching/shared_pref_service.dart';
import '../../../core/constants/constant.dart';
import '../../../core/routers/app_router_name.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> with SafeEmitMixin {
  final PageController pageController = PageController();

  OnboardingCubit() : super(const OnboardingState());

  void onPageChanged(int index) {
    emit(state.copyWith(currentPage: index));
  }

  void nextPage() {
    if (state.currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void skipToLast() {
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<String> completeOnboarding() async {
    emit(state.copyWith(isSubmitting: true));

    await SharedPrefService.setBool(AppConstant.isFirst, false);

    emit(state.copyWith(isSubmitting: false));

    return AppRouterName.clientLogin;
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
