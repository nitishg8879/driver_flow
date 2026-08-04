import 'package:driver_flow_admin/features/schedule/data/models/onboarding_form_data.dart';
import 'package:driver_flow_admin/features/schedule/data/repositories/onboarding_repository.dart';
import 'package:driver_flow_admin/features/vehicle_type/data/models/vehicle_type_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../cubit/onboarding_state.dart';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final OnboardingRepository repository;
  static const int totalSteps = 3;

  OnboardingNotifier({required this.repository})
    : super(const OnboardingState.initial());

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
    required VehicleTypeModel vehicleType,
    required int sessionsCount,
    required double pricePerSession,
    required int sessionDuration,
    required DateTime startDate,
    required String recurrence,
  }) {
    final updatedData = (state.formData).copyWith(
      vehicleType: vehicleType,
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
      initial: (_) => state = OnboardingState.initial(
        currentStep: step,
        formData: formData,
      ),
      loading: (_) => state = OnboardingState.loading(
        currentStep: step,
        formData: formData,
      ),
      loaded: (_) =>
          state = OnboardingState.loaded(currentStep: step, formData: formData),
      success: (_) => state = OnboardingState.success(
        currentStep: step,
        formData: formData,
      ),
      error: (s) => state = OnboardingState.error(
        s.message,
        currentStep: step,
        formData: formData,
      ),
      orElse: () {},
    );
  }

  Future<void> submitOnboarding(OnboardingFormData formData) async {
    try {
      state = OnboardingState.loading(
        currentStep: state.currentStep,
        formData: formData,
      );
      await repository.submitOnboarding(formData);
      state = OnboardingState.success(
        currentStep: state.currentStep,
        formData: formData,
      );
    } catch (e) {
      state = OnboardingState.error(
        e.toString(),
        currentStep: state.currentStep,
        formData: formData,
      );
    }
  }

  void reset() {
    state = const OnboardingState.initial();
  }
}
