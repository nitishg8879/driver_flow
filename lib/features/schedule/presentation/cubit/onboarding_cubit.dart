import 'package:driver_flow_admin/features/schedule/data/repositories/onboarding_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/onboarding_form_data.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository repository;
  static const int totalSteps = 3;

  OnboardingCubit({required this.repository}) : super(const OnboardingState.initial());

  void nextStep() {
    final currentStep = state.currentStep;
    if (currentStep < totalSteps - 1) {
      _updateStep(currentStep + 1);
    }
  }

  void previousStep() {
    final currentStep = state.currentStep;
    if (currentStep > 0) {
      _updateStep(currentStep - 1);
    }
  }

  void updateFormData(OnboardingFormData formData) {
    _updateStep(state.currentStep, formData);
  }

  void updatePersonalInfo({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String streetAddress,
    required String states,
    required String city,
    required String zipCode,
  }) {
    final updatedData = state.formData.copyWith(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      streetAddress: streetAddress,
      state: states,
      city: city,
      zipCode: zipCode,
    );
    _updateStep(state.currentStep, updatedData);
    nextStep();
  }

  void updateTrainingScheduleInfo({
    required String vehicleTypeId,
    required int sessionsCount,
    required double pricePerSession,
    required int sessionDuration,
    required DateTime startDate,
    required String recurrence,
  }) {
    final updatedData = (state.formData).copyWith(
      vehicleTypeId: vehicleTypeId,
      sessionsCount: sessionsCount,
      pricePerSession: pricePerSession,
      sessionDuration: sessionDuration,
      courseStartDate: startDate,
      recurrence: recurrence,
    );
    _updateStep(state.currentStep, updatedData);
    nextStep();
  }

  Future<void> submit() async {
    await submitOnboarding(state.formData);
  }

  void _updateStep(int step, [OnboardingFormData? data]) {
    final formData = data ?? state.formData;
    state.maybeMap(
      initial: (_) => emit(OnboardingState.initial(currentStep: step, formData: formData)),
      loading: (_) => emit(OnboardingState.loading(currentStep: step, formData: formData)),
      loaded: (_) => emit(OnboardingState.loaded(currentStep: step, formData: formData)),
      success: (_) => emit(OnboardingState.success(currentStep: step, formData: formData)),
      error: (s) => emit(OnboardingState.error(s.message, currentStep: step, formData: formData)),
      orElse: () {},
    );
  }

  Future<void> submitOnboarding(OnboardingFormData formData) async {
    try {
      emit(OnboardingState.loading(currentStep: state.currentStep, formData: formData));
      await repository.submitOnboarding(formData);
      emit(OnboardingState.success(currentStep: state.currentStep, formData: formData));
    } catch (e) {
      emit(OnboardingState.error(e.toString(), currentStep: state.currentStep, formData: formData));
    }
  }

  void reset() {
    emit(const OnboardingState.initial());
  }
}
