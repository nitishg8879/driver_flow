// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentModelImpl _$$AttachmentModelImplFromJson(
  Map<String, dynamic> json,
) => _$AttachmentModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  url: json['url'] as String,
  storagePath: json['storagePath'] as String,
  fileType: $enumDecode(_$AttachmentFileTypeEnumMap, json['fileType']),
  source: $enumDecode(_$AttachmentSourceEnumMap, json['source']),
  ownerId: json['ownerId'] as String,
  uploadedBy: json['uploadedBy'] as String,
  uploadedAt: json['uploadedAt'] == null
      ? null
      : DateTime.parse(json['uploadedAt'] as String),
);

Map<String, dynamic> _$$AttachmentModelImplToJson(
  _$AttachmentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'url': instance.url,
  'storagePath': instance.storagePath,
  'fileType': _$AttachmentFileTypeEnumMap[instance.fileType]!,
  'source': _$AttachmentSourceEnumMap[instance.source]!,
  'ownerId': instance.ownerId,
  'uploadedBy': instance.uploadedBy,
  'uploadedAt': instance.uploadedAt?.toIso8601String(),
};

const _$AttachmentFileTypeEnumMap = {
  AttachmentFileType.drivingLicense: 'drivingLicense',
  AttachmentFileType.profilePhoto: 'profilePhoto',
  AttachmentFileType.document: 'document',
  AttachmentFileType.other: 'other',
};

const _$AttachmentSourceEnumMap = {
  AttachmentSource.student: 'student',
  AttachmentSource.instructor: 'instructor',
  AttachmentSource.payment: 'payment',
  AttachmentSource.vehicle: 'vehicle',
};
