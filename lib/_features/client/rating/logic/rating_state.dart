import 'package:equatable/equatable.dart';

enum RatingStatus { initial, loading, success, error }

class RatingState extends Equatable {
  final RatingStatus status;
  final Map<int, int> ratings;
  final Map<int, String> comments;
  final String errorMessage;
  final String successMessage;
  final bool isSubmittingSingle;

  const RatingState({
    this.status = RatingStatus.initial,
    this.ratings = const {},
    this.comments = const {},
    this.errorMessage = '',
    this.successMessage = '',
    this.isSubmittingSingle = false,
  });

  RatingState copyWith({
    RatingStatus? status,
    Map<int, int>? ratings,
    Map<int, String>? comments,
    String? errorMessage,
    String? successMessage,
    bool? isSubmittingSingle,
  }) {
    return RatingState(
      status: status ?? this.status,
      ratings: ratings ?? this.ratings,
      comments: comments ?? this.comments,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isSubmittingSingle: isSubmittingSingle ?? this.isSubmittingSingle,
    );
  }

  @override
  List<Object?> get props => [
        status,
        ratings,
        comments,
        errorMessage,
        successMessage,
        isSubmittingSingle,
      ];
}

