// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) {
  return _AttachmentModel.fromJson(json);
}

/// @nodoc
mixin _$AttachmentModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get storagePath => throw _privateConstructorUsedError;
  AttachmentFileType get fileType => throw _privateConstructorUsedError;
  AttachmentSource get source => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get uploadedBy => throw _privateConstructorUsedError;
  DateTime? get uploadedAt => throw _privateConstructorUsedError;

  /// Serializes this AttachmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttachmentModelCopyWith<AttachmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentModelCopyWith<$Res> {
  factory $AttachmentModelCopyWith(
    AttachmentModel value,
    $Res Function(AttachmentModel) then,
  ) = _$AttachmentModelCopyWithImpl<$Res, AttachmentModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String url,
    String storagePath,
    AttachmentFileType fileType,
    AttachmentSource source,
    String ownerId,
    String uploadedBy,
    DateTime? uploadedAt,
  });
}

/// @nodoc
class _$AttachmentModelCopyWithImpl<$Res, $Val extends AttachmentModel>
    implements $AttachmentModelCopyWith<$Res> {
  _$AttachmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? storagePath = null,
    Object? fileType = null,
    Object? source = null,
    Object? ownerId = null,
    Object? uploadedBy = null,
    Object? uploadedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            storagePath: null == storagePath
                ? _value.storagePath
                : storagePath // ignore: cast_nullable_to_non_nullable
                      as String,
            fileType: null == fileType
                ? _value.fileType
                : fileType // ignore: cast_nullable_to_non_nullable
                      as AttachmentFileType,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as AttachmentSource,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            uploadedBy: null == uploadedBy
                ? _value.uploadedBy
                : uploadedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            uploadedAt: freezed == uploadedAt
                ? _value.uploadedAt
                : uploadedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttachmentModelImplCopyWith<$Res>
    implements $AttachmentModelCopyWith<$Res> {
  factory _$$AttachmentModelImplCopyWith(
    _$AttachmentModelImpl value,
    $Res Function(_$AttachmentModelImpl) then,
  ) = __$$AttachmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String url,
    String storagePath,
    AttachmentFileType fileType,
    AttachmentSource source,
    String ownerId,
    String uploadedBy,
    DateTime? uploadedAt,
  });
}

/// @nodoc
class __$$AttachmentModelImplCopyWithImpl<$Res>
    extends _$AttachmentModelCopyWithImpl<$Res, _$AttachmentModelImpl>
    implements _$$AttachmentModelImplCopyWith<$Res> {
  __$$AttachmentModelImplCopyWithImpl(
    _$AttachmentModelImpl _value,
    $Res Function(_$AttachmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? storagePath = null,
    Object? fileType = null,
    Object? source = null,
    Object? ownerId = null,
    Object? uploadedBy = null,
    Object? uploadedAt = freezed,
  }) {
    return _then(
      _$AttachmentModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        storagePath: null == storagePath
            ? _value.storagePath
            : storagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        fileType: null == fileType
            ? _value.fileType
            : fileType // ignore: cast_nullable_to_non_nullable
                  as AttachmentFileType,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as AttachmentSource,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        uploadedBy: null == uploadedBy
            ? _value.uploadedBy
            : uploadedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        uploadedAt: freezed == uploadedAt
            ? _value.uploadedAt
            : uploadedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentModelImpl implements _AttachmentModel {
  const _$AttachmentModelImpl({
    required this.id,
    required this.name,
    required this.url,
    required this.storagePath,
    required this.fileType,
    required this.source,
    required this.ownerId,
    required this.uploadedBy,
    this.uploadedAt,
  });

  factory _$AttachmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String url;
  @override
  final String storagePath;
  @override
  final AttachmentFileType fileType;
  @override
  final AttachmentSource source;
  @override
  final String ownerId;
  @override
  final String uploadedBy;
  @override
  final DateTime? uploadedAt;

  @override
  String toString() {
    return 'AttachmentModel(id: $id, name: $name, url: $url, storagePath: $storagePath, fileType: $fileType, source: $source, ownerId: $ownerId, uploadedBy: $uploadedBy, uploadedAt: $uploadedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    url,
    storagePath,
    fileType,
    source,
    ownerId,
    uploadedBy,
    uploadedAt,
  );

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentModelImplCopyWith<_$AttachmentModelImpl> get copyWith =>
      __$$AttachmentModelImplCopyWithImpl<_$AttachmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentModelImplToJson(this);
  }
}

abstract class _AttachmentModel implements AttachmentModel {
  const factory _AttachmentModel({
    required final String id,
    required final String name,
    required final String url,
    required final String storagePath,
    required final AttachmentFileType fileType,
    required final AttachmentSource source,
    required final String ownerId,
    required final String uploadedBy,
    final DateTime? uploadedAt,
  }) = _$AttachmentModelImpl;

  factory _AttachmentModel.fromJson(Map<String, dynamic> json) =
      _$AttachmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get url;
  @override
  String get storagePath;
  @override
  AttachmentFileType get fileType;
  @override
  AttachmentSource get source;
  @override
  String get ownerId;
  @override
  String get uploadedBy;
  @override
  DateTime? get uploadedAt;

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttachmentModelImplCopyWith<_$AttachmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
