// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OnboardingFormData {
  // Step 1: Personal Info
  String? get fullName => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get streetAddress => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get zipCode =>
      throw _privateConstructorUsedError; // Step 2: Training & Schedule
  VehicleTypeModel? get vehicleType => throw _privateConstructorUsedError;
  int? get sessionsCount => throw _privateConstructorUsedError;
  int? get sessionDuration => throw _privateConstructorUsedError;
  double? get pricePerSession => throw _privateConstructorUsedError;
  DateTime? get courseStartDate => throw _privateConstructorUsedError;
  String? get recurrence =>
      throw _privateConstructorUsedError; // Step 3: Documents & Payment
  List<String>? get documentUrls => throw _privateConstructorUsedError;
  int? get installmentsCount => throw _privateConstructorUsedError;
  List<InstallmentDetail>? get installments =>
      throw _privateConstructorUsedError;

  /// Create a copy of OnboardingFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingFormDataCopyWith<OnboardingFormData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingFormDataCopyWith<$Res> {
  factory $OnboardingFormDataCopyWith(
    OnboardingFormData value,
    $Res Function(OnboardingFormData) then,
  ) = _$OnboardingFormDataCopyWithImpl<$Res, OnboardingFormData>;
  @useResult
  $Res call({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    VehicleTypeModel? vehicleType,
    int? sessionsCount,
    int? sessionDuration,
    double? pricePerSession,
    DateTime? courseStartDate,
    String? recurrence,
    List<String>? documentUrls,
    int? installmentsCount,
    List<InstallmentDetail>? installments,
  });

  $VehicleTypeModelCopyWith<$Res>? get vehicleType;
}

