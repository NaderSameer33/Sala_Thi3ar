import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sala_thimar/_features/client/home/data/models/category_model.dart';
import 'package:sala_thimar/_features/client/home/data/models/product_model.dart';
import 'package:sala_thimar/_features/client/home/data/models/slider_model.dart';
import 'package:sala_thimar/core/errors/failure.dart';
import 'package:sala_thimar/core/services/api_service.dart';

/// Response model for the search endpoint
/// API: GET /search/?keyword=...
/// Response shape: { "status": "success", "data": { "search_result": [...] } }
class SearchResponseModel {
  final String status;
  final String message;
  final List<ProductModel> results;

  const SearchResponseModel({
    required this.status,
    required this.message,
    required this.results,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final list = data['search_result'] as List<dynamic>? ?? [];
    return SearchResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      results: list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HomeRepo {
  // ── Search ──────────────────────────────────────────────────────────────────

  Future<Either<Failure, List<ProductModel>>> search(String keyword) async {
    try {
      final response = await apiService.get(
        endPoint: 'search',
        queryParameters: {'keyword': keyword},
      );

      final searchResponse = SearchResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (searchResponse.status == 'fail' ||
          (response.statusCode != null &&
              (response.statusCode! < 200 || response.statusCode! >= 300))) {
        return Left(
          ServerFailure(
            searchResponse.message.isNotEmpty
                ? searchResponse.message
                : 'فشل البحث',
          ),
        );
      }

      return Right(searchResponse.results);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── END Search ──────────────────────────────────────────────────────────────
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


