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
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
