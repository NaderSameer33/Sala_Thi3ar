import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_thimar/_features/client/orders/data/models/order_details_model.dart';
import 'package:sala_thimar/_features/client/rating/data/repos/rating_repo.dart';
import 'package:sala_thimar/_features/client/rating/logic/rating_state.dart';
import 'package:sala_thimar/core/base/safe_cubit.dart';
import 'package:sala_thimar/core/errors/failure.dart';

class RatingCubit extends Cubit<RatingState> with SafeEmitMixin {
  final RatingRepo repo;

  RatingCubit(this.repo) : super(const RatingState());

  void initOrderProducts(List<OrderProductItemModel> products) {
    final initialRatings = <int, int>{};
    for (final p in products) {
      initialRatings[p.id] = 4;
    }
    emit(state.copyWith(ratings: initialRatings));
  }

  void updateRating(int productId, int rating) {
    final updated = Map<int, int>.from(state.ratings);
    updated[productId] = rating;
    emit(state.copyWith(ratings: updated));
  }

  void updateComment(int productId, String comment) {
    final updated = Map<int, String>.from(state.comments);
    updated[productId] = comment;
    emit(state.copyWith(comments: updated));
  }

  Future<void> submitOrderRatings(List<OrderProductItemModel> products) async {
    emit(state.copyWith(status: RatingStatus.loading));

    for (final product in products) {
      final rating = state.ratings[product.id] ?? 4;
      final comment = state.comments[product.id] ?? '';

      final result = await repo.rateProduct(
        productId: product.id,
        value: rating,
        comment: comment,
      );

      final failed = result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: RatingStatus.error,
              errorMessage: failure.message,
            ),
          );
          return true;
        },
        (_) => false,
      );

      if (failed) return;
    }

    emit(
      state.copyWith(
        status: RatingStatus.success,
        successMessage: 'تم إرسال التقييم بنجاح',
      ),
    );
  }

  Future<Either<Failure, String>> rateSingleProduct({
    required int productId,
    required int value,
    required String comment,
  }) async {
    emit(state.copyWith(isSubmittingSingle: true));
    final result = await repo.rateProduct(
      productId: productId,
      value: value,
      comment: comment,
    );
    emit(state.copyWith(isSubmittingSingle: false));
    return result;
  }
}
