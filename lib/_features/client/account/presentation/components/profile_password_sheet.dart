import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';

class ProfilePasswordSheet extends StatefulWidget {
  final ValueChanged<String> onPasswordSaved;

  const ProfilePasswordSheet({
    super.key,
    required this.onPasswordSaved,
  });

  @override
  State<ProfilePasswordSheet> createState() => _ProfilePasswordSheetState();
}

class _ProfilePasswordSheetState extends State<ProfilePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() == true) {
      widget.onPasswordSaved(_passwordController.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                16.verticalSpacing,
                Text(
                  'تغيير كلمة المرور',
                  style: AppStyles.font16BoldDark,
                  textAlign: TextAlign.center,
                ),
                18.verticalSpacing,
                AppInput(
                  controller: _passwordController,
                  hintText: 'كلمة المرور الجديدة',
                  isObscureText: _isObscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textLightGray,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                  validator: AppValidator.validatePassword,
                ),
                14.verticalSpacing,
                AppInput(
                  controller: _confirmController,
                  hintText: 'تأكيد كلمة المرور الجديدة',
                  isObscureText: _isObscure,
                  validator: (value) => AppValidator.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                20.verticalSpacing,
                AppButton(
                  text: 'حفظ كلمة المرور',
                  onPressed: _save,
                ),
                12.verticalSpacing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
