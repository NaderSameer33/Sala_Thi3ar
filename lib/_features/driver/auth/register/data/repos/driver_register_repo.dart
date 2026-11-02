import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sala_thimar/_features/client/account/data/models/user_profile_model.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/car_model_item.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/driver_register_request_body.dart';
import 'package:sala_thimar/_features/driver/auth/register/data/models/driver_register_response_model.dart';
import 'package:sala_thimar/core/errors/failure.dart';
import 'package:sala_thimar/core/services/api_service.dart';

class DriverRegisterRepo {
  final ApiService apiService;

  DriverRegisterRepo({
    required this.apiService,
  });

  Future<Either<Failure, DriverRegisterResponseModel>> register(
    DriverRegisterRequestBody requestBody,
  ) async {
    try {
      final formData = await requestBody.toFormData();
      final response = await apiService.post(
        endPoint: 'driver_register',
        data: formData,
      );

      final registerResponse = DriverRegisterResponseModel.fromJson(response.data);

      if (registerResponse.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(
          ServerFailure(registerResponse.message ?? 'فشل إنشاء حساب المندوب'),
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
      final response = await apiService.get(endPoint: 'cities/1');
      final data = response.data;
      if (data != null && data['data'] is List) {
        final cities = (data['data'] as List)
            .map((item) => UserProfileCity.fromJson(item as Map<String, dynamic>))
            .toList();
        return Right(cities);
      }
      return const Right([]);
    } catch (_) {
      return const Right([]);
    }
  }

  Future<Either<Failure, List<CarModelItem>>> getCarModels() async {
    try {
      final response = await apiService.get(endPoint: 'car_models');
      final data = response.data;
      if (data != null && data['data'] is List) {
        final models = (data['data'] as List)
            .map((item) => CarModelItem.fromJson(item as Map<String, dynamic>))
            .toList();
        return Right(models);
      }
      return const Right(CarModelItem.defaultModels);
    } catch (_) {
      return const Right(CarModelItem.defaultModels);
    }
  }
}
