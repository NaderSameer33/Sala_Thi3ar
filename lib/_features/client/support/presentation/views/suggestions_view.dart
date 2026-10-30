import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../data/models/send_contact_request_body.dart';
import '../../logic/support_cubit.dart';
import '../../logic/support_state.dart';

class SuggestionsView extends StatelessWidget {
  const SuggestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SupportCubit>(),
      child: const _SuggestionsViewBody(),
    );
  }
}

class _SuggestionsViewBody extends StatefulWidget {
  const _SuggestionsViewBody();

  @override
  State<_SuggestionsViewBody> createState() => _SuggestionsViewBodyState();
}

class _SuggestionsViewBodyState extends State<_SuggestionsViewBody> {
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
      title: 'اقتراح أو شكوى',
      content: _contentController.text.trim(),
    );

    context.read<SupportCubit>().sendMessage(body);
  }

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
          'الأقتراحات والشكاوي',
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
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                        return 'يرجى إدخال نص الاقتراح أو الشكوى';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    text: 'إرسال',
                    isLoading: state.isSendingMessage,
                    onPressed: () => _submit(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

