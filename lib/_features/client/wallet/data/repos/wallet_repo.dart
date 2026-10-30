import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/charge_wallet_request_body.dart';
import '../models/wallet_response_model.dart';
import '../models/wallet_transaction_model.dart';

class WalletRepo {
  final ApiService apiService;

  WalletRepo(this.apiService);

  Future<Either<Failure, WalletResponseModel>> getWallet() async {
    try {
      final response = await apiService.get(
        endPoint: 'wallet',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تحميل بيانات المحفظة'),
          );
        }
        final model = WalletResponseModel.fromJson(data);
        return Right(model);
      }

      return Left(ServerFailure('تعذر تحميل بيانات المحفظة'));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<WalletTransactionModel>>> getWalletTransactions() async {
    try {
      final response = await apiService.get(
        endPoint: 'wallet/get_wallet_transactions',
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل تحميل سجل المعاملات'),
          );
        }
        final rawList = data['data'];
        if (rawList is List) {
          final transactions = rawList
              .map((item) => WalletTransactionModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return Right(transactions);
        }
      }

      return const Right([]);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> chargeWallet(
    ChargeWalletRequestBody body,
  ) async {
    try {
      final response = await apiService.post(
        endPoint: 'wallet/charge',
        data: body.toFormData(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['status'] == 'fail') {
          return Left(
            ServerFailure(data['message']?.toString() ?? 'فشل شحن المحفظة'),
          );
        }
        return Right(data['message']?.toString() ?? 'تم شحن المحفظة بنجاح');
      }

      return const Right('تم شحن المحفظة بنجاح');
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

