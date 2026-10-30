import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../logic/wallet_cubit.dart';
import '../../logic/wallet_state.dart';

class ChargeWalletView extends StatelessWidget {
  const ChargeWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<WalletCubit>(),
      child: const _ChargeWalletViewBody(),
    );
  }
}

class _ChargeWalletViewBody extends StatefulWidget {
  const _ChargeWalletViewBody();

  @override
  State<_ChargeWalletViewBody> createState() => _ChargeWalletViewBodyState();
}

class _ChargeWalletViewBodyState extends State<_ChargeWalletViewBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  bool _hasPopped = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, WalletCubit cubit) {
    if (_formKey.currentState?.validate() != true) return;

    final amount = num.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        title: const Text('يرجى إدخال مبلغ صحيح أكبر من صفر'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    cubit.chargeWallet(amount);
  }

  void _popScreen() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WalletCubit>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'شحن الان',
          style: AppStyles.font18BoldPrimary,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GestureDetector(
              onTap: _popScreen,
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
      body: BlocConsumer<WalletCubit, WalletState>(
        listenWhen: (previous, current) =>
            previous.chargeStatus != current.chargeStatus,
        listener: (context, state) {
          if (state.chargeStatus == ChargeStatus.success && !_hasPopped) {
            _hasPopped = true;
            toastification.show(
              context: context,
              type: ToastificationType.success,
              title: Text(
                state.chargeMessage.isNotEmpty
                    ? state.chargeMessage
                    : 'تم شحن المحفظة بنجاح',
              ),
              autoCloseDuration: const Duration(seconds: 3),
            );
            cubit.resetChargeStatus();
            _popScreen();
          } else if (state.chargeStatus == ChargeStatus.error) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              title: Text(
                state.errorMessage.isNotEmpty
                    ? state.errorMessage
                    : 'فشل شحن المحفظة',
              ),
              autoCloseDuration: const Duration(seconds: 3),
            );
            cubit.resetChargeStatus();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    20.verticalSpacing,
                    Text(
                      'معلومات المبلغ',
                      style: AppStyles.font14BoldPrimary,
                    ),
                    12.verticalSpacing,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(120),
                          width: 1.2.r,
                        ),
                      ),
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppStyles.font14BoldPrimary,
                        validator: (value) =>
                            AppValidator.validateNotEmpty(value, 'المبلغ'),
                        decoration: InputDecoration(
                          hintText: 'المبلغ الخاص بك',
                          hintStyle: AppStyles.font14RegularGray.copyWith(
                            color: AppColors.textLightGray,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const Spacer(),
                    AppButton(
                      text: 'دفع',
                      isLoading: state.isCharging,
                      onPressed: () => _submit(context, cubit),
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
