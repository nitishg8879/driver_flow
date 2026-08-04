// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrganizationProfileModel _$OrganizationProfileModelFromJson(
  Map<String, dynamic> json,
) {
  return _OrganizationProfileModel.fromJson(json);
}

/// @nodoc
mixin _$OrganizationProfileModel {
  String? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get organizationName => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get aboutUs => throw _privateConstructorUsedError;
  List<OrgWorkingDay>? get workingDays => throw _privateConstructorUsedError;
  @_TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @_TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @_TimeOfDayConverter()
  TimeOfDay? get officeStartTime => throw _privateConstructorUsedError;
  @_TimeOfDayConverter()
  TimeOfDay? get officeEndTime => throw _privateConstructorUsedError;
  @_TimeOfDayConverter()
  TimeOfDay? get vechileStartTime => throw _privateConstructorUsedError;
  @_TimeOfDayConverter()
  TimeOfDay? get vechileEndTime => throw _privateConstructorUsedError;

  /// Serializes this OrganizationProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrganizationProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizationProfileModelCopyWith<OrganizationProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationProfileModelCopyWith<$Res> {
  factory $OrganizationProfileModelCopyWith(
    OrganizationProfileModel value,
    $Res Function(OrganizationProfileModel) then,
  ) = _$OrganizationProfileModelCopyWithImpl<$Res, OrganizationProfileModel>;
  @useResult
  $Res call({
    String? id,
    String? email,
    String? organizationName,
    String? phoneNumber,
    String? aboutUs,
    List<OrgWorkingDay>? workingDays,
    @_TimestampConverter() DateTime? createdAt,
    @_TimestampConverter() DateTime? updatedAt,
    @_TimeOfDayConverter() TimeOfDay? officeStartTime,
    @_TimeOfDayConverter() TimeOfDay? officeEndTime,
    @_TimeOfDayConverter() TimeOfDay? vechileStartTime,
    @_TimeOfDayConverter() TimeOfDay? vechileEndTime,
  });
}

/// @nodoc
class _$OrganizationProfileModelCopyWithImpl<
  $Res,
  $Val extends OrganizationProfileModel
>
    implements $OrganizationProfileModelCopyWith<$Res> {
  _$OrganizationProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizationProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? organizationName = freezed,
    Object? phoneNumber = freezed,
    Object? aboutUs = freezed,
    Object? workingDays = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? officeStartTime = freezed,
    Object? officeEndTime = freezed,
    Object? vechileStartTime = freezed,
    Object? vechileEndTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            organizationName: freezed == organizationName
                ? _value.organizationName
                : organizationName // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            aboutUs: freezed == aboutUs
                ? _value.aboutUs
                : aboutUs // ignore: cast_nullable_to_non_nullable
                      as String?,
            workingDays: freezed == workingDays
                ? _value.workingDays
                : workingDays // ignore: cast_nullable_to_non_nullable
                      as List<OrgWorkingDay>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            officeStartTime: freezed == officeStartTime
                ? _value.officeStartTime
                : officeStartTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay?,
            officeEndTime: freezed == officeEndTime
                ? _value.officeEndTime
                : officeEndTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay?,
            vechileStartTime: freezed == vechileStartTime
                ? _value.vechileStartTime
                : vechileStartTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay?,
            vechileEndTime: freezed == vechileEndTime
                ? _value.vechileEndTime
                : vechileEndTime // ignore: cast_nullable_to_non_nullable
                      as TimeOfDay?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrganizationProfileModelImplCopyWith<$Res>
    implements $OrganizationProfileModelCopyWith<$Res> {
  factory _$$OrganizationProfileModelImplCopyWith(
    _$OrganizationProfileModelImpl value,
    $Res Function(_$OrganizationProfileModelImpl) then,
  ) = __$$OrganizationProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? email,
    String? organizationName,
    String? phoneNumber,
    String? aboutUs,
    List<OrgWorkingDay>? workingDays,
    @_TimestampConverter() DateTime? createdAt,
    @_TimestampConverter() DateTime? updatedAt,
    @_TimeOfDayConverter() TimeOfDay? officeStartTime,
    @_TimeOfDayConverter() TimeOfDay? officeEndTime,
    @_TimeOfDayConverter() TimeOfDay? vechileStartTime,
    @_TimeOfDayConverter() TimeOfDay? vechileEndTime,
  });
}

