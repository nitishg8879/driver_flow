import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_profile_model.freezed.dart';
part 'organization_profile_model.g.dart';

class _TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const _TimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is DateTime) return json;
    if (json is String) return DateTime.tryParse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return null;
  }

  @override
  dynamic toJson(DateTime? object) => object;
}

// Stores TimeOfDay as {"hour": int, "minute": int} in Firestore.
class _TimeOfDayConverter implements JsonConverter<TimeOfDay?, dynamic> {
  const _TimeOfDayConverter();

  @override
  TimeOfDay? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Map) {
      return TimeOfDay(
        hour: (json['hour'] as num).toInt(),
        minute: (json['minute'] as num).toInt(),
      );
    }
    return null;
  }

  @override
  dynamic toJson(TimeOfDay? object) {
    if (object == null) return null;
    return {'hour': object.hour, 'minute': object.minute};
  }
}

@freezed
class OrganizationProfileModel with _$OrganizationProfileModel {
  const factory OrganizationProfileModel({
    String? id,
    String? email,
    String? organizationName,
    String? phoneNumber,
    String? aboutUs,
    @Default([]) List<OrgWorkingDay>? workingDays,
    @_TimestampConverter() DateTime? createdAt,
    @_TimestampConverter() DateTime? updatedAt,
    @_TimeOfDayConverter() TimeOfDay? officeStartTime,
    @_TimeOfDayConverter() TimeOfDay? officeEndTime,
    @_TimeOfDayConverter() TimeOfDay? vechileStartTime,
    @_TimeOfDayConverter() TimeOfDay? vechileEndTime,
  }) = _OrganizationProfileModel;

  factory OrganizationProfileModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationProfileModelFromJson(json);
}

enum OrgWorkingDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
  firstAndThirdSaturday,
  secondAndFourthSaturday,
  firstAndSecondSaturday,
  thirdAndFourthSaturday;

  String get displayName {
    switch (this) {
      case OrgWorkingDay.monday:
        return 'Monday';
      case OrgWorkingDay.tuesday:
        return 'Tuesday';
      case OrgWorkingDay.wednesday:
        return 'Wednesday';
      case OrgWorkingDay.thursday:
        return 'Thursday';
      case OrgWorkingDay.friday:
        return 'Friday';
      case OrgWorkingDay.saturday:
        return 'Saturday';
      case OrgWorkingDay.sunday:
        return 'Sunday';
      case OrgWorkingDay.firstAndThirdSaturday:
        return '1st & 3rd Saturday';
      case OrgWorkingDay.secondAndFourthSaturday:
        return '2nd & 4th Saturday';
      case OrgWorkingDay.firstAndSecondSaturday:
        return '1st & 2nd Saturday';
      case OrgWorkingDay.thirdAndFourthSaturday:
        return '3rd & 4th Saturday';
    }
  }
}
