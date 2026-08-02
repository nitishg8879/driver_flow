import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_form_data.freezed.dart';
part 'onboarding_form_data.g.dart';

@freezed
class OnboardingFormData with _$OnboardingFormData {
  const factory OnboardingFormData({
    // Step 1: Personal Info
    required String fullName,
    required String phoneNumber,
    required String email,
    required String streetAddress,
    required String city,
    required String state,
    required String zipCode,
    // Step 2: Training & Schedule
    required String vehicleType,
    required int sessionsCount,
    required int sessionDuration,
    required double pricePerSession,
    required DateTime courseStartDate,
    required String recurrence,
    // Step 3: Documents & Payment
    required List<String> documentUrls,
    required int installmentsCount,
    required List<InstallmentDetail> installments,
  }) = _OnboardingFormData;

  factory OnboardingFormData.fromJson(Map<String, dynamic> json) =>
      _$OnboardingFormDataFromJson(json);

  factory OnboardingFormData.empty() => OnboardingFormData(
    fullName: '',
    phoneNumber: '',
    email: '',
    streetAddress: '',
    city: '',
    state: '',
    zipCode: '',
    vehicleType: '',
    sessionsCount: 5,
    sessionDuration: 60,
    pricePerSession: 50.0,
    courseStartDate: DateTime.now(),
    recurrence: 'Weekly',
    documentUrls: [],
    installmentsCount: 1,
    installments: [InstallmentDetail(index: 0, dueDate: DateTime.now(), amount: 0.0)],
  );
}

@freezed
class InstallmentDetail with _$InstallmentDetail {
  const factory InstallmentDetail({
    required int index,
    required DateTime dueDate,
    required double amount,
  }) = _InstallmentDetail;

  factory InstallmentDetail.fromJson(Map<String, dynamic> json) =>
      _$InstallmentDetailFromJson(json);
}
