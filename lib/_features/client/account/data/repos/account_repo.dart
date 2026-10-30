import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/caching/secure_storage_service.dart';
import '../../../../../core/caching/shared_pref_service.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/edit_profile_request_body.dart';
import '../models/user_profile_model.dart';

class AccountRepo {
  final ApiService apiService;
  final SecureStorageService secureStorageService;

  AccountRepo({
    required this.apiService,
    required this.secureStorageService,
  });

  Future<Either<Failure, UserProfileModel>> getProfile() async {
    try {
      final response = await apiService.get(
        endPoint: 'client/profile',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تحميل بيانات الحساب'),
          );
        }
        if (data['data'] is Map<String, dynamic>) {
          final profile = UserProfileModel.fromJson(data['data'] as Map<String, dynamic>);
          return Right(profile);
        }
      }

      return Left(ServerFailure('تعذر تحميل بيانات الملف الشخصي'));
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
      if (data is Map<String, dynamic> && data['data'] is List) {
        final cities = (data['data'] as List)
            .map((item) => UserProfileCity.fromJson(item as Map<String, dynamic>))
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

  Future<Either<Failure, String>> logout() async {
    try {
      final response = await apiService.post(
        endPoint: 'logout',
      );

      await secureStorageService.delete(SecureStorageService.keyUserToken);
      await SharedPrefService.remove('user_data');

      final data = response.data;
      String message = 'تم تسجيل الخروج بنجاح';
      if (data is Map<String, dynamic> && data['message'] != null) {
        message = data['message'].toString();
      }

      return Right(message);
    } on DioException catch (e) {
      await secureStorageService.delete(SecureStorageService.keyUserToken);
      await SharedPrefService.remove('user_data');
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      await secureStorageService.delete(SecureStorageService.keyUserToken);
      await SharedPrefService.remove('user_data');
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserProfileModel>> editProfile(
    EditProfileRequestBody body,
  ) async {
    try {
      final formData = await body.toFormData();
      final response = await apiService.post(
        endPoint: 'client/profile',
        data: formData,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تعديل البيانات'),
          );
        }
        if (data['data'] is Map<String, dynamic>) {
          final profile = UserProfileModel.fromJson(data['data'] as Map<String, dynamic>);
          return Right(profile);
        }
      }

      return Left(ServerFailure('تعذر تعديل البيانات'));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
