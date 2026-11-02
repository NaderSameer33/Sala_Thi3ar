import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final bool isSubmitting;

  const OnboardingState({
    this.currentPage = 0,
    this.isSubmitting = false,
  });

  bool get isLastPage => currentPage == 2;

  OnboardingState copyWith({
    int? currentPage,
    bool? isSubmitting,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [currentPage, isSubmitting];
}
