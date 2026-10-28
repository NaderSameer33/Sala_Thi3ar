import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sala_thimar/_features/client/auth/login/logic/client_login_cubit.dart';
import 'package:sala_thimar/_features/client/auth/login/logic/client_login_state.dart';
import 'package:sala_thimar/_features/client/auth/login/presentation/components/dont_have_account_row.dart';
import 'package:sala_thimar/_features/client/auth/login/presentation/components/login_header.dart';
import 'package:sala_thimar/_features/client/auth/login/presentation/components/phone_input_field.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';
import 'package:sala_thimar/core/widgets/app_input.dart';
import 'package:toastification/toastification.dart';

class ClientLoginView extends StatelessWidget {
  const ClientLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClientLoginCubit>(),
      child: const _ClientLoginViewBody(),
    );
  }
}

class _ClientLoginViewBody extends StatelessWidget {
  const _ClientLoginViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ClientLoginCubit, ClientLoginState>(
          listener: (context, state) {
            if (state is ClientLoginSuccess) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text('تم تسجيل الدحول بنجاح '),

                autoCloseDuration: const Duration(seconds: 3),
              );
            } else if (state is ClientLoginError) {
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
            final cubit = context.read<ClientLoginCubit>();

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
                            const LoginHeader(),
                            24.verticalSpacing,
                            PhoneInputField(controller: cubit.phoneController),
                            16.verticalSpacing,
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
                            12.verticalSpacing,
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: GestureDetector(
                                onTap: () {
                                  context.push(AppRouterName.clientForgetPassword);
                                },
                                child: Text(
                                  'نسيت كلمة المرور؟',
                                  style: AppStyles.font14RegularGray,
                                ),
                              ),
                            ),
                            24.verticalSpacing,
                            AppButton(
                              text: 'تسجيل الدخول',
                              isLoading: state is ClientLoginLoading,
                              onPressed: cubit.login,
                            ),
                            30.verticalSpacing,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h, top: 8.h),
                      child: DontHaveAccountRow(
                        onTap: () {
                          context.go(AppRouterName.clientRegister);
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
