import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sala_thimar/_features/client/account/data/models/user_profile_model.dart';
import 'package:sala_thimar/core/errors/failure.dart';
import 'package:sala_thimar/core/services/api_service.dart';
import '../models/register_request_body.dart';
import '../models/register_response_model.dart';

class ClientRegisterRepo {
  final ApiService apiService;

  ClientRegisterRepo({
    required this.apiService,
  });

  Future<Either<Failure, RegisterResponseModel>> register(
      RegisterRequestBody registerRequestBody) async {
    try {
      final response = await apiService.post(
        endPoint: 'client_register',
        data: registerRequestBody.toFormData(),
      );

      final registerResponse = RegisterResponseModel.fromJson(response.data);

      if (registerResponse.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(
          ServerFailure(registerResponse.message ?? 'فشل إنشاء الحساب'),
        );
      }

      return Right(registerResponse);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<UserProfileCity>>> getCities() async {
    try {
      final response = await apiService.get(
        endPoint: 'cities/1',
      );
      final data = response.data;
      if (data != null && data['data'] is List) {
        final cities = (data['data'] as List)
            .map((e) => UserProfileCity.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(cities);
      }
      return const Right([]);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
