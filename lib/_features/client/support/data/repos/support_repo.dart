import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/contact_info_model.dart';
import '../models/faq_model.dart';
import '../models/send_contact_request_body.dart';

class SupportRepo {
  final ApiService apiService;

  SupportRepo(this.apiService);

  Future<Either<Failure, List<FaqModel>>> getFaqs() async {
    try {
      final response = await apiService.get(endPoint: 'faqs');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(ServerFailure(data['message']?.toString() ?? 'فشل تحميل الأسئلة'));
        }
        final rawList = data['data'];
        if (rawList is List) {
          final list = rawList
              .map((item) => FaqModel.fromJson(item as Map<String, dynamic>))
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

  Future<Either<Failure, String>> getPolicy() async {
    try {
      final response = await apiService.get(endPoint: 'policy');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(ServerFailure(data['message']?.toString() ?? 'فشل تحميل سياسة الخصوصية'));
        }
        final content = data['data'];
        if (content is Map<String, dynamic>) {
          return Right(content['policy']?.toString() ?? '');
        }
      }
      return const Right('');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> getAbout() async {
    try {
      final response = await apiService.get(endPoint: 'about');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(ServerFailure(data['message']?.toString() ?? 'فشل تحميل عن التطبيق'));
        }
        final content = data['data'];
        if (content is Map<String, dynamic>) {
          return Right(content['about']?.toString() ?? '');
        }
      }
      return const Right('');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ContactInfoModel>> getContactInfo() async {
    try {
      final response = await apiService.get(endPoint: 'contact');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(ServerFailure(data['message']?.toString() ?? 'فشل تحميل بيانات التواصل'));
        }
        if (data['data'] is Map<String, dynamic>) {
          return Right(ContactInfoModel.fromJson(data['data'] as Map<String, dynamic>));
        }
      }
      return const Right(ContactInfoModel());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> sendContact(SendContactRequestBody body) async {
    try {
      final response = await apiService.post(
        endPoint: 'contact',
        data: body.toFormData(),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(ServerFailure(data['message']?.toString() ?? 'فشل إرسال الرسالة'));
        }
        return Right(data['message']?.toString() ?? 'تم إرسال الرسالة بنجاح');
      }
      return const Right('تم إرسال الرسالة بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

