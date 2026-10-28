import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sala_thimar/_features/client/home/data/models/category_model.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import 'package:sala_thimar/_features/client/home/data/models/slider_model.dart';
import 'package:sala_thimar/core/errors/failure.dart';
import 'package:sala_thimar/core/services/api_service.dart';

class HomeRepo {
  final ApiService apiService;

  HomeRepo(this.apiService);

  Future<Either<Failure, List<SliderModel>>> getSliders() async {
    try {
      final response = await apiService.get(endPoint: 'sliders');

      final sliderResponse = SliderResponseModel.fromJson(response.data);

      if (sliderResponse.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(
          ServerFailure(
            sliderResponse.message.isNotEmpty
                ? sliderResponse.message
                : 'فشل تحميل الإعلانات',
          ),
        );
      }

      return Right(sliderResponse.data);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final response = await apiService.get(endPoint: 'categories');

      final categoryResponse = CategoryResponseModel.fromJson(response.data);

      if (categoryResponse.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(
          ServerFailure(
            categoryResponse.message.isNotEmpty
                ? categoryResponse.message
                : 'فشل تحميل الأقسام',
          ),
        );
      }

      return Right(categoryResponse.data);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ProductModel>>> getProducts({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await apiService.get(
        endPoint: 'products',
        queryParameters: queryParameters,
      );

      final productResponse = ProductResponseModel.fromJson(response.data);

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

      return Right(productResponse.data);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


