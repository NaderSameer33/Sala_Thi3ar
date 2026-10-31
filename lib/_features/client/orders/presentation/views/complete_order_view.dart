import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../../account/logic/account_cubit.dart';
import '../../../account/logic/account_state.dart';
import '../../../addresses/data/models/address_model.dart';
import '../../../addresses/logic/addresses_cubit.dart';
import '../../../cart/logic/cart_cubit.dart';
import '../../../cart/logic/cart_state.dart';
import '../../data/models/create_order_request_body.dart';
import '../../logic/orders_cubit.dart';
import '../../logic/orders_state.dart';
import '../components/address_selection_bottom_sheet.dart';
import '../components/order_done_bottom_sheet.dart';
import '../components/order_summary_card.dart';
import '../components/payment_method_selector.dart';

class CompleteOrderView extends StatelessWidget {
  const CompleteOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<OrdersCubit>()),
        BlocProvider.value(value: getIt<AccountCubit>()..getProfile()),
        BlocProvider.value(value: getIt<AddressesCubit>()..getAddresses()),
      ],
      child: const _CompleteOrderViewBody(),
    );
  }
}

class _CompleteOrderViewBody extends StatefulWidget {
  const _CompleteOrderViewBody();

  @override
  State<_CompleteOrderViewBody> createState() => _CompleteOrderViewBodyState();
}

class _CompleteOrderViewBodyState extends State<_CompleteOrderViewBody> {
  final _noteController = TextEditingController();
  AddressModel? _selectedAddress;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPayType = 'cash';

  @override
  void initState() {
    super.initState();
    final addresses = getIt<AddressesCubit>().state.addresses;
    if (addresses.isNotEmpty) {
      _selectedAddress = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.first,
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submit() {
    if (_selectedAddress == null) {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.fillColored,
        title: const Text('يرجى اختيار عنوان التوصيل'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (_selectedDate == null) {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.fillColored,
        title: const Text('يرجى تحديد تاريخ التوصيل'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (_selectedTime == null) {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.fillColored,
        title: const Text('يرجى تحديد وقت التوصيل'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    final dateStr =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

    final profileCityId = context.read<AccountCubit>().state.profile?.city?.id ?? 5;
    final body = CreateOrderRequestBody(
      addressId: _selectedAddress!.id,
      date: dateStr,
      time: timeStr,
      note: _noteController.text.trim(),
      payType: _selectedPayType,
      transactionId: _selectedPayType != 'cash' ? '1111' : null,
      cityId: profileCityId,
      countryId: 1,
    );

    context.read<OrdersCubit>().createOrder(body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'إتمام الطلب',
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
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listenWhen: (prev, curr) => prev.createOrderStatus != curr.createOrderStatus,
        listener: (context, state) {
          if (state.createOrderStatus == CreateOrderStatus.success) {
            context.read<CartCubit>().getCart();
            context.read<OrdersCubit>().resetCreateOrderStatus();
            OrderDoneBottomSheet.show(context);
          } else if (state.createOrderStatus == CreateOrderStatus.error &&
              state.errorMessage.isNotEmpty) {
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfoSection(),
                SizedBox(height: 20.h),
                _buildAddressSection(),
                SizedBox(height: 20.h),
                _buildDeliveryTimeSection(),
                SizedBox(height: 20.h),
                _buildNotesSection(),
                SizedBox(height: 20.h),
                _buildPaymentMethodSection(),
                SizedBox(height: 20.h),
                _buildOrderSummarySection(),
                SizedBox(height: 24.h),
                AppButton(
                  text: 'إنهاء الطلب',
                  isLoading: state.isCreatingOrder,
                  onPressed: _submit,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        final profile = state.profile;
        final name = (profile != null && profile.fullname.isNotEmpty)
            ? profile.fullname
            : 'محمد';
        final phone = (profile != null && profile.phone.isNotEmpty)
            ? profile.phone
            : (_selectedAddress?.phone ?? '05xxxxxxxx');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإسم : $name',
              style: AppStyles.font16BoldDark,
            ),
            SizedBox(height: 4.h),
            Text(
              'الجوال : $phone',
              style: AppStyles.font14RegularDark.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'اختر عنوان التوصيل',
              style: AppStyles.font16BoldDark,
            ),
            GestureDetector(
              onTap: () async {
                await context.push(AppRouterName.addAddress);
                final cubit = getIt<AddressesCubit>();
                await cubit.getAddresses();
                final updated = cubit.state.addresses;
                if (updated.isNotEmpty) {
                  setState(() {
                    _selectedAddress = updated.last;
                  });
                }
              },
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add_rounded,
                  color: AppColors.primary,
                  size: 20.r,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () async {
            final address = await AddressSelectionBottomSheet.show(context);
            if (address != null) {
              setState(() => _selectedAddress = address);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.primary,
                width: 1.r,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedAddress != null
                        ? '${_selectedAddress!.typeDisplayName} : ${_selectedAddress!.location.isNotEmpty ? _selectedAddress!.location : _selectedAddress!.description}'
                        : 'اختر عنوان التوصيل',
                    style: AppStyles.font14RegularDark,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                  size: 22.r,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryTimeSection() {
    final dateText = _selectedDate != null
        ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
        : 'اختر اليوم والتاريخ';
    final timeText = _selectedTime != null
        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
        : 'اختر الوقت';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحديد وقت التوصيل',
          style: AppStyles.font16BoldDark,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primary,
                        size: 18.r,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          dateText,
                          textAlign: TextAlign.center,
                          style: AppStyles.font12RegularGray.copyWith(
                            color: _selectedDate != null
                                ? AppColors.textDark
                                : AppColors.textGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: _pickTime,
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: AppColors.primary,
                        size: 18.r,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          timeText,
                          textAlign: TextAlign.center,
                          style: AppStyles.font12RegularGray.copyWith(
                            color: _selectedTime != null
                                ? AppColors.textDark
                                : AppColors.textGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملاحظات وتعليمات',
          style: AppStyles.font16BoldDark,
        ),
        SizedBox(height: 10.h),
        AppInput(
          controller: _noteController,
          hintText: 'ملاحظات وتعليمات',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر طريقة الدفع',
          style: AppStyles.font16BoldDark,
        ),
        SizedBox(height: 10.h),
        PaymentMethodSelector(
          selectedMethod: _selectedPayType,
          onMethodChanged: (method) => setState(() => _selectedPayType = method),
        ),
      ],
    );
  }

  Widget _buildOrderSummarySection() {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cart = state.cartData;
        final productPrice = cart?.totalPriceBeforeDiscount ?? 0;
        final deliveryPrice = cart?.deliveryCost ?? 0;
        final discount = cart?.totalDiscount ?? 0;
        final totalPrice = cart != null
            ? (cart.totalPriceWithVat + deliveryPrice)
            : 0;

        return OrderSummaryCard(
          productPrice: productPrice,
          deliveryPrice: deliveryPrice,
          discount: discount,
          totalPrice: totalPrice,
        );
      },
    );
  }
}
