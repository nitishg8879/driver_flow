import 'package:driver_flow_admin/core/di/service_locator.dart';
import 'package:driver_flow_admin/features/schedule/data/repositories/onboarding_repository.dart';
import 'package:driver_flow_admin/features/schedule/presentation/notifier/onboarding_notifier.dart';
import 'package:driver_flow_admin/features/schedule/presentation/cubit/onboarding_state.dart';
import 'package:driver_flow_admin/features/schedule/data/models/onboarding_form_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return sl<OnboardingRepository>();
});

final onboardingStateProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
      final repository = ref.watch(onboardingRepositoryProvider);
      return OnboardingNotifier(repository: repository);
    });

// Convenience getters for commonly accessed state properties
final onboardingCurrentStepProvider = Provider<int>((ref) {
  return ref.watch(onboardingStateProvider).currentStep;
});

final onboardingFormDataProvider = Provider<OnboardingFormData>((ref) {
  return ref.watch(onboardingStateProvider).formData;
});

final onboardingIsLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(onboardingStateProvider);
  return state is OnboardingLoading;
});

final onboardingErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(onboardingStateProvider);
  if (state is OnboardingError) {
    return state.message;
  }
  return null;
});

final onboardingIsSuccessProvider = Provider<bool>((ref) {
  return ref.watch(onboardingStateProvider) is OnboardingSuccess;
});
