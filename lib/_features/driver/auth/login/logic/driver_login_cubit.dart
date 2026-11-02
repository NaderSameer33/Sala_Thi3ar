import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/base/safe_cubit.dart';
import '../../../../../core/services/fcm_service.dart';
import '../../../../client/auth/login/data/models/login_request_body.dart';
import '../../../../client/auth/login/data/repos/client_login_repo.dart';
import 'driver_login_state.dart';

class DriverLoginCubit extends Cubit<DriverLoginState> with SafeEmitMixin {
  final ClientLoginRepo clientLoginRepo;
  final FcmService fcmService;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordObscure = true;
  String? currentLat;
  String? currentLng;

  DriverLoginCubit(this.clientLoginRepo, this.fcmService)
      : super(DriverLoginInitial()) {
    _initLocation();
  }

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    emit(DriverLoginPasswordVisibilityChanged(isPasswordObscure));
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentLat = '24.7136';
        currentLng = '46.6753';
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentLat = '24.7136';
          currentLng = '46.6753';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        currentLat = '24.7136';
        currentLng = '46.6753';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      currentLat = position.latitude.toString();
      currentLng = position.longitude.toString();
    } catch (_) {
      currentLat = '24.7136';
      currentLng = '46.6753';
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    emit(DriverLoginLoading());

    final token = await fcmService.getOrFetchToken();

    final requestBody = LoginRequestBody(
      phone: phoneController.text.trim(),
      password: passwordController.text,
      deviceToken: token,
      userType: 'driver',
      lat: currentLat ?? '24.7136',
      lng: currentLng ?? '46.6753',
    );

    final result = await clientLoginRepo.login(requestBody);

    result.fold(
      (failure) => emit(DriverLoginError(failure.message)),
      (response) => emit(DriverLoginSuccess(response)),
    );
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
