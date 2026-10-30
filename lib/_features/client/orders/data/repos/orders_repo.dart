import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
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
}
