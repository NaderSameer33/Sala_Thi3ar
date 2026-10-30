import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/add_address_request_body.dart';
import '../models/address_model.dart';

class AddressesRepo {
  final ApiService apiService;

  AddressesRepo(this.apiService);

  Future<Either<Failure, List<AddressModel>>> getAddresses() async {
    try {
      final response = await apiService.get(
        endPoint: 'client/addresses',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تحميل العناوين'),
          );
        }
        final rawList = data['data'];
        if (rawList is List) {
          final addresses = rawList
              .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Right(addresses);
        }
      }

      return const Right([]);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> addAddress(AddAddressRequestBody body) async {
    try {
      final response = await apiService.post(
        endPoint: 'client/addresses',
        data: body.toFormData(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل إضافة العنوان'),
          );
        }
        return Right(data['message']?.toString() ?? 'تمت إضافة العنوان بنجاح');
      }

      return const Right('تمت إضافة العنوان بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> updateAddress(
    int id,
    AddAddressRequestBody body,
  ) async {
    try {
      final response = await apiService.put(
        endPoint: 'client/addresses/$id',
        data: body.toMap(),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تعديل العنوان'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم تعديل العنوان بنجاح');
      }

      return const Right('تم تعديل العنوان بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> deleteAddress(int id) async {
    try {
      final response = await apiService.delete(
        endPoint: 'client/addresses/$id',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل حذف العنوان'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم حذف العنوان بنجاح');
      }

      return const Right('تم حذف العنوان بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

