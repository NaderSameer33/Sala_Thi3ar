import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../logic/client_forget_password_cubit.dart';
import '../../logic/client_forget_password_state.dart';
import '../../../login/presentation/components/phone_input_field.dart';
import '../../../register/presentation/components/already_have_account_row.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/routers/app_router_name.dart';
import '../../../../../../core/services/get_it_service.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';
import '../../../../../../core/widgets/app_button.dart';
import 'package:toastification/toastification.dart';

class ClientForgetPasswordView extends StatelessWidget {
  const ClientForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClientForgetPasswordCubit>(),
      child: const _ClientForgetPasswordViewBody(),
    );
  }
}

class _ClientForgetPasswordViewBody extends StatelessWidget {
  const _ClientForgetPasswordViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<ClientForgetPasswordCubit, ClientForgetPasswordState>(
          listener: (context, state) {
            if (state is ClientForgetPasswordSuccess) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text('تم بنجاح'),
                description: Text(state.message),
                autoCloseDuration: const Duration(seconds: 3),
              );
              final phone = context.read<ClientForgetPasswordCubit>().phoneController.text.trim();
              context.push(
                AppRouterName.clientVerifyOtp,
                extra: {
                  'phone': phone,
                  'isForgetPassword': true,
                },
              );
            } else if (state is ClientForgetPasswordError) {
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
            final cubit = context.read<ClientForgetPasswordCubit>();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            20.verticalSpacing,
                            Center(
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                height: 125.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                            24.verticalSpacing,
                            Text(
                              'نسيت كلمة المرور',
                              style: AppStyles.font18BoldPrimary.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            6.verticalSpacing,
                            Text(
                              'أدخل رقم الجوال المرتبط بحسابك',
                              style: AppStyles.font14RegularGray,
                            ),
                            24.verticalSpacing,
                            PhoneInputField(controller: cubit.phoneController),
                            24.verticalSpacing,
                            AppButton(
                              text: 'تأكيد رقم الجوال',
                              isLoading: state is ClientForgetPasswordLoading,
                              onPressed: cubit.sendOtp,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
