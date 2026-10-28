import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sala_thimar/_features/client/auth/forget_password/data/repos/client_forget_password_repo.dart';
import 'package:sala_thimar/_features/client/auth/forget_password/logic/client_forget_password_cubit.dart';
import 'package:sala_thimar/_features/client/auth/login/data/repos/client_login_repo.dart';
import 'package:sala_thimar/_features/client/auth/login/logic/client_login_cubit.dart';
import 'package:sala_thimar/_features/client/auth/register/data/repos/client_register_repo.dart';
import 'package:sala_thimar/_features/client/auth/register/logic/client_register_cubit.dart';
import 'package:sala_thimar/_features/client/auth/reset_password/data/repos/client_reset_password_repo.dart';
import 'package:sala_thimar/_features/client/auth/reset_password/logic/client_reset_password_cubit.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/data/repos/client_verify_otp_repo.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/logic/client_verify_otp_cubit.dart';
import 'package:sala_thimar/core/caching/secure_storage_service.dart';
import 'package:sala_thimar/core/services/api_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(
      dio: getIt<Dio>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<ClientLoginRepo>(
    () => ClientLoginRepo(
      apiService: getIt<ApiService>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerFactory<ClientLoginCubit>(
    () => ClientLoginCubit(getIt<ClientLoginRepo>()),
  );
  getIt.registerLazySingleton<ClientRegisterRepo>(
    () => ClientRegisterRepo(
      apiService: getIt<ApiService>(),
    ),
  );
  getIt.registerFactory<ClientRegisterCubit>(
    () => ClientRegisterCubit(getIt<ClientRegisterRepo>()),
  );
  getIt.registerLazySingleton<ClientVerifyOtpRepo>(
    () => ClientVerifyOtpRepo(
      apiService: getIt<ApiService>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerFactoryParam<ClientVerifyOtpCubit, String, bool?>(
    (phone, isForgetPassword) => ClientVerifyOtpCubit(
      verifyOtpRepo: getIt<ClientVerifyOtpRepo>(),
      phone: phone,
      isForgetPassword: isForgetPassword ?? false,
    ),
  );
  getIt.registerLazySingleton<ClientForgetPasswordRepo>(
    () => ClientForgetPasswordRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<ClientForgetPasswordCubit>(
    () => ClientForgetPasswordCubit(getIt<ClientForgetPasswordRepo>()),
  );
  getIt.registerLazySingleton<ClientResetPasswordRepo>(
    () => ClientResetPasswordRepo(getIt<ApiService>()),
  );
  getIt.registerFactoryParam<ClientResetPasswordCubit, String, String>(
    (phone, code) => ClientResetPasswordCubit(
      resetPasswordRepo: getIt<ClientResetPasswordRepo>(),
      phone: phone,
      code: code,
    ),
  );
}
