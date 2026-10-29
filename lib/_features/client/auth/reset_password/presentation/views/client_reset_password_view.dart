import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../register/presentation/components/already_have_account_row.dart';
import '../../logic/client_reset_password_cubit.dart';
import '../../logic/client_reset_password_state.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/routers/app_router_name.dart';
import '../../../../../../core/services/get_it_service.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_styles.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_input.dart';
import 'package:toastification/toastification.dart';

class ClientResetPasswordView extends StatelessWidget {
  final String phone;
  final String code;

  const ClientResetPasswordView({
    super.key,
    required this.phone,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClientResetPasswordCubit>(
        param1: phone,
        param2: code,
      ),
      child: const _ClientResetPasswordViewBody(),
    );
  }
}

class _ClientResetPasswordViewBody extends StatelessWidget {
  const _ClientResetPasswordViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<ClientResetPasswordCubit, ClientResetPasswordState>(
          listener: (context, state) {
            if (state is ClientResetPasswordSuccess) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text('تم بنجاح'),
                description: Text(state.message),
                autoCloseDuration: const Duration(seconds: 4),
              );
              context.go(AppRouterName.clientLogin);
            } else if (state is ClientResetPasswordError) {
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
            final cubit = context.read<ClientResetPasswordCubit>();

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
                              'أدخل كلمة المرور الجديدة',
                              style: AppStyles.font14RegularGray,
                            ),
                            24.verticalSpacing,
                            AppInput(
                              controller: cubit.passwordController,
                              hintText: 'كلمة المرور',
                              isObscureText: cubit.isPasswordObscure,
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: SvgPicture.asset(
                                  'assets/icons/unlock.svg',
                                  height: 20.h,
                                  width: 20.w,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  cubit.isPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textLightGray,
                                ),
                                onPressed: cubit.togglePasswordVisibility,
                              ),
                              validator: AppValidator.validatePassword,
                            ),
                            16.verticalSpacing,
                            AppInput(
                              controller: cubit.confirmPasswordController,
                              hintText: 'كلمة المرور',
                              isObscureText: cubit.isConfirmPasswordObscure,
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: SvgPicture.asset(
                                  'assets/icons/unlock.svg',
                                  height: 20.h,
                                  width: 20.w,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  cubit.isConfirmPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textLightGray,
                                ),
                                onPressed: cubit.toggleConfirmPasswordVisibility,
                              ),
                              validator: (value) =>
                                  AppValidator.validateConfirmPassword(
                                value,
                                cubit.passwordController.text,
                              ),
                            ),
                            24.verticalSpacing,
                            AppButton(
                              text: 'تغيير كلمة المرور',
                              isLoading: state is ClientResetPasswordLoading,
                              onPressed: cubit.resetPassword,
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
