// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) {
  return _VehicleModel.fromJson(json);
}

/// @nodoc
mixin _$VehicleModel {
  String? get id => throw _privateConstructorUsedError;
  String get vehicleNumber => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String? get vehicleTypeId => throw _privateConstructorUsedError;
  String? get vehicleTypeName => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VehicleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleModelCopyWith<VehicleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleModelCopyWith<$Res> {
  factory $VehicleModelCopyWith(
    VehicleModel value,
    $Res Function(VehicleModel) then,
  ) = _$VehicleModelCopyWithImpl<$Res, VehicleModel>;
  @useResult
  $Res call({
    String? id,
    String vehicleNumber,
    String model,
    String? vehicleTypeId,
    String? vehicleTypeName,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$VehicleModelCopyWithImpl<$Res, $Val extends VehicleModel>
    implements $VehicleModelCopyWith<$Res> {
  _$VehicleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? vehicleNumber = null,
    Object? model = null,
    Object? vehicleTypeId = freezed,
    Object? vehicleTypeName = freezed,
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
            vehicleNumber: null == vehicleNumber
                ? _value.vehicleNumber
                : vehicleNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            model: null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleTypeId: freezed == vehicleTypeId
                ? _value.vehicleTypeId
                : vehicleTypeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleTypeName: freezed == vehicleTypeName
                ? _value.vehicleTypeName
                : vehicleTypeName // ignore: cast_nullable_to_non_nullable
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
abstract class _$$VehicleModelImplCopyWith<$Res>
    implements $VehicleModelCopyWith<$Res> {
  factory _$$VehicleModelImplCopyWith(
    _$VehicleModelImpl value,
    $Res Function(_$VehicleModelImpl) then,
  ) = __$$VehicleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String vehicleNumber,
    String model,
    String? vehicleTypeId,
    String? vehicleTypeName,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$VehicleModelImplCopyWithImpl<$Res>
    extends _$VehicleModelCopyWithImpl<$Res, _$VehicleModelImpl>
    implements _$$VehicleModelImplCopyWith<$Res> {
  __$$VehicleModelImplCopyWithImpl(
    _$VehicleModelImpl _value,
    $Res Function(_$VehicleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? vehicleNumber = null,
    Object? model = null,
    Object? vehicleTypeId = freezed,
    Object? vehicleTypeName = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$VehicleModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleNumber: null == vehicleNumber
            ? _value.vehicleNumber
            : vehicleNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        model: null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleTypeId: freezed == vehicleTypeId
            ? _value.vehicleTypeId
            : vehicleTypeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleTypeName: freezed == vehicleTypeName
            ? _value.vehicleTypeName
            : vehicleTypeName // ignore: cast_nullable_to_non_nullable
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
class _$VehicleModelImpl implements _VehicleModel {
  const _$VehicleModelImpl({
    this.id,
    required this.vehicleNumber,
    required this.model,
    this.vehicleTypeId,
    this.vehicleTypeName,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory _$VehicleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String vehicleNumber;
  @override
  final String model;
  @override
  final String? vehicleTypeId;
  @override
  final String? vehicleTypeName;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VehicleModel(id: $id, vehicleNumber: $vehicleNumber, model: $model, vehicleTypeId: $vehicleTypeId, vehicleTypeName: $vehicleTypeName, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleNumber, vehicleNumber) ||
                other.vehicleNumber == vehicleNumber) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.vehicleTypeId, vehicleTypeId) ||
                other.vehicleTypeId == vehicleTypeId) &&
            (identical(other.vehicleTypeName, vehicleTypeName) ||
                other.vehicleTypeName == vehicleTypeName) &&
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
    vehicleNumber,
    model,
    vehicleTypeId,
    vehicleTypeName,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleModelImplCopyWith<_$VehicleModelImpl> get copyWith =>
      __$$VehicleModelImplCopyWithImpl<_$VehicleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleModelImplToJson(this);
  }
}

abstract class _VehicleModel implements VehicleModel {
  const factory _VehicleModel({
    final String? id,
    required final String vehicleNumber,
    required final String model,
    final String? vehicleTypeId,
    final String? vehicleTypeName,
    final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$VehicleModelImpl;

  factory _VehicleModel.fromJson(Map<String, dynamic> json) =
      _$VehicleModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get vehicleNumber;
  @override
  String get model;
  @override
  String? get vehicleTypeId;
  @override
  String? get vehicleTypeName;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleModelImplCopyWith<_$VehicleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
