import 'package:driver_flow_admin/features/vehicle_type/data/models/vehicle_type_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_form_data.freezed.dart';
part 'onboarding_form_data.g.dart';

@freezed
class OnboardingFormData with _$OnboardingFormData {
  const factory OnboardingFormData({
    // Step 1: Personal Info
    String? fullName,
    String? phoneNumber,
    String? email,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    // Step 2: Training & Schedule
    VehicleTypeModel? vehicleType,
    int? sessionsCount,
    int? sessionDuration,
    double? pricePerSession,
    DateTime? courseStartDate,
    String? recurrence,
    // Step 3: Documents & Payment
    List<String>? documentUrls,
    int? installmentsCount,
    List<InstallmentDetail>? installments,
  }) = _OnboardingFormData;
}

@freezed
class InstallmentDetail with _$InstallmentDetail {
  const factory InstallmentDetail({
    int? index,
    DateTime? dueDate,
    double? amount,
  }) = _InstallmentDetail;

  factory InstallmentDetail.fromJson(Map<String, dynamic> json) =>
      _$InstallmentDetailFromJson(json);
}
