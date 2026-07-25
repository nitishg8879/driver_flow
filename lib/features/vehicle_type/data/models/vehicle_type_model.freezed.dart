// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleTypeModel _$VehicleTypeModelFromJson(Map<String, dynamic> json) {
  return _VehicleTypeModel.fromJson(json);
}

/// @nodoc
mixin _$VehicleTypeModel {
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VehicleTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleTypeModelCopyWith<VehicleTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleTypeModelCopyWith<$Res> {
  factory $VehicleTypeModelCopyWith(
    VehicleTypeModel value,
    $Res Function(VehicleTypeModel) then,
  ) = _$VehicleTypeModelCopyWithImpl<$Res, VehicleTypeModel>;
  @useResult
  $Res call({
    String? id,
    String name,
    String? imageUrl,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$VehicleTypeModelCopyWithImpl<$Res, $Val extends VehicleTypeModel>
    implements $VehicleTypeModelCopyWith<$Res> {
  _$VehicleTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleTypeModelImplCopyWith<$Res>
    implements $VehicleTypeModelCopyWith<$Res> {
  factory _$$VehicleTypeModelImplCopyWith(
    _$VehicleTypeModelImpl value,
    $Res Function(_$VehicleTypeModelImpl) then,
  ) = __$$VehicleTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String name,
    String? imageUrl,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$VehicleTypeModelImplCopyWithImpl<$Res>
    extends _$VehicleTypeModelCopyWithImpl<$Res, _$VehicleTypeModelImpl>
    implements _$$VehicleTypeModelImplCopyWith<$Res> {
  __$$VehicleTypeModelImplCopyWithImpl(
    _$VehicleTypeModelImpl _value,
    $Res Function(_$VehicleTypeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? imageUrl = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$VehicleTypeModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleTypeModelImpl implements _VehicleTypeModel {
  const _$VehicleTypeModelImpl({
    this.id,
    required this.name,
    this.imageUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory _$VehicleTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleTypeModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String name;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VehicleTypeModel(id: $id, name: $name, imageUrl: $imageUrl, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    imageUrl,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of VehicleTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleTypeModelImplCopyWith<_$VehicleTypeModelImpl> get copyWith =>
      __$$VehicleTypeModelImplCopyWithImpl<_$VehicleTypeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleTypeModelImplToJson(this);
  }
}

abstract class _VehicleTypeModel implements VehicleTypeModel {
  const factory _VehicleTypeModel({
    final String? id,
    required final String name,
    final String? imageUrl,
    final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$VehicleTypeModelImpl;

  factory _VehicleTypeModel.fromJson(Map<String, dynamic> json) =
      _$VehicleTypeModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get name;
  @override
  String? get imageUrl;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of VehicleTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleTypeModelImplCopyWith<_$VehicleTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
