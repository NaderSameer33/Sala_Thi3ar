import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sala_thimar/_features/client/auth/reset_password/data/models/reset_password_request_body.dart';
import 'package:sala_thimar/core/errors/failure.dart';
import 'package:sala_thimar/core/services/api_service.dart';

class ClientResetPasswordRepo {
  final ApiService apiService;

  ClientResetPasswordRepo(this.apiService);

  Future<Either<Failure, String>> resetPassword(
      ResetPasswordRequestBody requestBody) async {
    try {
      final response = await apiService.post(
        endPoint: 'reset_password',
        data: requestBody.toFormData(),
      );

      if (response.data['status'] == 'fail') {
        return Left(
          ServerFailure(
            response.data['message']?.toString() ?? 'فشل تغيير كلمة المرور',
          ),
        );
      }

      final message =
          response.data['message']?.toString() ?? 'تم تغيير كلمة المرور بنجاح';
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
