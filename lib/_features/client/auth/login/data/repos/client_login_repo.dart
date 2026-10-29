import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/login_request_body.dart';
import '../models/login_response_model.dart';
import '../../../../../../core/caching/secure_storage_service.dart';
import '../../../../../../core/caching/shared_pref_service.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/services/api_service.dart';

class ClientLoginRepo {
  final ApiService apiService;
  final SecureStorageService secureStorageService;

  ClientLoginRepo({
    required this.apiService,
    required this.secureStorageService,
  });

  Future<Either<Failure, LoginResponseModel>> login(
      LoginRequestBody loginRequestBody) async {
    try {
      final response = await apiService.post(
        endPoint: 'login',
        data: loginRequestBody.toFormData(),
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);

      if (loginResponse.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(ServerFailure(loginResponse.message ?? 'فشل تسجيل الدخول'));
      }

      final token = loginResponse.data?.token;
      if (token != null && token.isNotEmpty) {
        await secureStorageService.write(SecureStorageService.keyUserToken, token);
      }

      if (loginResponse.data != null) {
        await SharedPrefService.setString(
          'user_data',
          jsonEncode(loginResponse.data!.toJson()),
        );
      }

      return Right(loginResponse);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
