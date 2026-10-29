import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../../../home/data/models/product_model.dart';

class CategoryProductsRepo {
  final ApiService apiService;

  CategoryProductsRepo(this.apiService);

  Future<Either<Failure, ProductResponseModel>> getCategoryProducts({
    required int categoryId,
    String? keyword,
    String? filter,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'category_id': categoryId,
      };

      if (keyword != null && keyword.trim().isNotEmpty) {
        queryParams['keyword'] = keyword.trim();
      }

      if (filter != null && filter.isNotEmpty) {
        queryParams['filter'] = filter;
      }

      if (minPrice != null) {
        queryParams['min_price'] = minPrice;
      }

      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice;
      }

      final response = await apiService.get(
        endPoint: 'products',
        queryParameters: queryParams,
      );

      final productResponse = ProductResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (productResponse.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(
          ServerFailure(
            productResponse.message.isNotEmpty
                ? productResponse.message
                : 'فشل تحميل المنتجات',
          ),
        );
      }

      return Right(productResponse);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