/// @nodoc
class __$$OrganizationProfileModelImplCopyWithImpl<$Res>
    extends
        _$OrganizationProfileModelCopyWithImpl<
          $Res,
          _$OrganizationProfileModelImpl
        >
    implements _$$OrganizationProfileModelImplCopyWith<$Res> {
  __$$OrganizationProfileModelImplCopyWithImpl(
    _$OrganizationProfileModelImpl _value,
    $Res Function(_$OrganizationProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrganizationProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? organizationName = freezed,
    Object? phoneNumber = freezed,
    Object? aboutUs = freezed,
    Object? workingDays = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? officeStartTime = freezed,
    Object? officeEndTime = freezed,
    Object? vechileStartTime = freezed,
    Object? vechileEndTime = freezed,
  }) {
    return _then(
      _$OrganizationProfileModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        organizationName: freezed == organizationName
            ? _value.organizationName
            : organizationName // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        aboutUs: freezed == aboutUs
            ? _value.aboutUs
            : aboutUs // ignore: cast_nullable_to_non_nullable
                  as String?,
        workingDays: freezed == workingDays
            ? _value._workingDays
            : workingDays // ignore: cast_nullable_to_non_nullable
                  as List<OrgWorkingDay>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        officeStartTime: freezed == officeStartTime
            ? _value.officeStartTime
            : officeStartTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay?,
        officeEndTime: freezed == officeEndTime
            ? _value.officeEndTime
            : officeEndTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay?,
        vechileStartTime: freezed == vechileStartTime
            ? _value.vechileStartTime
            : vechileStartTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay?,
        vechileEndTime: freezed == vechileEndTime
            ? _value.vechileEndTime
            : vechileEndTime // ignore: cast_nullable_to_non_nullable
                  as TimeOfDay?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizationProfileModelImpl implements _OrganizationProfileModel {
  const _$OrganizationProfileModelImpl({
    this.id,
    this.email,
    this.organizationName,
    this.phoneNumber,
    this.aboutUs,
    final List<OrgWorkingDay>? workingDays = const [],
    @_TimestampConverter() this.createdAt,
    @_TimestampConverter() this.updatedAt,
    @_TimeOfDayConverter() this.officeStartTime,
    @_TimeOfDayConverter() this.officeEndTime,
    @_TimeOfDayConverter() this.vechileStartTime,
    @_TimeOfDayConverter() this.vechileEndTime,
  }) : _workingDays = workingDays;

  factory _$OrganizationProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationProfileModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? email;
  @override
  final String? organizationName;
  @override
  final String? phoneNumber;
  @override
  final String? aboutUs;
  final List<OrgWorkingDay>? _workingDays;
  @override
  @JsonKey()
  List<OrgWorkingDay>? get workingDays {
    final value = _workingDays;
    if (value == null) return null;
    if (_workingDays is EqualUnmodifiableListView) return _workingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @_TimestampConverter()
  final DateTime? createdAt;
  @override
  @_TimestampConverter()
  final DateTime? updatedAt;
  @override
  @_TimeOfDayConverter()
  final TimeOfDay? officeStartTime;
  @override
  @_TimeOfDayConverter()
  final TimeOfDay? officeEndTime;
  @override
  @_TimeOfDayConverter()
  final TimeOfDay? vechileStartTime;
  @override
  @_TimeOfDayConverter()
  final TimeOfDay? vechileEndTime;

  @override
  String toString() {
    return 'OrganizationProfileModel(id: $id, email: $email, organizationName: $organizationName, phoneNumber: $phoneNumber, aboutUs: $aboutUs, workingDays: $workingDays, createdAt: $createdAt, updatedAt: $updatedAt, officeStartTime: $officeStartTime, officeEndTime: $officeEndTime, vechileStartTime: $vechileStartTime, vechileEndTime: $vechileEndTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.aboutUs, aboutUs) || other.aboutUs == aboutUs) &&
            const DeepCollectionEquality().equals(
              other._workingDays,
              _workingDays,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.officeStartTime, officeStartTime) ||
                other.officeStartTime == officeStartTime) &&
            (identical(other.officeEndTime, officeEndTime) ||
                other.officeEndTime == officeEndTime) &&
            (identical(other.vechileStartTime, vechileStartTime) ||
                other.vechileStartTime == vechileStartTime) &&
            (identical(other.vechileEndTime, vechileEndTime) ||
                other.vechileEndTime == vechileEndTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    organizationName,
    phoneNumber,
    aboutUs,
    const DeepCollectionEquality().hash(_workingDays),
    createdAt,
    updatedAt,
    officeStartTime,
    officeEndTime,
    vechileStartTime,
    vechileEndTime,
  );

  /// Create a copy of OrganizationProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationProfileModelImplCopyWith<_$OrganizationProfileModelImpl>
  get copyWith =>
      __$$OrganizationProfileModelImplCopyWithImpl<
        _$OrganizationProfileModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationProfileModelImplToJson(this);
  }
}

abstract class _OrganizationProfileModel implements OrganizationProfileModel {
  const factory _OrganizationProfileModel({
    final String? id,
    final String? email,
    final String? organizationName,
    final String? phoneNumber,
    final String? aboutUs,
    final List<OrgWorkingDay>? workingDays,
    @_TimestampConverter() final DateTime? createdAt,
    @_TimestampConverter() final DateTime? updatedAt,
    @_TimeOfDayConverter() final TimeOfDay? officeStartTime,
    @_TimeOfDayConverter() final TimeOfDay? officeEndTime,
    @_TimeOfDayConverter() final TimeOfDay? vechileStartTime,
    @_TimeOfDayConverter() final TimeOfDay? vechileEndTime,
  }) = _$OrganizationProfileModelImpl;

  factory _OrganizationProfileModel.fromJson(Map<String, dynamic> json) =
      _$OrganizationProfileModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get email;
  @override
  String? get organizationName;
  @override
  String? get phoneNumber;
  @override
  String? get aboutUs;
  @override
  List<OrgWorkingDay>? get workingDays;
  @override
  @_TimestampConverter()
  DateTime? get createdAt;
  @override
  @_TimestampConverter()
  DateTime? get updatedAt;
  @override
  @_TimeOfDayConverter()
  TimeOfDay? get officeStartTime;
  @override
  @_TimeOfDayConverter()
  TimeOfDay? get officeEndTime;
  @override
  @_TimeOfDayConverter()
  TimeOfDay? get vechileStartTime;
  @override
  @_TimeOfDayConverter()
  TimeOfDay? get vechileEndTime;

  /// Create a copy of OrganizationProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizationProfileModelImplCopyWith<_$OrganizationProfileModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
