import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_input.dart';
import '../../data/models/add_address_request_body.dart';
import '../../data/models/address_model.dart';
import '../../logic/addresses_cubit.dart';
import '../../logic/addresses_state.dart';
import '../components/address_type_toggle.dart';

class AddAddressView extends StatelessWidget {
  final AddressModel? address;

  const AddAddressView({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AddressesCubit>(),
      child: _AddAddressViewBody(address: address),
    );
  }
}

class _AddAddressViewBody extends StatefulWidget {
  final AddressModel? address;

  const _AddAddressViewBody({this.address});

  @override
  State<_AddAddressViewBody> createState() => _AddAddressViewBodyState();
}

class _AddAddressViewBodyState extends State<_AddAddressViewBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _descriptionController;
  late String _selectedType;
  GoogleMapController? _mapController;
  late LatLng _currentPosition;
  bool _hasPopped = false;

  bool get isEdit => widget.address != null;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _selectedType = (address?.type == 'work' || address?.type == 'العمل') ? 'work' : 'home';
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _descriptionController = TextEditingController(text: address?.description ?? address?.location ?? '');

    if (address != null && address.lat != 0 && address.lng != 0) {
      _currentPosition = LatLng(address.lat, address.lng);
    } else {
      _currentPosition = const LatLng(24.7136, 46.6753);
      _determinePosition();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _descriptionController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();
      final target = LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _currentPosition = target;
        });
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
      }
    } catch (_) {}
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final desc = _descriptionController.text.trim();

    final body = AddAddressRequestBody(
      type: _selectedType,
      phone: phone,
      description: desc,
      location: desc.isNotEmpty ? desc : (_selectedType == 'home' ? 'المنزل' : 'العمل'),
      lat: _currentPosition.latitude,
      lng: _currentPosition.longitude,
      isDefault: 1,
    );

    final cubit = context.read<AddressesCubit>();
    if (isEdit) {
      cubit.updateAddress(widget.address!.id, body);
    } else {
      cubit.addAddress(body);
    }
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
          isEdit ? 'تعديل العنوان' : 'إضافة عنوان',
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
            (curr.actionType == AddressActionType.add ||
                curr.actionType == AddressActionType.update),
        listener: (context, state) {
          if (state.actionStatus == AddressActionStatus.success && !_hasPopped) {
            _hasPopped = true;
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.fillColored,
              title: Text(state.actionMessage.isNotEmpty ? state.actionMessage : 'تم الحفظ بنجاح'),
              autoCloseDuration: const Duration(seconds: 3),
            );
            Navigator.of(context).pop();
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
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition,
                          zoom: 15,
                        ),
                        onMapCreated: (controller) => _mapController = controller,
                        onCameraMove: (position) {
                          _currentPosition = position.target;
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                      IgnorePointer(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 46.r,
                              color: AppColors.primary,
                            ),
                            Container(
                              width: 10.r,
                              height: 4.r,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        child: FloatingActionButton.small(
                          heroTag: 'my_location_btn',
                          backgroundColor: AppColors.white,
                          onPressed: _determinePosition,
                          child: Icon(
                            Icons.my_location_rounded,
                            color: AppColors.primary,
                            size: 22.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 10.r,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AddressTypeToggle(
                          selectedType: _selectedType,
                          onTypeChanged: (type) => setState(() => _selectedType = type),
                        ),
                        SizedBox(height: 16.h),
                        AppInput(
                          controller: _phoneController,
                          hintText: 'أدخل رقم الجوال',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال رقم الجوال';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12.h),
                        AppInput(
                          controller: _descriptionController,
                          hintText: 'الوصف',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'يرجى إدخال الوصف';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        AppButton(
                          text: isEdit ? 'تعديل العنوان' : 'إضافة العنوان',
                          isLoading: state.isActionLoading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
