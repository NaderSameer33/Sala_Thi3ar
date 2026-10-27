import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure('انتهت مهلة الاتصال بالخادم');
      case DioExceptionType.sendTimeout:
        return const ServerFailure('انتهت مهلة إرسال البيانات');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('انتهت مهلة استقبال البيانات من الخادم');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure('تم إلغاء الطلب');
      case DioExceptionType.connectionError:
        return const ServerFailure('لا يوجد اتصال بالإنترنت');
      default:
        return const ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('message')) {
        return ServerFailure(response['message'].toString());
      }
      if (response.containsKey('msg')) {
        return ServerFailure(response['msg'].toString());
      }
    }
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return const ServerFailure('بيانات الدخول غير صحيحة');
    } else if (statusCode == 404) {
      return const ServerFailure('الخدمة المطلوبة غير متوفرة');
    } else if (statusCode == 500) {
      return const ServerFailure('خطأ في الخادم الداخلي، يرجى المحاولة لاحقاً');
    }
    return const ServerFailure('حدث خطأ أثناء معالجة الطلب');
  }
}
