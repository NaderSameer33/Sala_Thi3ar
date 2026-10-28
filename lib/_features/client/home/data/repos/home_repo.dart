import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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
}
