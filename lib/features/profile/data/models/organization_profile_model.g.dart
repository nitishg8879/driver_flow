// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationProfileModelImpl _$$OrganizationProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizationProfileModelImpl(
  id: json['id'] as String?,
  email: json['email'] as String?,
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
          ?.map((e) => $enumDecode(_$OrgWorkingDayEnumMap, e))
          .toList() ??
      const [],
  createdAt: const _TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const _TimestampConverter().fromJson(json['updatedAt']),
  workingHoursStart: const _TimestampConverter().fromJson(
    json['workingHoursStart'],
  ),
  workingHoursEnd: const _TimestampConverter().fromJson(
    json['workingHoursEnd'],
  ),
);

Map<String, dynamic> _$$OrganizationProfileModelImplToJson(
  _$OrganizationProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'organizationName': instance.organizationName,
  'phoneNumber': instance.phoneNumber,
  'websiteUrls': instance.websiteUrls,
  'aboutUs': instance.aboutUs,
  'workingDays': instance.workingDays
      ?.map((e) => _$OrgWorkingDayEnumMap[e]!)
      .toList(),
  'createdAt': const _TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const _TimestampConverter().toJson(instance.updatedAt),
  'workingHoursStart': const _TimestampConverter().toJson(
    instance.workingHoursStart,
  ),
  'workingHoursEnd': const _TimestampConverter().toJson(
    instance.workingHoursEnd,
  ),
};

const _$OrgWorkingDayEnumMap = {
  OrgWorkingDay.monday: 'monday',
  OrgWorkingDay.tuesday: 'tuesday',
  OrgWorkingDay.wednesday: 'wednesday',
  OrgWorkingDay.thursday: 'thursday',
  OrgWorkingDay.friday: 'friday',
  OrgWorkingDay.saturday: 'saturday',
  OrgWorkingDay.sunday: 'sunday',
  OrgWorkingDay.firstAndThirdSaturday: 'firstAndThirdSaturday',
  OrgWorkingDay.secondAndFourthSaturday: 'secondAndFourthSaturday',
  OrgWorkingDay.firstAndSecondSaturday: 'firstAndSecondSaturday',
  OrgWorkingDay.thirdAndFourthSaturday: 'thirdAndFourthSaturday',
};
