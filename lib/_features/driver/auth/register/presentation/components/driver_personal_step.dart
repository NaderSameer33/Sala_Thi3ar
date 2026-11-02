import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';
import 'package:sala_thimar/core/widgets/app_input.dart';
import 'package:sala_thimar/_features/client/account/data/models/user_profile_model.dart';
import 'package:sala_thimar/_features/client/account/presentation/components/profile_city_sheet.dart';
import 'package:sala_thimar/_features/client/auth/login/presentation/components/phone_input_field.dart';
import 'package:sala_thimar/_features/driver/auth/register/logic/driver_register_cubit.dart';
import 'package:sala_thimar/_features/driver/auth/register/logic/driver_register_state.dart';

class DriverPersonalStep extends StatelessWidget {
  const DriverPersonalStep({super.key});

  void _openCitySheet(
    BuildContext context,
    DriverRegisterCubit cubit,
    List<UserProfileCity> cities,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return ProfileCitySheet(
          cities: cities,
          selectedCityId: cubit.state.selectedCity?.id,
          onCitySelected: (city) => cubit.selectCity(city),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverRegisterCubit>();

    return BlocBuilder<DriverRegisterCubit, DriverRegisterState>(
      buildWhen: (prev, curr) =>
          prev.isPasswordObscure != curr.isPasswordObscure ||
          prev.isConfirmPasswordObscure != curr.isConfirmPasswordObscure ||
          prev.isLocating != curr.isLocating ||
          prev.cities != curr.cities ||
          prev.selectedCity != curr.selectedCity,
      builder: (context, state) {
        return Form(
          key: cubit.formKeyStep1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppInput(
                controller: cubit.fullNameController,
                hintText: 'اسم المندوب',
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
                readOnly: true,
                onTap: () => _openCitySheet(context, cubit, state.cities),
                prefixIcon: const Icon(
                  Icons.flag_outlined,
                  color: AppColors.textLightGray,
                ),
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textLightGray,
                ),
                validator: (value) =>
                    AppValidator.validateNotEmpty(value, 'المدينة'),
              ),
              14.verticalSpacing,
              AppInput(
                controller: cubit.locationController,
                hintText: 'تحديد الموقع على الخريطة',
                readOnly: true,
                onTap: cubit.determineLocation,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.textLightGray,
                ),
                suffixIcon: state.isLocating
                    ? Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(
                        Icons.my_location_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                validator: (value) =>
                    AppValidator.validateNotEmpty(value, 'الموقع الجغرافي'),
              ),
              14.verticalSpacing,
              AppInput(
                controller: cubit.identityNumberController,
                hintText: 'رقم الهوية',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  color: AppColors.textLightGray,
                ),
                validator: (value) =>
                    AppValidator.validateNotEmpty(value, 'رقم الهوية'),
              ),
              14.verticalSpacing,
              AppInput(
                controller: cubit.emailController,
                hintText: 'البريد الإلكتروني',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.textLightGray,
                ),
                validator: AppValidator.validateEmail,
              ),
              14.verticalSpacing,
              AppInput(
                controller: cubit.passwordController,
                hintText: 'كلمة المرور',
                isObscureText: state.isPasswordObscure,
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
                    state.isPasswordObscure
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
                hintText: 'تأكيد كلمة المرور',
                isObscureText: state.isConfirmPasswordObscure,
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
                    state.isConfirmPasswordObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textLightGray,
                  ),
                  onPressed: cubit.toggleConfirmPasswordVisibility,
                ),
                validator: (value) => AppValidator.validateConfirmPassword(
                  value,
                  cubit.passwordController.text,
                ),
              ),
              24.verticalSpacing,
              AppButton(
                text: 'التالي',
                onPressed: cubit.nextStep,
              ),
            ],
          ),
        );
      },
    );
  }
}
