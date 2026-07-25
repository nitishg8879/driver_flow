// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleModelImpl _$$ScheduleModelImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleModelImpl(
      id: json['id'] as String?,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      instructorId: json['instructorId'] as String,
      instructorName: json['instructorName'] as String,
      vehicleId: json['vehicleId'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status:
          $enumDecodeNullable(_$ScheduleStatusEnumMap, json['status']) ??
          ScheduleStatus.scheduled,
      reason: json['reason'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ScheduleModelImplToJson(_$ScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'instructorId': instance.instructorId,
      'instructorName': instance.instructorName,
      'vehicleId': instance.vehicleId,
      'vehicleNumber': instance.vehicleNumber,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'status': _$ScheduleStatusEnumMap[instance.status]!,
      'reason': instance.reason,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ScheduleStatusEnumMap = {
  ScheduleStatus.scheduled: 'scheduled',
  ScheduleStatus.completed: 'completed',
  ScheduleStatus.cancelledByInstructor: 'cancelledByInstructor',
  ScheduleStatus.cancelledByStudent: 'cancelledByStudent',
  ScheduleStatus.adminCancelled: 'adminCancelled',
};
