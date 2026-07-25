// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ScheduleState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScheduleInitial value) initial,
    required TResult Function(ScheduleLoading value) loading,
    required TResult Function(ScheduleLoaded value) loaded,
    required TResult Function(ScheduleError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ScheduleInitial value)? initial,
    TResult? Function(ScheduleLoading value)? loading,
    TResult? Function(ScheduleLoaded value)? loaded,
    TResult? Function(ScheduleError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScheduleInitial value)? initial,
    TResult Function(ScheduleLoading value)? loading,
    TResult Function(ScheduleLoaded value)? loaded,
    TResult Function(ScheduleError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleStateCopyWith<$Res> {
  factory $ScheduleStateCopyWith(
    ScheduleState value,
    $Res Function(ScheduleState) then,
  ) = _$ScheduleStateCopyWithImpl<$Res, ScheduleState>;
}

/// @nodoc
class _$ScheduleStateCopyWithImpl<$Res, $Val extends ScheduleState>
    implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ScheduleInitialImplCopyWith<$Res> {
  factory _$$ScheduleInitialImplCopyWith(
    _$ScheduleInitialImpl value,
    $Res Function(_$ScheduleInitialImpl) then,
  ) = __$$ScheduleInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ScheduleInitialImplCopyWithImpl<$Res>
    extends _$ScheduleStateCopyWithImpl<$Res, _$ScheduleInitialImpl>
    implements _$$ScheduleInitialImplCopyWith<$Res> {
  __$$ScheduleInitialImplCopyWithImpl(
    _$ScheduleInitialImpl _value,
    $Res Function(_$ScheduleInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ScheduleInitialImpl implements ScheduleInitial {
  const _$ScheduleInitialImpl();

  @override
  String toString() {
    return 'ScheduleState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ScheduleInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScheduleInitial value) initial,
    required TResult Function(ScheduleLoading value) loading,
    required TResult Function(ScheduleLoaded value) loaded,
    required TResult Function(ScheduleError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ScheduleInitial value)? initial,
    TResult? Function(ScheduleLoading value)? loading,
    TResult? Function(ScheduleLoaded value)? loaded,
    TResult? Function(ScheduleError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScheduleInitial value)? initial,
    TResult Function(ScheduleLoading value)? loading,
    TResult Function(ScheduleLoaded value)? loaded,
    TResult Function(ScheduleError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ScheduleInitial implements ScheduleState {
  const factory ScheduleInitial() = _$ScheduleInitialImpl;
}

/// @nodoc
abstract class _$$ScheduleLoadingImplCopyWith<$Res> {
  factory _$$ScheduleLoadingImplCopyWith(
    _$ScheduleLoadingImpl value,
    $Res Function(_$ScheduleLoadingImpl) then,
  ) = __$$ScheduleLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ScheduleLoadingImplCopyWithImpl<$Res>
    extends _$ScheduleStateCopyWithImpl<$Res, _$ScheduleLoadingImpl>
    implements _$$ScheduleLoadingImplCopyWith<$Res> {
  __$$ScheduleLoadingImplCopyWithImpl(
    _$ScheduleLoadingImpl _value,
    $Res Function(_$ScheduleLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ScheduleLoadingImpl implements ScheduleLoading {
  const _$ScheduleLoadingImpl();

  @override
  String toString() {
    return 'ScheduleState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ScheduleLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScheduleInitial value) initial,
    required TResult Function(ScheduleLoading value) loading,
    required TResult Function(ScheduleLoaded value) loaded,
    required TResult Function(ScheduleError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ScheduleInitial value)? initial,
    TResult? Function(ScheduleLoading value)? loading,
    TResult? Function(ScheduleLoaded value)? loaded,
    TResult? Function(ScheduleError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScheduleInitial value)? initial,
    TResult Function(ScheduleLoading value)? loading,
    TResult Function(ScheduleLoaded value)? loaded,
    TResult Function(ScheduleError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ScheduleLoading implements ScheduleState {
  const factory ScheduleLoading() = _$ScheduleLoadingImpl;
}

/// @nodoc
abstract class _$$ScheduleLoadedImplCopyWith<$Res> {
  factory _$$ScheduleLoadedImplCopyWith(
    _$ScheduleLoadedImpl value,
    $Res Function(_$ScheduleLoadedImpl) then,
  ) = __$$ScheduleLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<ScheduleModel> schedules,
    DateTime date,
    String? instructorId,
    String? studentId,
  });
}

/// @nodoc
class __$$ScheduleLoadedImplCopyWithImpl<$Res>
    extends _$ScheduleStateCopyWithImpl<$Res, _$ScheduleLoadedImpl>
    implements _$$ScheduleLoadedImplCopyWith<$Res> {
  __$$ScheduleLoadedImplCopyWithImpl(
    _$ScheduleLoadedImpl _value,
    $Res Function(_$ScheduleLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schedules = null,
    Object? date = null,
    Object? instructorId = freezed,
    Object? studentId = freezed,
  }) {
    return _then(
      _$ScheduleLoadedImpl(
        schedules: null == schedules
            ? _value._schedules
            : schedules // ignore: cast_nullable_to_non_nullable
                  as List<ScheduleModel>,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        instructorId: freezed == instructorId
            ? _value.instructorId
            : instructorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        studentId: freezed == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ScheduleLoadedImpl implements ScheduleLoaded {
  const _$ScheduleLoadedImpl({
    required final List<ScheduleModel> schedules,
    required this.date,
    this.instructorId,
    this.studentId,
  }) : _schedules = schedules;

  final List<ScheduleModel> _schedules;
  @override
  List<ScheduleModel> get schedules {
    if (_schedules is EqualUnmodifiableListView) return _schedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  @override
  final DateTime date;
  @override
  final String? instructorId;
  @override
  final String? studentId;

  @override
  String toString() {
    return 'ScheduleState.loaded(schedules: $schedules, date: $date, instructorId: $instructorId, studentId: $studentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleLoadedImpl &&
            const DeepCollectionEquality().equals(
              other._schedules,
              _schedules,
            ) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.instructorId, instructorId) ||
                other.instructorId == instructorId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_schedules),
    date,
    instructorId,
    studentId,
  );

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleLoadedImplCopyWith<_$ScheduleLoadedImpl> get copyWith =>
      __$$ScheduleLoadedImplCopyWithImpl<_$ScheduleLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(schedules, date, instructorId, studentId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(schedules, date, instructorId, studentId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(schedules, date, instructorId, studentId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScheduleInitial value) initial,
    required TResult Function(ScheduleLoading value) loading,
    required TResult Function(ScheduleLoaded value) loaded,
    required TResult Function(ScheduleError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ScheduleInitial value)? initial,
    TResult? Function(ScheduleLoading value)? loading,
    TResult? Function(ScheduleLoaded value)? loaded,
    TResult? Function(ScheduleError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScheduleInitial value)? initial,
    TResult Function(ScheduleLoading value)? loading,
    TResult Function(ScheduleLoaded value)? loaded,
    TResult Function(ScheduleError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ScheduleLoaded implements ScheduleState {
  const factory ScheduleLoaded({
    required final List<ScheduleModel> schedules,
    required final DateTime date,
    final String? instructorId,
    final String? studentId,
  }) = _$ScheduleLoadedImpl;

  List<ScheduleModel> get schedules;
  DateTime get date;
  String? get instructorId;
  String? get studentId;

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleLoadedImplCopyWith<_$ScheduleLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ScheduleErrorImplCopyWith<$Res> {
  factory _$$ScheduleErrorImplCopyWith(
    _$ScheduleErrorImpl value,
    $Res Function(_$ScheduleErrorImpl) then,
  ) = __$$ScheduleErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ScheduleErrorImplCopyWithImpl<$Res>
    extends _$ScheduleStateCopyWithImpl<$Res, _$ScheduleErrorImpl>
    implements _$$ScheduleErrorImplCopyWith<$Res> {
  __$$ScheduleErrorImplCopyWithImpl(
    _$ScheduleErrorImpl _value,
    $Res Function(_$ScheduleErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ScheduleErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ScheduleErrorImpl implements ScheduleError {
  const _$ScheduleErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ScheduleState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleErrorImplCopyWith<_$ScheduleErrorImpl> get copyWith =>
      __$$ScheduleErrorImplCopyWithImpl<_$ScheduleErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<ScheduleModel> schedules,
      DateTime date,
      String? instructorId,
      String? studentId,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ScheduleInitial value) initial,
    required TResult Function(ScheduleLoading value) loading,
    required TResult Function(ScheduleLoaded value) loaded,
    required TResult Function(ScheduleError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ScheduleInitial value)? initial,
    TResult? Function(ScheduleLoading value)? loading,
    TResult? Function(ScheduleLoaded value)? loaded,
    TResult? Function(ScheduleError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ScheduleInitial value)? initial,
    TResult Function(ScheduleLoading value)? loading,
    TResult Function(ScheduleLoaded value)? loaded,
    TResult Function(ScheduleError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ScheduleError implements ScheduleState {
  const factory ScheduleError(final String message) = _$ScheduleErrorImpl;

  String get message;

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleErrorImplCopyWith<_$ScheduleErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