/// @nodoc
class _$OnboardingFormDataCopyWithImpl<$Res, $Val extends OnboardingFormData>
    implements $OnboardingFormDataCopyWith<$Res> {
  _$OnboardingFormDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? streetAddress = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? zipCode = freezed,
    Object? vehicleType = freezed,
    Object? sessionsCount = freezed,
    Object? sessionDuration = freezed,
    Object? pricePerSession = freezed,
    Object? courseStartDate = freezed,
    Object? recurrence = freezed,
    Object? documentUrls = freezed,
    Object? installmentsCount = freezed,
    Object? installments = freezed,
  }) {
    return _then(
      _value.copyWith(
            fullName: freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            streetAddress: freezed == streetAddress
                ? _value.streetAddress
                : streetAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String?,
            zipCode: freezed == zipCode
                ? _value.zipCode
                : zipCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleType: freezed == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                      as VehicleTypeModel?,
            sessionsCount: freezed == sessionsCount
                ? _value.sessionsCount
                : sessionsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            sessionDuration: freezed == sessionDuration
                ? _value.sessionDuration
                : sessionDuration // ignore: cast_nullable_to_non_nullable
                      as int?,
            pricePerSession: freezed == pricePerSession
                ? _value.pricePerSession
                : pricePerSession // ignore: cast_nullable_to_non_nullable
                      as double?,
            courseStartDate: freezed == courseStartDate
                ? _value.courseStartDate
                : courseStartDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            recurrence: freezed == recurrence
                ? _value.recurrence
                : recurrence // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentUrls: freezed == documentUrls
                ? _value.documentUrls
                : documentUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            installmentsCount: freezed == installmentsCount
                ? _value.installmentsCount
                : installmentsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            installments: freezed == installments
                ? _value.installments
                : installments // ignore: cast_nullable_to_non_nullable
                      as List<InstallmentDetail>?,
          )
          as $Val,
    );
  }

  /// Create a copy of OnboardingFormData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleTypeModelCopyWith<$Res>? get vehicleType {
    if (_value.vehicleType == null) {
      return null;
    }

    return $VehicleTypeModelCopyWith<$Res>(_value.vehicleType!, (value) {
      return _then(_value.copyWith(vehicleType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnboardingFormDataImplCopyWith<$Res>
    implements $OnboardingFormDataCopyWith<$Res> {
  factory _$$OnboardingFormDataImplCopyWith(
    _$OnboardingFormDataImpl value,
    $Res Function(_$OnboardingFormDataImpl) then,
  ) = __$$OnboardingFormDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    VehicleTypeModel? vehicleType,
    int? sessionsCount,
    int? sessionDuration,
    double? pricePerSession,
    DateTime? courseStartDate,
    String? recurrence,
    List<String>? documentUrls,
    int? installmentsCount,
    List<InstallmentDetail>? installments,
  });

  @override
  $VehicleTypeModelCopyWith<$Res>? get vehicleType;
}

/// @nodoc
class __$$OnboardingFormDataImplCopyWithImpl<$Res>
    extends _$OnboardingFormDataCopyWithImpl<$Res, _$OnboardingFormDataImpl>
    implements _$$OnboardingFormDataImplCopyWith<$Res> {
  __$$OnboardingFormDataImplCopyWithImpl(
    _$OnboardingFormDataImpl _value,
    $Res Function(_$OnboardingFormDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? streetAddress = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? zipCode = freezed,
    Object? vehicleType = freezed,
    Object? sessionsCount = freezed,
    Object? sessionDuration = freezed,
    Object? pricePerSession = freezed,
    Object? courseStartDate = freezed,
    Object? recurrence = freezed,
    Object? documentUrls = freezed,
    Object? installmentsCount = freezed,
    Object? installments = freezed,
  }) {
    return _then(
      _$OnboardingFormDataImpl(
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        streetAddress: freezed == streetAddress
            ? _value.streetAddress
            : streetAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String?,
        zipCode: freezed == zipCode
            ? _value.zipCode
            : zipCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleType: freezed == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as VehicleTypeModel?,
        sessionsCount: freezed == sessionsCount
            ? _value.sessionsCount
            : sessionsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        sessionDuration: freezed == sessionDuration
            ? _value.sessionDuration
            : sessionDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
        pricePerSession: freezed == pricePerSession
            ? _value.pricePerSession
            : pricePerSession // ignore: cast_nullable_to_non_nullable
                  as double?,
        courseStartDate: freezed == courseStartDate
            ? _value.courseStartDate
            : courseStartDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        recurrence: freezed == recurrence
            ? _value.recurrence
            : recurrence // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentUrls: freezed == documentUrls
            ? _value._documentUrls
            : documentUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        installmentsCount: freezed == installmentsCount
            ? _value.installmentsCount
            : installmentsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        installments: freezed == installments
            ? _value._installments
            : installments // ignore: cast_nullable_to_non_nullable
                  as List<InstallmentDetail>?,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingFormDataImpl implements _OnboardingFormData {
  const _$OnboardingFormDataImpl({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.streetAddress,
    this.city,
    this.state,
    this.zipCode,
    this.vehicleType,
    this.sessionsCount,
    this.sessionDuration,
    this.pricePerSession,
    this.courseStartDate,
    this.recurrence,
    final List<String>? documentUrls,
    this.installmentsCount,
    final List<InstallmentDetail>? installments,
  }) : _documentUrls = documentUrls,
       _installments = installments;

  // Step 1: Personal Info
  @override
  final String? fullName;
  @override
  final String? phoneNumber;
  @override
  final String? email;
  @override
  final String? streetAddress;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? zipCode;
  // Step 2: Training & Schedule
  @override
  final VehicleTypeModel? vehicleType;
  @override
  final int? sessionsCount;
  @override
  final int? sessionDuration;
  @override
  final double? pricePerSession;
  @override
  final DateTime? courseStartDate;
  @override
  final String? recurrence;
  // Step 3: Documents & Payment
  final List<String>? _documentUrls;
  // Step 3: Documents & Payment
  @override
  List<String>? get documentUrls {
    final value = _documentUrls;
    if (value == null) return null;
    if (_documentUrls is EqualUnmodifiableListView) return _documentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? installmentsCount;
  final List<InstallmentDetail>? _installments;
  @override
  List<InstallmentDetail>? get installments {
    final value = _installments;
    if (value == null) return null;
    if (_installments is EqualUnmodifiableListView) return _installments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'OnboardingFormData(fullName: $fullName, phoneNumber: $phoneNumber, email: $email, streetAddress: $streetAddress, city: $city, state: $state, zipCode: $zipCode, vehicleType: $vehicleType, sessionsCount: $sessionsCount, sessionDuration: $sessionDuration, pricePerSession: $pricePerSession, courseStartDate: $courseStartDate, recurrence: $recurrence, documentUrls: $documentUrls, installmentsCount: $installmentsCount, installments: $installments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingFormDataImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.streetAddress, streetAddress) ||
                other.streetAddress == streetAddress) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.sessionsCount, sessionsCount) ||
                other.sessionsCount == sessionsCount) &&
            (identical(other.sessionDuration, sessionDuration) ||
                other.sessionDuration == sessionDuration) &&
            (identical(other.pricePerSession, pricePerSession) ||
                other.pricePerSession == pricePerSession) &&
            (identical(other.courseStartDate, courseStartDate) ||
                other.courseStartDate == courseStartDate) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            const DeepCollectionEquality().equals(
              other._documentUrls,
              _documentUrls,
            ) &&
            (identical(other.installmentsCount, installmentsCount) ||
                other.installmentsCount == installmentsCount) &&
            const DeepCollectionEquality().equals(
              other._installments,
              _installments,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    fullName,
    phoneNumber,
    email,
    streetAddress,
    city,
    state,
    zipCode,
    vehicleType,
    sessionsCount,
    sessionDuration,
    pricePerSession,
    courseStartDate,
    recurrence,
    const DeepCollectionEquality().hash(_documentUrls),
    installmentsCount,
    const DeepCollectionEquality().hash(_installments),
  );

  /// Create a copy of OnboardingFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingFormDataImplCopyWith<_$OnboardingFormDataImpl> get copyWith =>
      __$$OnboardingFormDataImplCopyWithImpl<_$OnboardingFormDataImpl>(
        this,
        _$identity,
      );
}

abstract class _OnboardingFormData implements OnboardingFormData {
  const factory _OnboardingFormData({
    final String? fullName,
    final String? phoneNumber,
    final String? email,
    final String? streetAddress,
    final String? city,
    final String? state,
    final String? zipCode,
    final VehicleTypeModel? vehicleType,
    final int? sessionsCount,
    final int? sessionDuration,
    final double? pricePerSession,
    final DateTime? courseStartDate,
    final String? recurrence,
    final List<String>? documentUrls,
    final int? installmentsCount,
    final List<InstallmentDetail>? installments,
  }) = _$OnboardingFormDataImpl;

  // Step 1: Personal Info
  @override
  String? get fullName;
  @override
  String? get phoneNumber;
  @override
  String? get email;
  @override
  String? get streetAddress;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get zipCode; // Step 2: Training & Schedule
  @override
  VehicleTypeModel? get vehicleType;
  @override
  int? get sessionsCount;
  @override
  int? get sessionDuration;
  @override
  double? get pricePerSession;
  @override
  DateTime? get courseStartDate;
  @override
  String? get recurrence; // Step 3: Documents & Payment
  @override
  List<String>? get documentUrls;
  @override
  int? get installmentsCount;
  @override
  List<InstallmentDetail>? get installments;

  /// Create a copy of OnboardingFormData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingFormDataImplCopyWith<_$OnboardingFormDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InstallmentDetail _$InstallmentDetailFromJson(Map<String, dynamic> json) {
  return _InstallmentDetail.fromJson(json);
}

/// @nodoc
mixin _$InstallmentDetail {
  int? get index => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;

  /// Serializes this InstallmentDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstallmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstallmentDetailCopyWith<InstallmentDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstallmentDetailCopyWith<$Res> {
  factory $InstallmentDetailCopyWith(
    InstallmentDetail value,
    $Res Function(InstallmentDetail) then,
  ) = _$InstallmentDetailCopyWithImpl<$Res, InstallmentDetail>;
  @useResult
  $Res call({int? index, DateTime? dueDate, double? amount});
}

/// @nodoc
class _$InstallmentDetailCopyWithImpl<$Res, $Val extends InstallmentDetail>
    implements $InstallmentDetailCopyWith<$Res> {
  _$InstallmentDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstallmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = freezed,
    Object? dueDate = freezed,
    Object? amount = freezed,
  }) {
    return _then(
      _value.copyWith(
            index: freezed == index
                ? _value.index
                : index // ignore: cast_nullable_to_non_nullable
                      as int?,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InstallmentDetailImplCopyWith<$Res>
    implements $InstallmentDetailCopyWith<$Res> {
  factory _$$InstallmentDetailImplCopyWith(
    _$InstallmentDetailImpl value,
    $Res Function(_$InstallmentDetailImpl) then,
  ) = __$$InstallmentDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? index, DateTime? dueDate, double? amount});
}

/// @nodoc
class __$$InstallmentDetailImplCopyWithImpl<$Res>
    extends _$InstallmentDetailCopyWithImpl<$Res, _$InstallmentDetailImpl>
    implements _$$InstallmentDetailImplCopyWith<$Res> {
  __$$InstallmentDetailImplCopyWithImpl(
    _$InstallmentDetailImpl _value,
    $Res Function(_$InstallmentDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstallmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = freezed,
    Object? dueDate = freezed,
    Object? amount = freezed,
  }) {
    return _then(
      _$InstallmentDetailImpl(
        index: freezed == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int?,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InstallmentDetailImpl implements _InstallmentDetail {
  const _$InstallmentDetailImpl({this.index, this.dueDate, this.amount});

  factory _$InstallmentDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstallmentDetailImplFromJson(json);

  @override
  final int? index;
  @override
  final DateTime? dueDate;
  @override
  final double? amount;

  @override
  String toString() {
    return 'InstallmentDetail(index: $index, dueDate: $dueDate, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallmentDetailImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, index, dueDate, amount);

  /// Create a copy of InstallmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallmentDetailImplCopyWith<_$InstallmentDetailImpl> get copyWith =>
      __$$InstallmentDetailImplCopyWithImpl<_$InstallmentDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InstallmentDetailImplToJson(this);
  }
}

abstract class _InstallmentDetail implements InstallmentDetail {
  const factory _InstallmentDetail({
    final int? index,
    final DateTime? dueDate,
    final double? amount,
  }) = _$InstallmentDetailImpl;

  factory _InstallmentDetail.fromJson(Map<String, dynamic> json) =
      _$InstallmentDetailImpl.fromJson;

  @override
  int? get index;
  @override
  DateTime? get dueDate;
  @override
  double? get amount;

  /// Create a copy of InstallmentDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstallmentDetailImplCopyWith<_$InstallmentDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
