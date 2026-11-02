import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/_features/client/auth/register/presentation/components/already_have_account_row.dart';
import 'package:sala_thimar/_features/driver/auth/register/logic/driver_register_cubit.dart';
import 'package:sala_thimar/_features/driver/auth/register/logic/driver_register_state.dart';
import 'package:sala_thimar/_features/driver/auth/register/presentation/components/driver_car_step.dart';
import 'package:sala_thimar/_features/driver/auth/register/presentation/components/driver_personal_step.dart';
import 'package:sala_thimar/_features/driver/auth/register/presentation/components/driver_stepper_header.dart';

class DriverRegisterView extends StatelessWidget {
  const DriverRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DriverRegisterCubit>()..init(),
      child: const _DriverRegisterViewBody(),
    );
  }
}

class _DriverRegisterViewBody extends StatelessWidget {
  const _DriverRegisterViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<DriverRegisterCubit, DriverRegisterState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == DriverRegisterStatus.success) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text('نجاح'),
                description: Text(
                  state.response?.message ?? 'تم تسجيل حساب المندوب بنجاح',
                ),
                autoCloseDuration: const Duration(seconds: 4),
              );
              context.go(AppRouterName.driverLogin);
            } else if (state.status == DriverRegisterStatus.error &&
                state.errorMessage.isNotEmpty) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: const Text('خطأ'),
                description: Text(state.errorMessage),
                autoCloseDuration: const Duration(seconds: 4),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          16.verticalSpacing,
                          DriverStepperHeader(
                            currentStep: state.currentStep,
                          ),
                          20.verticalSpacing,
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state.currentStep == 1
                                ? const DriverPersonalStep(
                                    key: ValueKey('step_1'),
                                  )
                                : const DriverCarStep(
                                    key: ValueKey('step_2'),
                                  ),
                          ),
                          24.verticalSpacing,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h, top: 8.h),
                    child: AlreadyHaveAccountRow(
                      onTap: () {
                        context.go(AppRouterName.driverLogin);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
