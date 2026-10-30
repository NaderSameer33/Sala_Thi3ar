import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/cart_data_model.dart';

class CartRepo {
  final ApiService apiService;

  CartRepo(this.apiService);

  Future<Either<Failure, CartDataModel>> getCart() async {
    try {
      final response = await apiService.get(endPoint: 'client/cart');

      final cartData = CartDataModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (cartData.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(
          ServerFailure(
            cartData.message.isNotEmpty
                ? cartData.message
                : 'فشل تحميل بيانات السلة',
          ),
        );
      }

      return Right(cartData);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> addToCart({
    required int productId,
    required int amount,
  }) async {
    try {
      final response = await apiService.post(
        endPoint: 'client/cart',
        data: FormData.fromMap({
          'product_id': productId,
          'amount': amount,
        }),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل إضافة المنتج للسلة'),
          );
        }
        return Right(data['message']?.toString() ?? 'تمت الإضافة بنجاح');
      }

      return const Right('تمت الإضافة بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> updateItemAmount({
    required int itemId,
    required int amount,
  }) async {
    try {
      final response = await apiService.put(
        endPoint: 'client/cart/$itemId',
        data: {'amount': amount},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تعديل الكمية'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم التعديل بنجاح');
      }

      return const Right('تم التعديل بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> deleteItem(int itemId) async {
    try {
      final response = await apiService.delete(
        endPoint: 'client/cart/delete_item/$itemId',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل حذف المنتج'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم الحذف بنجاح');
      }

      return const Right('تم الحذف بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> applyCoupon(String coupon) async {
    try {
      final response = await apiService.post(
        endPoint: 'client/cart/apply_coupon',
        data: FormData.fromMap({'code': coupon}),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final status = data['status']?.toString();
        final message = data['message']?.toString() ?? '';
        final responseData = data['data'];

        if (status == 'fail' ||
            (status == 'success' && responseData == null && message != 'تم تطبيق الكوبون بنجاح' && message != 'تم تطبيق الكوبون')) {
          return Left(
            ServerFailure(message.isNotEmpty ? message : 'الكود غير صحيح'),
          );
        }

        return Right(message.isNotEmpty ? message : 'تم تطبيق الكوبون بنجاح');
      }

      return const Right('تم تطبيق الكوبون بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
