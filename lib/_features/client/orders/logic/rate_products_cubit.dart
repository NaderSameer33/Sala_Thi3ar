import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/order_details_model.dart';
import '../data/repos/orders_repo.dart';
import 'rate_products_state.dart';

class RateProductsCubit extends Cubit<RateProductsState> {
  final OrdersRepo repo;

  RateProductsCubit(this.repo) : super(const RateProductsState());

  void init(List<OrderProductItemModel> products) {
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

  Future<void> submitRatings(List<OrderProductItemModel> products) async {
    emit(state.copyWith(status: RateProductsStatus.loading));

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
              status: RateProductsStatus.error,
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
        status: RateProductsStatus.success,
        successMessage: 'تم إرسال التقييم بنجاح',
      ),
    );
  }
}

