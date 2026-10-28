import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sala_thimar/core/errors/failure.dart';
import 'package:sala_thimar/core/services/api_service.dart';

class ClientForgetPasswordRepo {
  final ApiService apiService;

  ClientForgetPasswordRepo(this.apiService);

  Future<Either<Failure, String>> sendOtp(String phone) async {
    try {
      final response = await apiService.post(
        endPoint: 'forget_password',
        data: FormData.fromMap({
          'phone': phone,
        }),
      );

      if (response.data['status'] == 'fail') {
        return Left(
          ServerFailure(
            response.data['message']?.toString() ?? 'فشل إرسال كود التحقق',
          ),
        );
      }

      final message = response.data['message']?.toString() ?? 'تم الإرسال بنجاح';
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
