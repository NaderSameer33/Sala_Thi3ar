import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../data/models/address_model.dart';
import '../../logic/addresses_cubit.dart';
import '../../logic/addresses_state.dart';
import '../components/address_dashed_add_button.dart';
import '../components/address_item_card.dart';
import '../components/delete_address_dialog.dart';

class AddressesView extends StatelessWidget {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AddressesCubit>()..getAddresses(),
      child: const _AddressesViewBody(),
    );
  }
}

class _AddressesViewBody extends StatelessWidget {
  const _AddressesViewBody();

  static const _dummyAddresses = [
    AddressModel(
      id: 1,
      type: 'المنزل',
      lat: 0,
      lng: 0,
      location: '119 طريق الملك عبدالعزيز',
      description: 'تفاصيل العنوان بالكامل',
      phone: '0512345678',
      isDefault: true,
    ),
    AddressModel(
      id: 2,
      type: 'العمل',
      lat: 0,
      lng: 0,
      location: '119 طريق الملك عبدالعزيز',
      description: 'مقر الشركة الرئيسي',
      phone: '0512345678',
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddressesCubit>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'العناوين',
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
      body: BlocConsumer<AddressesCubit, AddressesState>(
        listenWhen: (prev, curr) =>
            prev.actionStatus != curr.actionStatus &&
            curr.actionType == AddressActionType.delete,
        listener: (context, state) {
          if (state.actionStatus == AddressActionStatus.success && state.actionMessage.isNotEmpty) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.fillColored,
              title: Text(state.actionMessage),
              autoCloseDuration: const Duration(seconds: 3),
            );
          } else if (state.actionStatus == AddressActionStatus.error && state.errorMessage.isNotEmpty) {
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
          final isLoading = state.status == AddressesStatus.loading;
          final addresses = isLoading ? _dummyAddresses : state.addresses;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => cubit.getAddresses(),
            child: Skeletonizer(
              enabled: isLoading,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                children: [
                  ...addresses.map(
                    (address) => AddressItemCard(
                      address: address,
                      isDeleting: state.deletingId == address.id,
                      onDelete: () {
                        DeleteAddressDialog.show(
                          context,
                          onConfirm: () => cubit.deleteAddress(address.id),
                        );
                      },
                      onEdit: () async {
                        cubit.resetActionStatus();
                        await context.push(
                          AppRouterName.addAddress,
                          extra: address,
                        );
                        cubit.getAddresses();
                      },
                    ),
                  ),
                  SizedBox(height: 8.h),
                  AddressDashedAddButton(
                    onTap: () async {
                      cubit.resetActionStatus();
                      await context.push(AppRouterName.addAddress);
                      cubit.getAddresses();
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
