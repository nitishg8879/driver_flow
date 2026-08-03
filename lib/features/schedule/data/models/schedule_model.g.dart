// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleModelImpl _$$ScheduleModelImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleModelImpl(
      id: json['id'] as String?,
      studentId: json['studentId'] as String?,
      studentName: json['studentName'] as String?,
      instructorId: json['instructorId'] as String?,
      vehicleId: json['vehicleId'] as String?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      status:
          $enumDecodeNullable(_$ScheduleStatusEnumMap, json['status']) ??
          ScheduleStatus.scheduled,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ScheduleModelImplToJson(_$ScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'instructorId': instance.instructorId,
      'vehicleId': instance.vehicleId,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'status': _$ScheduleStatusEnumMap[instance.status]!,
      'notes': instance.notes,
    };

const _$ScheduleStatusEnumMap = {
  ScheduleStatus.scheduled: 'scheduled',
  ScheduleStatus.completed: 'completed',
  ScheduleStatus.cancelledByInstructor: 'cancelledByInstructor',
  ScheduleStatus.cancelledByStudent: 'cancelledByStudent',
  ScheduleStatus.adminCancelled: 'adminCancelled',
};
