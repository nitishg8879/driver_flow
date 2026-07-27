// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationProfileModelImpl _$$OrganizationProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizationProfileModelImpl(
  id: json['id'] as String?,
  organizationName: json['organizationName'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  websiteUrls:
      (json['websiteUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  aboutUs: json['aboutUs'] as String?,
  workingDays:
      (json['workingDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isHolidayToday: json['isHolidayToday'] as bool? ?? false,
  isHalfDayToday: json['isHalfDayToday'] as bool? ?? false,
  createdAt: const _TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const _TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$$OrganizationProfileModelImplToJson(
  _$OrganizationProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'organizationName': instance.organizationName,
  'phoneNumber': instance.phoneNumber,
  'websiteUrls': instance.websiteUrls,
  'aboutUs': instance.aboutUs,
  'workingDays': instance.workingDays,
  'isHolidayToday': instance.isHolidayToday,
  'isHalfDayToday': instance.isHalfDayToday,
  'createdAt': const _TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const _TimestampConverter().toJson(instance.updatedAt),
};
