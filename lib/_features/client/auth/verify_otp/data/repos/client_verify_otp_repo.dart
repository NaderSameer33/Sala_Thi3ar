import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/verify_otp_request_body.dart';
import '../models/verify_otp_response_model.dart';
import '../../../../../../core/caching/secure_storage_service.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/services/api_service.dart';

class ClientVerifyOtpRepo {
  final ApiService apiService;
  final SecureStorageService secureStorageService;

  ClientVerifyOtpRepo({
    required this.apiService,
    required this.secureStorageService,
  });

  Future<Either<Failure, VerifyOtpResponseModel>> verifyOtp(
      VerifyOtpRequestBody requestBody) async {
    try {
      final response = await apiService.post(
        endPoint: 'verify',
        data: requestBody.toFormData(),
      );

      final verifyResponse = VerifyOtpResponseModel.fromJson(response.data);

      if (verifyResponse.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(
          ServerFailure(verifyResponse.message ?? 'فشل تأكيد الكود'),
        );
      }

      final token = verifyResponse.data?.token;
      if (token != null && token.isNotEmpty) {
        await secureStorageService.write(SecureStorageService.keyUserToken, token);
      }

      return Right(verifyResponse);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> checkCode({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await apiService.post(
        endPoint: 'check_code',
        data: FormData.fromMap({
          'phone': phone,
          'code': code,
        }),
      );

      if (response.data['status'] == 'fail') {
        return Left(
          ServerFailure(
            response.data['message']?.toString() ?? 'الكود غير صحيح',
          ),
        );
      }

      final message = response.data['message']?.toString() ?? 'تم التأكيد بنجاح';
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> resendOtp(String phone) async {
    try {
      final response = await apiService.post(
        endPoint: 'resend_code',
        data: FormData.fromMap({'phone': phone}),
      );

      final message = response.data['message']?.toString() ??
          response.data['msg']?.toString() ??
          'تمت إعادة إرسال الكود بنجاح';

      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
