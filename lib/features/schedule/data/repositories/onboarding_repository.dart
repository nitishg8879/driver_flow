import 'package:driver_flow_admin/features/schedule/data/models/onboarding_form_data.dart';

abstract class OnboardingRepository {
  Future<void> submitOnboarding(OnboardingFormData formData);
  Future<List<String>> getAvailableVehicleTypes();
}

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  Future<void> submitOnboarding(OnboardingFormData formData) async {
    // TODO: Implement Firebase Firestore save
    // For now, just simulate a delay
    await Future.delayed(const Duration(seconds: 1));
    // In production:
    // await FirebaseFirestore.instance
    //     .collection('onboarding_submissions')
    //     .add(formData.toJson());
  }

  @override
  Future<List<String>> getAvailableVehicleTypes() async {
    // Mock data - replace with Firestore fetch
    return [
      'Manual Transmission',
      'Automatic Transmission',
      'Semi-Automatic Transmission',
    ];
  }
}
