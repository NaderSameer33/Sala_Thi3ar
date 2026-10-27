import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
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
}
