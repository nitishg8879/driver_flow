// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleTypeModelImpl _$$VehicleTypeModelImplFromJson(
  Map<String, dynamic> json,
) => _$VehicleTypeModelImpl(
  id: json['id'] as String?,
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
  numberOfSessions: (json['numberOfSessions'] as num?)?.toInt() ?? 0,
  sessionDurationMinutes:
      (json['sessionDurationMinutes'] as num?)?.toInt() ?? 0,
  pricePerSession: json['pricePerSession'] as num? ?? 0,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$VehicleTypeModelImplToJson(
  _$VehicleTypeModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'numberOfSessions': instance.numberOfSessions,
  'sessionDurationMinutes': instance.sessionDurationMinutes,
  'pricePerSession': instance.pricePerSession,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
