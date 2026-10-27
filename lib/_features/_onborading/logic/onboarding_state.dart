import 'package:equatable/equatable.dart';

enum UserRole { client, driver }

class OnboardingState extends Equatable {
  final UserRole selectedRole;
  final bool isSubmitting;

  const OnboardingState({
    this.selectedRole = UserRole.client,
    this.isSubmitting = false,
  });

  OnboardingState copyWith({
    UserRole? selectedRole,
    bool? isSubmitting,
  }) {
    return OnboardingState(
      selectedRole: selectedRole ?? this.selectedRole,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [selectedRole, isSubmitting];
}
