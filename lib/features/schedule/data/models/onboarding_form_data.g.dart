// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingFormDataImpl _$$OnboardingFormDataImplFromJson(
  Map<String, dynamic> json,
) => _$OnboardingFormDataImpl(
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  email: json['email'] as String,
  streetAddress: json['streetAddress'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  zipCode: json['zipCode'] as String,
  vehicleType: json['vehicleType'] as String,
  sessionsCount: (json['sessionsCount'] as num).toInt(),
  sessionDuration: (json['sessionDuration'] as num).toInt(),
  pricePerSession: (json['pricePerSession'] as num).toDouble(),
  courseStartDate: DateTime.parse(json['courseStartDate'] as String),
  recurrence: json['recurrence'] as String,
  documentUrls: (json['documentUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  installmentsCount: (json['installmentsCount'] as num).toInt(),
  installments: (json['installments'] as List<dynamic>)
      .map((e) => InstallmentDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$OnboardingFormDataImplToJson(
  _$OnboardingFormDataImpl instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'streetAddress': instance.streetAddress,
  'city': instance.city,
  'state': instance.state,
  'zipCode': instance.zipCode,
  'vehicleType': instance.vehicleType,
  'sessionsCount': instance.sessionsCount,
  'sessionDuration': instance.sessionDuration,
  'pricePerSession': instance.pricePerSession,
  'courseStartDate': instance.courseStartDate.toIso8601String(),
  'recurrence': instance.recurrence,
  'documentUrls': instance.documentUrls,
  'installmentsCount': instance.installmentsCount,
  'installments': instance.installments,
};

_$InstallmentDetailImpl _$$InstallmentDetailImplFromJson(
  Map<String, dynamic> json,
) => _$InstallmentDetailImpl(
  index: (json['index'] as num).toInt(),
  dueDate: DateTime.parse(json['dueDate'] as String),
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$$InstallmentDetailImplToJson(
  _$InstallmentDetailImpl instance,
) => <String, dynamic>{
  'index': instance.index,
  'dueDate': instance.dueDate.toIso8601String(),
  'amount': instance.amount,
};
