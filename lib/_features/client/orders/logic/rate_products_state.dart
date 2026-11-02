import 'package:equatable/equatable.dart';

enum RateProductsStatus { initial, loading, success, error }

class RateProductsState extends Equatable {
  final RateProductsStatus status;
  final Map<int, int> ratings;
  final Map<int, String> comments;
  final String errorMessage;
  final String successMessage;

  const RateProductsState({
    this.status = RateProductsStatus.initial,
    this.ratings = const {},
    this.comments = const {},
    this.errorMessage = '',
    this.successMessage = '',
  });

  RateProductsState copyWith({
    RateProductsStatus? status,
    Map<int, int>? ratings,
    Map<int, String>? comments,
    String? errorMessage,
    String? successMessage,
  }) {
    return RateProductsState(
      status: status ?? this.status,
      ratings: ratings ?? this.ratings,
      comments: comments ?? this.comments,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        ratings,
        comments,
        errorMessage,
        successMessage,
      ];
}

