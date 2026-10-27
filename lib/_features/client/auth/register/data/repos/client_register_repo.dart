import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sala_thimar/_features/client/auth/register/data/models/register_request_body.dart';
import 'package:sala_thimar/_features/client/auth/register/data/models/register_response_model.dart';
import 'package:sala_thimar/core/errors/failure.dart';
import 'package:sala_thimar/core/services/api_service.dart';

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
}
