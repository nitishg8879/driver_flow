import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/onboarding_form_data.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial({
    @Default(0) int currentStep,
    @Default(null) OnboardingFormData? formData,
  }) = OnboardingInitial;
  const factory OnboardingState.loading({
    @Default(0) int currentStep,
    @Default(null) OnboardingFormData? formData,
  }) = OnboardingLoading;
  const factory OnboardingState.loaded({
    @Default(0) int currentStep,
    @Default(null) OnboardingFormData? formData,
  }) = OnboardingLoaded;
  const factory OnboardingState.success({
    @Default(0) int currentStep,
    @Default(null) OnboardingFormData? formData,
  }) = OnboardingSuccess;
  const factory OnboardingState.error(
    String message, {
    @Default(0) int currentStep,
    @Default(null) OnboardingFormData? formData,
  }) = OnboardingError;
}
