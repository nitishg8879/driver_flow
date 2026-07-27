// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HolidayModelImpl _$$HolidayModelImplFromJson(Map<String, dynamic> json) =>
    _$HolidayModelImpl(
      id: json['id'] as String?,
      label: json['label'] as String?,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      isHalfDay: json['isHalfDay'] as bool? ?? false,
      createdAt: const _TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const _TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$HolidayModelImplToJson(_$HolidayModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'date': instance.date?.toIso8601String(),
      'isHalfDay': instance.isHalfDay,
      'createdAt': const _TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const _TimestampConverter().toJson(instance.updatedAt),
    };
