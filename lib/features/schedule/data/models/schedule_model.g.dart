// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleModelImpl _$$ScheduleModelImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleModelImpl(
      id: json['id'] as String?,
      studentId: json['studentId'] as String?,
      instructorId: json['instructorId'] as String?,
      vehicleId: json['vehicleId'] as String?,
      studentName: json['studentName'] as String?,
      instructorName: json['instructorName'] as String?,
      startTime: const TimestampConverter().fromJson(json['startTime']),
      endTime: const TimestampConverter().fromJson(json['endTime']),
      status:
          $enumDecodeNullable(_$ScheduleStatusEnumMap, json['status']) ??
          ScheduleStatus.scheduled,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ScheduleModelImplToJson(_$ScheduleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'instructorId': instance.instructorId,
      'vehicleId': instance.vehicleId,
      'studentName': instance.studentName,
      'instructorName': instance.instructorName,
      'startTime': const TimestampConverter().toJson(instance.startTime),
      'endTime': const TimestampConverter().toJson(instance.endTime),
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
