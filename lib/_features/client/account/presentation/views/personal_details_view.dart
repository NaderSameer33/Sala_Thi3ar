import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../data/models/edit_profile_request_body.dart';
import '../../data/models/user_profile_model.dart';
import '../../logic/account_cubit.dart';
import '../../logic/account_state.dart';
import '../components/profile_avatar_picker.dart';
import '../components/profile_city_sheet.dart';
import '../components/profile_labeled_input.dart';
import '../components/profile_password_sheet.dart';
import '../components/profile_phone_input.dart';

class PersonalDetailsView extends StatelessWidget {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AccountCubit>()..getCities(),
      child: const _PersonalDetailsViewBody(),
    );
  }
}

class _PersonalDetailsViewBody extends StatefulWidget {
  const _PersonalDetailsViewBody();

  @override
  State<_PersonalDetailsViewBody> createState() => _PersonalDetailsViewBodyState();
}

class _PersonalDetailsViewBodyState extends State<_PersonalDetailsViewBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _passwordDisplayController;

  File? _selectedImage;
  String? _newPassword;
  int? _selectedCityId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _cityController = TextEditingController();
    _passwordDisplayController = TextEditingController(text: '••••••••');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _passwordDisplayController.dispose();
    super.dispose();
  }

  void _populateInitialData(AccountState state) {
    if (_isInitialized) return;
    final profile = state.profile;
    if (profile != null) {
      _nameController.text = profile.fullname;
      String phone = profile.phone;
      if (phone.startsWith('+966')) {
        phone = phone.substring(4);
      } else if (phone.startsWith('966')) {
        phone = phone.substring(3);
      }
      _phoneController.text = phone;

      if (profile.city != null && profile.city!.id != 0) {
        _selectedCityId = profile.city!.id;
        _cityController.text = profile.city!.name;
      } else {
        _selectedCityId = 5;
        _cityController.text = 'الرياض';
      }

      _isInitialized = true;
    }
  }

  void _openCitySheet(BuildContext context, List<UserProfileCity> cities) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.white,
      builder: (bottomSheetContext) {
        return ProfileCitySheet(
          cities: cities,
          selectedCityId: _selectedCityId,
          onCitySelected: (city) {
            setState(() {
              _selectedCityId = city.id;
              _cityController.text = city.name;
            });
          },
        );
      },
    );
  }

  void _openPasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: AppColors.white,
      builder: (context) {
        return ProfilePasswordSheet(
          onPasswordSaved: (password) {
            setState(() {
              _newPassword = password;
              _passwordDisplayController.text = '••••••••';
            });
            toastification.show(
              context: this.context,
              type: ToastificationType.info,
              title: const Text('تم تحديد كلمة المرور الجديدة'),
              autoCloseDuration: const Duration(seconds: 2),
            );
          },
        );
      },
    );
  }

  void _submit(BuildContext context, AccountCubit cubit, AccountState state) {
    if (_formKey.currentState?.validate() != true) return;

    String phone = _phoneController.text.trim();
    if (!phone.startsWith('966') && !phone.startsWith('+966')) {
      phone = '966$phone';
    } else if (phone.startsWith('+966')) {
      phone = phone.substring(1);
    }

    final cityId = _selectedCityId ?? (state.profile?.city?.id != null && state.profile!.city!.id != 0 ? state.profile!.city!.id : 5);

    final body = EditProfileRequestBody(
      fullname: _nameController.text.trim(),
      phone: phone,
      cityId: cityId,
      password: _newPassword,
      passwordConfirmation: _newPassword,
      imagePath: _selectedImage?.path,
    );

    cubit.editProfile(body);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AccountCubit>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'البيانات الشخصية',
          style: AppStyles.font18BoldPrimary,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state.editProfileStatus == AccountEditProfileStatus.success) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: Text(state.editProfileMessage),
              autoCloseDuration: const Duration(seconds: 3),
            );
            cubit.resetEditProfileStatus();
            cubit.getProfile();
            Navigator.of(context).pop(true);
          } else if (state.editProfileStatus == AccountEditProfileStatus.error) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text(state.errorMessage),
              autoCloseDuration: const Duration(seconds: 3),
            );
            cubit.resetEditProfileStatus();
          }
        },
        builder: (context, state) {
          _populateInitialData(state);

          final profile = state.profile;
          final displayName = _nameController.text.isNotEmpty
              ? _nameController.text
              : (profile?.fullname ?? 'محمد علي');
          final rawPhone = _phoneController.text.isNotEmpty
              ? '+966${_phoneController.text}'
              : (profile?.phone.isNotEmpty == true
                  ? (profile!.phone.startsWith('+') ? profile.phone : '+${profile.phone}')
                  : '+96654787856');

          return SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            16.verticalSpacing,
                            ProfileAvatarPicker(
                              imageUrl: profile?.image ?? '',
                              localImage: _selectedImage,
                              onImagePicked: (file) {
                                setState(() {
                                  _selectedImage = file;
                                });
                              },
                            ),
                            12.verticalSpacing,
                            Text(
                              displayName,
                              style: AppStyles.font16BoldPrimary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            4.verticalSpacing,
                            Text(
                              rawPhone,
                              style: AppStyles.font14RegularGray,
                              textDirection: TextDirection.ltr,
                            ),
                            24.verticalSpacing,
                            ProfileLabeledInput(
                              label: 'اسم المستخدم',
                              controller: _nameController,
                              validator: AppValidator.validateName,
                              trailingIcon: Image.asset(
                                'assets/images/User.png',
                                width: 22.r,
                                height: 22.r,
                                fit: BoxFit.contain,
                              ),
                            ),
                            14.verticalSpacing,
                            ProfilePhoneInput(
                              controller: _phoneController,
                            ),
                            14.verticalSpacing,
                            ProfileLabeledInput(
                              label: 'المدينة',
                              controller: _cityController,
                              readOnly: true,
                              onTap: () => _openCitySheet(context, state.cities),
                              validator: (value) =>
                                  AppValidator.validateNotEmpty(value, 'المدينة'),
                              trailingIcon: const Icon(
                                Icons.outlined_flag_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                            14.verticalSpacing,
                            ProfileLabeledInput(
                              label: 'كلمة المرور',
                              controller: _passwordDisplayController,
                              readOnly: true,
                              onTap: _openPasswordSheet,
                              trailingIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                              leadingIcon: Container(
                                width: 26.r,
                                height: 26.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1.2.r,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 11.r,
                                    color: AppColors.textLightGray,
                                  ),
                                ),
                              ),
                            ),
                            24.verticalSpacing,
                          ],
                        ),
                      ),
                    ),
                    AppButton(
                      text: 'تعديل البيانات',
                      isLoading: state.isEditProfileLoading,
                      onPressed: () => _submit(context, cubit, state),
                    ),
                    16.verticalSpacing,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
