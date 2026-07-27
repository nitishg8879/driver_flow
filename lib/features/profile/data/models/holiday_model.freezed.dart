// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holiday_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HolidayModel _$HolidayModelFromJson(Map<String, dynamic> json) {
  return _HolidayModel.fromJson(json);
}

/// @nodoc
mixin _$HolidayModel {
  String? get id => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  bool? get isHalfDay => throw _privateConstructorUsedError;
  @_TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @_TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this HolidayModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HolidayModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HolidayModelCopyWith<HolidayModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HolidayModelCopyWith<$Res> {
  factory $HolidayModelCopyWith(
    HolidayModel value,
    $Res Function(HolidayModel) then,
  ) = _$HolidayModelCopyWithImpl<$Res, HolidayModel>;
  @useResult
  $Res call({
    String? id,
    String? label,
    DateTime? date,
    bool? isHalfDay,
    @_TimestampConverter() DateTime? createdAt,
    @_TimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class _$HolidayModelCopyWithImpl<$Res, $Val extends HolidayModel>
    implements $HolidayModelCopyWith<$Res> {
  _$HolidayModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HolidayModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? label = freezed,
    Object? date = freezed,
    Object? isHalfDay = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isHalfDay: freezed == isHalfDay
                ? _value.isHalfDay
                : isHalfDay // ignore: cast_nullable_to_non_nullable
                      as bool?,
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
abstract class _$$HolidayModelImplCopyWith<$Res>
    implements $HolidayModelCopyWith<$Res> {
  factory _$$HolidayModelImplCopyWith(
    _$HolidayModelImpl value,
    $Res Function(_$HolidayModelImpl) then,
  ) = __$$HolidayModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? label,
    DateTime? date,
    bool? isHalfDay,
    @_TimestampConverter() DateTime? createdAt,
    @_TimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class __$$HolidayModelImplCopyWithImpl<$Res>
    extends _$HolidayModelCopyWithImpl<$Res, _$HolidayModelImpl>
    implements _$$HolidayModelImplCopyWith<$Res> {
  __$$HolidayModelImplCopyWithImpl(
    _$HolidayModelImpl _value,
    $Res Function(_$HolidayModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HolidayModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? label = freezed,
    Object? date = freezed,
    Object? isHalfDay = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$HolidayModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isHalfDay: freezed == isHalfDay
            ? _value.isHalfDay
            : isHalfDay // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
class _$HolidayModelImpl implements _HolidayModel {
  const _$HolidayModelImpl({
    this.id,
    this.label,
    this.date,
    this.isHalfDay = false,
    @_TimestampConverter() this.createdAt,
    @_TimestampConverter() this.updatedAt,
  });

  factory _$HolidayModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HolidayModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? label;
  @override
  final DateTime? date;
  @override
  @JsonKey()
  final bool? isHalfDay;
  @override
  @_TimestampConverter()
  final DateTime? createdAt;
  @override
  @_TimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'HolidayModel(id: $id, label: $label, date: $date, isHalfDay: $isHalfDay, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HolidayModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.isHalfDay, isHalfDay) ||
                other.isHalfDay == isHalfDay) &&
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
    label,
    date,
    isHalfDay,
    createdAt,
    updatedAt,
  );

  /// Create a copy of HolidayModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HolidayModelImplCopyWith<_$HolidayModelImpl> get copyWith =>
      __$$HolidayModelImplCopyWithImpl<_$HolidayModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HolidayModelImplToJson(this);
  }
}

abstract class _HolidayModel implements HolidayModel {
  const factory _HolidayModel({
    final String? id,
    final String? label,
    final DateTime? date,
    final bool? isHalfDay,
    @_TimestampConverter() final DateTime? createdAt,
    @_TimestampConverter() final DateTime? updatedAt,
  }) = _$HolidayModelImpl;

  factory _HolidayModel.fromJson(Map<String, dynamic> json) =
      _$HolidayModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get label;
  @override
  DateTime? get date;
  @override
  bool? get isHalfDay;
  @override
  @_TimestampConverter()
  DateTime? get createdAt;
  @override
  @_TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of HolidayModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HolidayModelImplCopyWith<_$HolidayModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
