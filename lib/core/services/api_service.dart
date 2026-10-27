import 'package:dio/dio.dart';
import 'package:sala_thimar/core/caching/secure_storage_service.dart';

class ApiService {
  final Dio dio;
  final SecureStorageService secureStorageService;

  ApiService({
    required this.dio,
    required this.secureStorageService,
  }) {
    dio.options = BaseOptions(
      baseUrl: 'https://thimar.amr.aait-d.com/api/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorageService.read(SecureStorageService.keyUserToken);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(
      endPoint,
      queryParameters: queryParameters,
    );
  }

  Future<Response> post({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.post(
      endPoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> put({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.put(
      endPoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> delete({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.delete(
      endPoint,
      data: data,
      queryParameters: queryParameters,
    );
  }
}
