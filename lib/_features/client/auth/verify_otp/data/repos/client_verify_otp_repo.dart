import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/verify_otp_request_body.dart';
import '../models/verify_otp_response_model.dart';
import '../../../../../../core/caching/secure_storage_service.dart';
import '../../../../../../core/caching/shared_pref_service.dart';
import '../../../../../../core/constants/constant.dart';
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

      if (verifyResponse.data?.userType != null) {
        await SharedPrefService.setString(
          AppConstant.userRole,
          verifyResponse.data!.userType!,
        );
      }

      if (verifyResponse.data != null) {
        await SharedPrefService.setString(
          'user_data',
          jsonEncode(verifyResponse.data!.toJson()),
        );
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

      final status = response.data['status']?.toString();
      final message = response.data['message']?.toString();

      if (status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(ServerFailure(message ?? 'الكود غير صحيح'));
      }

      return Right(code);
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
        data: FormData.fromMap({
          'phone': phone,
        }),
      );

      final status = response.data['status']?.toString();
      final message = response.data['message']?.toString();

      if (status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(ServerFailure(message ?? 'فشل إعادة إرسال الكود'));
      }

      return Right(message ?? 'تم إعادة إرسال الكود بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
