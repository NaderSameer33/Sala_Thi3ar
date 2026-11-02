import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sala_thimar/_features/client/auth/login/presentation/components/phone_input_field.dart';
import 'package:sala_thimar/_features/driver/auth/login/logic/driver_login_cubit.dart';
import 'package:sala_thimar/_features/driver/auth/login/logic/driver_login_state.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';
import 'package:sala_thimar/core/services/get_it_service.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/theme/app_styles.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';
import 'package:sala_thimar/core/widgets/app_input.dart';
import 'package:toastification/toastification.dart';

class DriverLoginView extends StatelessWidget {
  const DriverLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DriverLoginCubit>(),
      child: const _DriverLoginViewBody(),
    );
  }
}

class _DriverLoginViewBody extends StatelessWidget {
  const _DriverLoginViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<DriverLoginCubit, DriverLoginState>(
          listener: (context, state) {
            if (state is DriverLoginSuccess) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text('تم تسجيل الدخول بنجاح كمندوب'),
                autoCloseDuration: const Duration(seconds: 3),
              );
              context.go(AppRouterName.home);
            } else if (state is DriverLoginError) {
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
            final cubit = context.read<DriverLoginCubit>();

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
                            30.verticalSpacing,
                            Center(
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                width: 125.w,
                                height: 125.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                            20.verticalSpacing,
                            Text(
                              'مرحباً بك مرة أخرى',
                              style: AppStyles.font16BoldPrimary,
                              textAlign: TextAlign.start,
                            ),
                            6.verticalSpacing,
                            Text(
                              'يمكنك تسجيل الدخول كمندوب لمتابعة الطلبات',
                              style: AppStyles.font14RegularGray,
                              textAlign: TextAlign.start,
                            ),
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
                              isLoading: state is DriverLoginLoading,
                              onPressed: cubit.login,
                            ),
                            30.verticalSpacing,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h, top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لديك حساب مندوب ؟ ',
                            style: AppStyles.font14RegularGray.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push(AppRouterName.driverRegister);
                            },
                            child: Text(
                              'انضم إلينا الآن',
                              style: AppStyles.font14BoldPrimary,
                            ),
                          ),
                        ],
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
