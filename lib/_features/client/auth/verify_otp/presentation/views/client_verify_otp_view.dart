import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sala_thimar/_features/client/auth/register/presentation/components/already_have_account_row.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/logic/client_verify_otp_cubit.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/logic/client_verify_otp_state.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/presentation/components/otp_header.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/presentation/components/otp_timer_and_resend.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/presentation/components/pin_code_fields.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';
import 'package:toastification/toastification.dart';

class ClientVerifyOtpView extends StatelessWidget {
  final String phone;
  final String title;

  const ClientVerifyOtpView({
    super.key,
    required this.phone,
    this.title = 'نسيت كلمة المرور',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClientVerifyOtpCubit>(param1: phone),
      child: _ClientVerifyOtpViewBody(title: title),
    );
  }
}

class _ClientVerifyOtpViewBody extends StatelessWidget {
  final String title;

  const _ClientVerifyOtpViewBody({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<ClientVerifyOtpCubit, ClientVerifyOtpState>(
          listener: (context, state) {
            if (state is ClientVerifyOtpSuccess) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text('نجاح'),
                description: Text(
                  state.response.message ?? 'تم تأكيد الكود بنجاح',
                ),
                autoCloseDuration: const Duration(seconds: 4),
              );
              context.go(AppRouterName.clientLogin);
            } else if (state is ClientVerifyOtpError) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: const Text('خطأ'),
                description: Text(state.message),
                autoCloseDuration: const Duration(seconds: 4),
              );
            } else if (state is ClientResendOtpSuccess) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text('تم بنجاح'),
                description: Text(state.message),
                autoCloseDuration: const Duration(seconds: 3),
              );
            } else if (state is ClientResendOtpError) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: const Text('خطأ'),
                description: Text(state.message),
                autoCloseDuration: const Duration(seconds: 4),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ClientVerifyOtpCubit>();

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
                          20.verticalSpacing,
                          OtpHeader(
                            title: title,
                            phone: cubit.phone,
                          ),
                          28.verticalSpacing,
                          PinCodeFields(
                            controller: cubit.pinController,
                            onCompleted: (_) => cubit.verifyOtp(),
                          ),
                          24.verticalSpacing,
                          AppButton(
                            text: 'تأكيد الكود',
                            isLoading: state is ClientVerifyOtpLoading,
                            onPressed: cubit.verifyOtp,
                          ),
                          24.verticalSpacing,
                          OtpTimerAndResend(
                            controller: cubit.countDownController,
                            isTimerCompleted: cubit.isTimerCompleted,
                            isLoading: state is ClientResendOtpLoading,
                            onResend: cubit.resendOtp,
                            onTimerCompleted: cubit.onTimerComplete,
                          ),
                          20.verticalSpacing,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h, top: 8.h),
                    child: AlreadyHaveAccountRow(
                      onTap: () {
                        context.go(AppRouterName.clientLogin);
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
