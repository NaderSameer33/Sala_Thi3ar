import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/notification_model.dart';

class NotificationsRepo {
  final ApiService apiService;

  NotificationsRepo(this.apiService);

  Future<Either<Failure, NotificationsResponseModel>> getNotifications({int page = 1}) async {
    try {
      final response = await apiService.get(
        endPoint: 'notifications',
        queryParameters: {'page': page},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل في جلب الإشعارات'),
          );
        }
        final rawData = data['data'];
        if (rawData is Map<String, dynamic>) {
          return Right(NotificationsResponseModel.fromJson(rawData));
        }
      }
      return const Right(NotificationsResponseModel());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> deleteNotification(String id) async {
    try {
      final response = await apiService.delete(
        endPoint: 'notifications/$id',
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل في حذف الإشعار'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم حذف الإشعار بنجاح');
      }
      return const Right('تم حذف الإشعار');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> clearAllNotifications() async {
    try {
      final response = await apiService.post(
        endPoint: 'notifications/clear_all_notifications',
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل في مسح الإشعارات'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم مسح جميع الإشعارات بنجاح');
      }
      return const Right('تم مسح جميع الإشعارات');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

