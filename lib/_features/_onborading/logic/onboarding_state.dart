import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final bool isSubmitting;

  const OnboardingState({
    this.isSubmitting = false,
  });

  OnboardingState copyWith({
    bool? isSubmitting,
  }) {
    return OnboardingState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [isSubmitting];
}
