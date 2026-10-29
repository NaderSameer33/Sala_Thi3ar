import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../../../home/data/models/product_model.dart';
import '../models/product_rate_model.dart';

class ProductDetailsRepo {
  final ApiService apiService;

  ProductDetailsRepo(this.apiService);

  Future<Either<Failure, ProductModel>> getProductDetails(int productId) async {
    try {
      final response = await apiService.get(
        endPoint: 'products/$productId',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل جلب تفاصيل المنتج'),
          );
        }
        if (data['data'] != null && data['data'] is Map<String, dynamic>) {
          final product = ProductModel.fromJson(data['data'] as Map<String, dynamic>);
          return Right(product);
        }
      }

      return const Left(ServerFailure('بيانات المنتج غير متوفرة'));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ProductRateModel>>> getProductRates(int productId) async {
    try {
      final response = await apiService.get(
        endPoint: 'products/$productId/rates',
      );

      final ratesResponse = ProductRatesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (ratesResponse.status == 'fail') {
        return Left(
          ServerFailure(
            ratesResponse.message.isNotEmpty
                ? ratesResponse.message
                : 'فشل جلب تقييمات المنتج',
          ),
        );
      }

      return Right(ratesResponse.data);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ProductModel>>> getSimilarProducts({int? categoryId}) async {
    try {
      final params = categoryId != null ? {'category_id': categoryId} : null;
      final response = await apiService.get(
        endPoint: 'products',
        queryParameters: params,
      );

      final productResponse = ProductResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(productResponse.data);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

