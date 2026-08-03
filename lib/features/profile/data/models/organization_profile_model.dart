import 'package:cloud_firestore/cloud_firestore.dart';
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

@freezed
class OrganizationProfileModel with _$OrganizationProfileModel {
  const factory OrganizationProfileModel({
    String? id,
    String? email,
    String? organizationName,
    String? phoneNumber,
    @Default([]) List<String>? websiteUrls,
    String? aboutUs,
    @Default([]) List<OrgWorkingDay>? workingDays,
    // @Default(false) bool? isHolidayToday,
    // @Default(false) bool? isHalfDayToday,
    @_TimestampConverter() DateTime? createdAt,
    @_TimestampConverter() DateTime? updatedAt,
    @_TimestampConverter() DateTime? workingHoursStart,
    @_TimestampConverter() DateTime? workingHoursEnd,
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
