import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/app_button.dart';
import '../../../../../core/utils/app_input.dart';
import '../../../../../core/utils/app_validator.dart';

class ClientLoginScreen extends StatefulWidget {
  const ClientLoginScreen({super.key});

  @override
  State<ClientLoginScreen> createState() => _ClientLoginScreenState();
}

class _ClientLoginScreenState extends State<ClientLoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل دخول العميل'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'مرحباً بك مجدداً',
                  style: AppStyles.font20BoldBlack,
                ),
                SizedBox(height: 6.h),
                Text(
                  'سجل دخولك لتصفح وشراء المنتجات الطازجة',
                  style: AppStyles.font14RegularSubtitle,
                ),
                SizedBox(height: 28.h),
                AppInput(
                  controller: _phoneController,
                  labelText: 'رقم الجوال',
                  hintText: '05xxxxxxxx',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_android_outlined, color: AppColors.primary),
                  validator: AppValidator.validatePhone,
                ),
                SizedBox(height: 16.h),
                AppInput(
                  controller: _passwordController,
                  labelText: 'كلمة المرور',
                  hintText: '••••••••',
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                  validator: AppValidator.validatePassword,
                ),
                SizedBox(height: 32.h),
                AppButton(
                  title: 'تسجيل الدخول',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
