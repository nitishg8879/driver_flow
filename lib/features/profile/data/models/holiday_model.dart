import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'holiday_model.freezed.dart';
part 'holiday_model.g.dart';

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
class HolidayModel with _$HolidayModel {
  const factory HolidayModel({
    String? id,
    String? label,
    DateTime? date,
    @Default(false) bool? isHalfDay,
    @_TimestampConverter() DateTime? createdAt,
    @_TimestampConverter() DateTime? updatedAt,
  }) = _HolidayModel;

  factory HolidayModel.fromJson(Map<String, dynamic> json) =>
      _$HolidayModelFromJson(json);
}
