import 'package:driver_flow_admin/core/models/date_time_converter.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_profile_model.freezed.dart';
part 'organization_profile_model.g.dart';

@freezed
class OrganizationProfileModel with _$OrganizationProfileModel {
  const factory OrganizationProfileModel({
    String? id,
    String? email,
    String? organizationName,
    String? phoneNumber,
    String? aboutUs,
    @Default([]) List<OrgWorkingDay>? workingDays,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @TimeOfDayConverter() TimeOfDay? officeStartTime,
    @TimeOfDayConverter() TimeOfDay? officeEndTime,
    @TimeOfDayConverter() TimeOfDay? vechileStartTime,
    @TimeOfDayConverter() TimeOfDay? vechileEndTime,
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
