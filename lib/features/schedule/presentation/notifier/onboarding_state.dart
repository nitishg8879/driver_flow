import '../../data/models/onboarding_form_data.dart';

enum OnboardingStatus { idle, loading, success, error }

class OnboardingState {
  final int currentStep;
  final OnboardingFormData formData;
  final OnboardingStatus status;
  final String? error;

  static const int totalSteps = 3;

  const OnboardingState({
    this.currentStep = 0,
    this.formData = const OnboardingFormData(),
    this.status = OnboardingStatus.idle,
    this.error,
  });

  OnboardingState copyWith({
    int? currentStep,
    OnboardingFormData? formData,
    OnboardingStatus? status,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      formData: formData ?? this.formData,
      status: status ?? this.status,
      error: error,
    );
  }

  bool get isLoading => status == OnboardingStatus.loading;
  bool get isSuccess => status == OnboardingStatus.success;
  bool get hasError => status == OnboardingStatus.error;
}
