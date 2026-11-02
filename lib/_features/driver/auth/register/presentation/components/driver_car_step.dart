import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sala_thimar/core/extension/spacing_extension.dart';
import 'package:sala_thimar/core/routers/app_router_name.dart';
import 'package:sala_thimar/core/theme/app_colors.dart';
import 'package:sala_thimar/core/widgets/app_button.dart';
import 'package:sala_thimar/core/widgets/app_input.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/car_model_item.dart';
import 'package:sala_thimar/_features/driver/auth/register/logic/driver_register_cubit.dart';
import 'package:sala_thimar/_features/driver/auth/register/logic/driver_register_state.dart';
import 'package:sala_thimar/_features/driver/auth/register/presentation/components/driver_car_model_sheet.dart';
import 'package:sala_thimar/_features/driver/auth/register/presentation/components/driver_document_upload_card.dart';

class DriverCarStep extends StatelessWidget {
  const DriverCarStep({super.key});

  void _openModelSheet(
    BuildContext context,
    DriverRegisterCubit cubit,
    List<CarModelItem> models,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return DriverCarModelSheet(
          models: models,
          selectedModelId: cubit.state.selectedModel?.id,
          onModelSelected: (model) => cubit.selectCarModel(model),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverRegisterCubit>();

    return BlocBuilder<DriverRegisterCubit, DriverRegisterState>(
      buildWhen: (prev, curr) =>
          prev.carLicenceImage != curr.carLicenceImage ||
          prev.carFormImage != curr.carFormImage ||
          prev.carInsuranceImage != curr.carInsuranceImage ||
          prev.carFrontImage != curr.carFrontImage ||
          prev.carBackImage != curr.carBackImage ||
          prev.isTermsAccepted != curr.isTermsAccepted ||
          prev.status != curr.status ||
          prev.carModels != curr.carModels ||
          prev.selectedModel != curr.selectedModel,
      builder: (context, state) {
        return Form(
          key: cubit.formKeyStep2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DriverDocumentUploadCard(
                    label: 'صورة رخصة القيادة',
                    imageFile: state.carLicenceImage,
                    onSelectSource: (source) =>
                        cubit.pickImageForField(1, source),
                  ),
                  DriverDocumentUploadCard(
                    label: 'استمارة السيارة',
                    imageFile: state.carFormImage,
                    onSelectSource: (source) =>
                        cubit.pickImageForField(2, source),
                  ),
                  DriverDocumentUploadCard(
                    label: 'تأمين السيارة',
                    imageFile: state.carInsuranceImage,
                    onSelectSource: (source) =>
                        cubit.pickImageForField(3, source),
                  ),
                ],
              ),
              12.verticalSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DriverDocumentUploadCard(
                    label: 'السيارة من الأمام',
                    imageFile: state.carFrontImage,
                    onSelectSource: (source) =>
                        cubit.pickImageForField(4, source),
                  ),
                  DriverDocumentUploadCard(
                    label: 'السيارة من الخلف',
                    imageFile: state.carBackImage,
                    onSelectSource: (source) =>
                        cubit.pickImageForField(5, source),
                  ),
                ],
              ),
              20.verticalSpacing,
              AppInput(
                controller: cubit.carTypeController,
                hintText: 'نوع السيارة',
                prefixIcon: const Icon(
                  Icons.directions_car_outlined,
                  color: AppColors.textLightGray,
                ),
                validator: (value) =>
                    AppValidator.validateNotEmpty(value, 'نوع السيارة'),
              ),
              14.verticalSpacing,
              AppInput(
                controller: cubit.carModelController,
                hintText: 'موديل السيارة',
                readOnly: true,
                onTap: () => _openModelSheet(context, cubit, state.carModels),
                prefixIcon: const Icon(
                  Icons.directions_car_outlined,
                  color: AppColors.textLightGray,
                ),
                suffixIcon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textLightGray,
                ),
                validator: (value) =>
                    AppValidator.validateNotEmpty(value, 'موديل السيارة'),
              ),
              14.verticalSpacing,
              AppInput(
                controller: cubit.ibanController,
                hintText: 'رقم الإيبان',
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(
                  Icons.credit_card_outlined,
                  color: AppColors.textLightGray,
                ),
                validator: (value) =>
                    AppValidator.validateNotEmpty(value, 'رقم الإيبان'),
              ),
              14.verticalSpacing,
              AppInput(
                controller: cubit.bankNameController,
                hintText: 'إسم البنك',
                prefixIcon: const Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.textLightGray,
                ),
                validator: (value) =>
                    AppValidator.validateNotEmpty(value, 'إسم البنك'),
              ),
              16.verticalSpacing,
              InkWell(
                onTap: cubit.toggleTermsAccepted,
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Container(
                        width: 22.r,
                        height: 22.r,
                        decoration: BoxDecoration(
                          color: state.isTermsAccepted
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: state.isTermsAccepted
                                ? AppColors.primary
                                : AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: state.isTermsAccepted
                            ? const Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            : null,
                      ),
                      10.horizontalSpacing,
                      GestureDetector(
                        onTap: () => context.push(AppRouterName.privacyPolicy),
                        child: Text(
                          'الموافقة على الشروط والأحكام',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textLightGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              24.verticalSpacing,
              AppButton(
                text: 'تسجيل',
                isLoading: state.isLoading,
                onPressed: cubit.submitRegister,
              ),
              12.verticalSpacing,
              Center(
                child: TextButton.icon(
                  onPressed: cubit.previousStep,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'الرجوع للبيانات الشخصية',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
