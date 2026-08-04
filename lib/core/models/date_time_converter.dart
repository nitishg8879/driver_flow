import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

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

class TimeOfDayConverter implements JsonConverter<TimeOfDay?, dynamic> {
  const TimeOfDayConverter();

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
