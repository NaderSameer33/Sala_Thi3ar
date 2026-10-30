import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';

class FavoritesRepo {
  final ApiService apiService;

  FavoritesRepo(this.apiService);

  Future<Either<Failure, List<ProductModel>>> getFavorites() async {
    try {
      final response = await apiService.get(
        endPoint: 'client/products/favorites',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تحميل المنتجات المفضلة'),
          );
        }
        final rawList = data['data'];
        if (rawList is List) {
          final products = rawList
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Right(products);
        }
      }

      return const Right([]);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> addToFavorite(int productId) async {
    try {
      final response = await apiService.post(
        endPoint: 'client/products/$productId/add_to_favorite',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل إضافة المنتج للمفضلة'),
          );
        }
        return Right(data['message']?.toString() ?? 'تمت الإضافة للمفضلة');
      }

      return const Right('تمت الإضافة للمفضلة');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> removeFromFavorite(int productId) async {
    try {
      final response = await apiService.post(
        endPoint: 'client/products/$productId/remove_from_favorite',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل إزالة المنتج من المفضلة'),
          );
        }
        return Right(data['message']?.toString() ?? 'تمت الإزالة من المفضلة');
      }

      return const Right('تمت الإزالة من المفضلة');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
