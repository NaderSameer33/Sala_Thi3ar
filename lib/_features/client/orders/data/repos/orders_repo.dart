import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/create_order_request_body.dart';
import '../models/order_details_model.dart';
import '../models/order_model.dart';

class OrdersRepo {
  final ApiService apiService;

  OrdersRepo(this.apiService);

  Future<Either<Failure, List<OrderModel>>> getCurrentOrders() async {
    try {
      final response = await apiService.get(
        endPoint: 'client/orders/current',
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تحميل الطلبات الحالية'),
          );
        }
        final rawData = data['data'];
        if (rawData is List) {
          final list = rawData
              .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Right(list);
        }
      }
      return const Right([]);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<OrderModel>>> getFinishedOrders() async {
    try {
      final response = await apiService.get(
        endPoint: 'client/orders/finished',
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تحميل الطلبات المنتهية'),
          );
        }
        final rawData = data['data'];
        if (rawData is List) {
          final list = rawData
              .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Right(list);
        }
      }
      return const Right([]);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> createOrder(
    CreateOrderRequestBody requestBody,
  ) async {
    try {
      final response = await apiService.post(
        endPoint: 'client/orders',
        data: requestBody.toFormData(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل إنشاء الطلب'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم إنشاء الطلب بنجاح');
      }
      return const Right('تم إنشاء الطلب بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, OrderDetailsModel>> getOrderDetails(int orderId) async {
    try {
      final response = await apiService.get(
        endPoint: 'client/orders/$orderId',
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تحميل تفاصيل الطلب'),
          );
        }
        final rawData = data['data'];
        if (rawData is Map<String, dynamic>) {
          return Right(OrderDetailsModel.fromJson(rawData));
        }
      }
      return Left(ServerFailure('بيانات الطلب غير صالحة'));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> cancelOrder(int orderId) async {
    try {
      final response = await apiService.post(
        endPoint: 'client/orders/$orderId/cancel',
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل إلغاء الطلب'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم إلغاء الطلب بنجاح');
      }
      return const Right('تم إلغاء الطلب بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> rateProduct({
    required int productId,
    required int value,
    required String comment,
  }) async {
    try {
      final formData = FormData.fromMap({
        'value': value,
        'comment': comment,
      });
      final response = await apiService.post(
        endPoint: 'client/products/$productId/rate',
        data: formData,
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل إرسال التقييم'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم إضافة التقييم بنجاح');
      }
      return const Right('تم إضافة التقييم بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
