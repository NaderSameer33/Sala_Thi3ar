import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../data/models/contact_info_model.dart';
import '../../data/models/send_contact_request_body.dart';
import '../../logic/support_cubit.dart';
import '../../logic/support_state.dart';
import '../components/contact_info_card.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SupportCubit>()..getContactInfo(),
      child: const _ContactUsViewBody(),
    );
  }
}

class _ContactUsViewBody extends StatefulWidget {
  const _ContactUsViewBody();

  @override
  State<_ContactUsViewBody> createState() => _ContactUsViewBodyState();
}

class _ContactUsViewBodyState extends State<_ContactUsViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final body = SendContactRequestBody(
      fullname: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      title: 'رسالة تواصل',
      content: _contentController.text.trim(),
    );

    context.read<SupportCubit>().sendMessage(body);
  }

  static const _dummyContactInfo = ContactInfoModel(
    location: '13 شارع الملك فهد، جدة، المملكة العربية السعودية',
    phone: '+966 054 87452',
    email: 'info@thimar.com',
  );

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupportCubit>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'تواصل معنا',
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
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<SupportCubit, SupportState>(
        listenWhen: (prev, curr) => prev.sendMessageStatus != curr.sendMessageStatus,
        listener: (context, state) {
          if (state.sendMessageStatus == SendMessageStatus.success && state.successMessage.isNotEmpty) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.fillColored,
              title: Text(state.successMessage),
              autoCloseDuration: const Duration(seconds: 3),
            );
            _nameController.clear();
            _phoneController.clear();
            _contentController.clear();
            cubit.resetSendMessageStatus();
          } else if (state.sendMessageStatus == SendMessageStatus.error && state.errorMessage.isNotEmpty) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              title: Text(state.errorMessage),
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.isContactInfoLoading;
          final contactInfo = isLoading ? _dummyContactInfo : state.contactInfo;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => cubit.getContactInfo(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeletonizer(
                      enabled: isLoading,
                      child: ContactInfoCard(contactInfo: contactInfo),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'أو يمكنك إرسال رسالة',
                      style: AppStyles.font16BoldPrimary,
                    ),
                    SizedBox(height: 14.h),
                    AppInput(
                      controller: _nameController,
                      hintText: 'الإسم',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الإسم';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    AppInput(
                      controller: _phoneController,
                      hintText: 'رقم الموبايل',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال رقم الموبايل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    AppInput(
                      controller: _contentController,
                      hintText: 'الموضوع',
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال نص الموضوع أو الرسالة';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    AppButton(
                      text: 'إرسال',
                      isLoading: state.isSendingMessage,
                      onPressed: () => _submit(context),
                    ),
                    SizedBox(height: 24.h),
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

