import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../login/presentation/components/phone_input_field.dart';
import '../../logic/client_register_cubit.dart';
import '../../logic/client_register_state.dart';
import '../components/already_have_account_row.dart';
import '../components/register_header.dart';
import '../../../../../../core/extension/spacing_extension.dart';
import '../../../../../../core/routers/app_router_name.dart';
import '../../../../../../core/services/get_it_service.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_input.dart';
import 'package:toastification/toastification.dart';

class ClientRegisterView extends StatelessWidget {
  const ClientRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClientRegisterCubit>(),
      child: const _ClientRegisterViewBody(),
    );
  }
}

class _ClientRegisterViewBody extends StatelessWidget {
  const _ClientRegisterViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: BlocConsumer<ClientRegisterCubit, ClientRegisterState>(
          listener: (context, state) {
            if (state is ClientRegisterSuccess) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: const Text('نجاح'),
                description: Text(
                  state.registerResponse.message ?? 'تم إنشاء الحساب بنجاح',
                ),
                autoCloseDuration: const Duration(seconds: 4),
              );
              context.go(
                AppRouterName.clientVerifyOtp,
                extra: context
                    .read<ClientRegisterCubit>()
                    .phoneController
                    .text
                    .trim(),
              );
            } else if (state is ClientRegisterError) {
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
            final cubit = context.read<ClientRegisterCubit>();

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
                            const RegisterHeader(),
                            20.verticalSpacing,
                            AppInput(
                              controller: cubit.fullNameController,
                              hintText: 'اسم المستخدم',
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.textLightGray,
                              ),
                              validator: AppValidator.validateName,
                            ),
                            14.verticalSpacing,
                            PhoneInputField(
                              controller: cubit.phoneController,
                            ),
                            14.verticalSpacing,
                            AppInput(
                              controller: cubit.cityController,
                              hintText: 'المدينة',
                              prefixIcon: const Icon(
                                Icons.flag_outlined,
                                color: AppColors.textLightGray,
                              ),
                              validator: (value) =>
                                  AppValidator.validateNotEmpty(value, 'المدينة'),
                            ),
                            14.verticalSpacing,
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
                            14.verticalSpacing,
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
                                onPressed:
                                    cubit.toggleConfirmPasswordVisibility,
                              ),
                              validator: (value) =>
                                  AppValidator.validateConfirmPassword(
                                value,
                                cubit.passwordController.text,
                              ),
                            ),
                            24.verticalSpacing,
                            AppButton(
                              text: 'تسجيل',
                              isLoading: state is ClientRegisterLoading,
                              onPressed: cubit.register,
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
