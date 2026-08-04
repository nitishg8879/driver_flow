import 'package:driver_flow_admin/features/schedule/data/models/onboarding_form_data.dart';
import 'package:driver_flow_admin/features/vehicle_type/data/models/vehicle_type_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_notifier.g.dart';

@immutable
class OnboardingState {
  final int currentStep;
  final OnboardingFormData formData;
  final bool isSuccess;
  final String? error;

  const OnboardingState({
    this.currentStep = 0,
    this.formData = const OnboardingFormData(),
    this.isSuccess = false,
    this.error,
  });

  double get totalAmount =>
      (formData.pricePerSession ?? 0) * (formData.sessionsCount ?? 0);

  OnboardingState copyWith({
    int? currentStep,
    OnboardingFormData? formData,
    bool? isSuccess,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      formData: formData ?? this.formData,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  final steps = const <String>[
    'Personal Information',
    'Training Schedule',
    'Review & Submit',
  ];

  int get totalSteps => steps.length;

  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void nextStep() {
    if (state.currentStep < totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void updateFormData(OnboardingFormData formData) {
    state = state.copyWith(formData: formData);
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
    state = state.copyWith(
      formData: state.formData.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        streetAddress: streetAddress,
        state: states,
        city: city,
        zipCode: zipCode,
      ),
    );
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
    state = state.copyWith(
      formData: state.formData.copyWith(
        vehicleType: vehicleType,
        sessionsCount: sessionsCount,
        pricePerSession: pricePerSession,
        sessionDuration: sessionDuration,
        courseStartDate: startDate,
        recurrence: recurrence,
      ),
    );
    nextStep();
  }

  Future<void> submit() async {
    try {
      // TODO: inject repository via ref.watch in build()
      await Future.delayed(const Duration(seconds: 1)); // placeholder
      state = state.copyWith(isSuccess: true);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void reset() {
    state = const OnboardingState();
  }
}
