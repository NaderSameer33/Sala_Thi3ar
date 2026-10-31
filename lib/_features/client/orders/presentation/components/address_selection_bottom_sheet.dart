import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/routers/app_router_name.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../addresses/data/models/address_model.dart';
import '../../../addresses/logic/addresses_cubit.dart';
import '../../../addresses/logic/addresses_state.dart';
import '../../../addresses/presentation/components/address_dashed_add_button.dart';
import '../../../addresses/presentation/components/address_item_card.dart';
import '../../../addresses/presentation/components/delete_address_dialog.dart';

class AddressSelectionBottomSheet extends StatelessWidget {
  const AddressSelectionBottomSheet({super.key});

  static Future<AddressModel?> show(BuildContext context) {
    return showModalBottomSheet<AddressModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddressSelectionBottomSheet(),
    );
  }

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
    final cubit = getIt<AddressesCubit>()..getAddresses();

    return BlocProvider.value(
      value: cubit,
      child: Container(
        height: 0.7.sh,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.r),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'العناوين',
              style: AppStyles.font18BoldPrimary,
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<AddressesCubit, AddressesState>(
                builder: (context, state) {
                  final isLoading = state.isLoading;
                  final addresses = isLoading ? _dummyAddresses : state.addresses;

                  return Skeletonizer(
                    enabled: isLoading,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ...addresses.map(
                          (address) => GestureDetector(
                            onTap: () {
                              if (!isLoading) {
                                Navigator.of(context).pop(address);
                              }
                            },
                            child: AddressItemCard(
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
                        ),
                        SizedBox(height: 8.h),
                        AddressDashedAddButton(
                          onTap: () async {
                            cubit.resetActionStatus();
                            await context.push(AppRouterName.addAddress);
                            cubit.getAddresses();
                          },
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

