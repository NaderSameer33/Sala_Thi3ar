import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sala_thimar/_features/client/auth/login/data/repos/client_login_repo.dart';
import 'package:sala_thimar/_features/client/auth/login/logic/client_login_cubit.dart';
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
}
