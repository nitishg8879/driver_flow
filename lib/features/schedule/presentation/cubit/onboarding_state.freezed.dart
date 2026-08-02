// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OnboardingState {
  int get currentStep => throw _privateConstructorUsedError;
  OnboardingFormData? get formData => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentStep, OnboardingFormData? formData)
    initial,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loading,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loaded,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    success,
    required TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )
    error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult? Function(int currentStep, OnboardingFormData? formData)? success,
    TResult? Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult Function(int currentStep, OnboardingFormData? formData)? success,
    TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnboardingInitial value) initial,
    required TResult Function(OnboardingLoading value) loading,
    required TResult Function(OnboardingLoaded value) loaded,
    required TResult Function(OnboardingSuccess value) success,
    required TResult Function(OnboardingError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnboardingInitial value)? initial,
    TResult? Function(OnboardingLoading value)? loading,
    TResult? Function(OnboardingLoaded value)? loaded,
    TResult? Function(OnboardingSuccess value)? success,
    TResult? Function(OnboardingError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnboardingInitial value)? initial,
    TResult Function(OnboardingLoading value)? loading,
    TResult Function(OnboardingLoaded value)? loaded,
    TResult Function(OnboardingSuccess value)? success,
    TResult Function(OnboardingError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingStateCopyWith<OnboardingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<$Res> {
  factory $OnboardingStateCopyWith(
    OnboardingState value,
    $Res Function(OnboardingState) then,
  ) = _$OnboardingStateCopyWithImpl<$Res, OnboardingState>;
  @useResult
  $Res call({int currentStep, OnboardingFormData? formData});

  $OnboardingFormDataCopyWith<$Res>? get formData;
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res, $Val extends OnboardingState>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentStep = null, Object? formData = freezed}) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            formData: freezed == formData
                ? _value.formData
                : formData // ignore: cast_nullable_to_non_nullable
                      as OnboardingFormData?,
          )
          as $Val,
    );
  }

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OnboardingFormDataCopyWith<$Res>? get formData {
    if (_value.formData == null) {
      return null;
    }

    return $OnboardingFormDataCopyWith<$Res>(_value.formData!, (value) {
      return _then(_value.copyWith(formData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnboardingInitialImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingInitialImplCopyWith(
    _$OnboardingInitialImpl value,
    $Res Function(_$OnboardingInitialImpl) then,
  ) = __$$OnboardingInitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int currentStep, OnboardingFormData? formData});

  @override
  $OnboardingFormDataCopyWith<$Res>? get formData;
}

/// @nodoc
class __$$OnboardingInitialImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingInitialImpl>
    implements _$$OnboardingInitialImplCopyWith<$Res> {
  __$$OnboardingInitialImplCopyWithImpl(
    _$OnboardingInitialImpl _value,
    $Res Function(_$OnboardingInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentStep = null, Object? formData = freezed}) {
    return _then(
      _$OnboardingInitialImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        formData: freezed == formData
            ? _value.formData
            : formData // ignore: cast_nullable_to_non_nullable
                  as OnboardingFormData?,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingInitialImpl implements OnboardingInitial {
  const _$OnboardingInitialImpl({this.currentStep = 0, this.formData = null});

  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final OnboardingFormData? formData;

  @override
  String toString() {
    return 'OnboardingState.initial(currentStep: $currentStep, formData: $formData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingInitialImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.formData, formData) ||
                other.formData == formData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentStep, formData);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingInitialImplCopyWith<_$OnboardingInitialImpl> get copyWith =>
      __$$OnboardingInitialImplCopyWithImpl<_$OnboardingInitialImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentStep, OnboardingFormData? formData)
    initial,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loading,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loaded,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    success,
    required TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )
    error,
  }) {
    return initial(currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult? Function(int currentStep, OnboardingFormData? formData)? success,
    TResult? Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
  }) {
    return initial?.call(currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult Function(int currentStep, OnboardingFormData? formData)? success,
    TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(currentStep, formData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnboardingInitial value) initial,
    required TResult Function(OnboardingLoading value) loading,
    required TResult Function(OnboardingLoaded value) loaded,
    required TResult Function(OnboardingSuccess value) success,
    required TResult Function(OnboardingError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnboardingInitial value)? initial,
    TResult? Function(OnboardingLoading value)? loading,
    TResult? Function(OnboardingLoaded value)? loaded,
    TResult? Function(OnboardingSuccess value)? success,
    TResult? Function(OnboardingError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnboardingInitial value)? initial,
    TResult Function(OnboardingLoading value)? loading,
    TResult Function(OnboardingLoaded value)? loaded,
    TResult Function(OnboardingSuccess value)? success,
    TResult Function(OnboardingError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class OnboardingInitial implements OnboardingState {
  const factory OnboardingInitial({
    final int currentStep,
    final OnboardingFormData? formData,
  }) = _$OnboardingInitialImpl;

  @override
  int get currentStep;
  @override
  OnboardingFormData? get formData;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingInitialImplCopyWith<_$OnboardingInitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnboardingLoadingImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingLoadingImplCopyWith(
    _$OnboardingLoadingImpl value,
    $Res Function(_$OnboardingLoadingImpl) then,
  ) = __$$OnboardingLoadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int currentStep, OnboardingFormData? formData});

  @override
  $OnboardingFormDataCopyWith<$Res>? get formData;
}

/// @nodoc
class __$$OnboardingLoadingImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingLoadingImpl>
    implements _$$OnboardingLoadingImplCopyWith<$Res> {
  __$$OnboardingLoadingImplCopyWithImpl(
    _$OnboardingLoadingImpl _value,
    $Res Function(_$OnboardingLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentStep = null, Object? formData = freezed}) {
    return _then(
      _$OnboardingLoadingImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        formData: freezed == formData
            ? _value.formData
            : formData // ignore: cast_nullable_to_non_nullable
                  as OnboardingFormData?,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingLoadingImpl implements OnboardingLoading {
  const _$OnboardingLoadingImpl({this.currentStep = 0, this.formData = null});

  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final OnboardingFormData? formData;

  @override
  String toString() {
    return 'OnboardingState.loading(currentStep: $currentStep, formData: $formData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingLoadingImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.formData, formData) ||
                other.formData == formData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentStep, formData);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingLoadingImplCopyWith<_$OnboardingLoadingImpl> get copyWith =>
      __$$OnboardingLoadingImplCopyWithImpl<_$OnboardingLoadingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentStep, OnboardingFormData? formData)
    initial,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loading,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loaded,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    success,
    required TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )
    error,
  }) {
    return loading(currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult? Function(int currentStep, OnboardingFormData? formData)? success,
    TResult? Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
  }) {
    return loading?.call(currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult Function(int currentStep, OnboardingFormData? formData)? success,
    TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(currentStep, formData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnboardingInitial value) initial,
    required TResult Function(OnboardingLoading value) loading,
    required TResult Function(OnboardingLoaded value) loaded,
    required TResult Function(OnboardingSuccess value) success,
    required TResult Function(OnboardingError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnboardingInitial value)? initial,
    TResult? Function(OnboardingLoading value)? loading,
    TResult? Function(OnboardingLoaded value)? loaded,
    TResult? Function(OnboardingSuccess value)? success,
    TResult? Function(OnboardingError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnboardingInitial value)? initial,
    TResult Function(OnboardingLoading value)? loading,
    TResult Function(OnboardingLoaded value)? loaded,
    TResult Function(OnboardingSuccess value)? success,
    TResult Function(OnboardingError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class OnboardingLoading implements OnboardingState {
  const factory OnboardingLoading({
    final int currentStep,
    final OnboardingFormData? formData,
  }) = _$OnboardingLoadingImpl;

  @override
  int get currentStep;
  @override
  OnboardingFormData? get formData;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingLoadingImplCopyWith<_$OnboardingLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnboardingLoadedImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingLoadedImplCopyWith(
    _$OnboardingLoadedImpl value,
    $Res Function(_$OnboardingLoadedImpl) then,
  ) = __$$OnboardingLoadedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int currentStep, OnboardingFormData? formData});

  @override
  $OnboardingFormDataCopyWith<$Res>? get formData;
}

/// @nodoc
class __$$OnboardingLoadedImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingLoadedImpl>
    implements _$$OnboardingLoadedImplCopyWith<$Res> {
  __$$OnboardingLoadedImplCopyWithImpl(
    _$OnboardingLoadedImpl _value,
    $Res Function(_$OnboardingLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentStep = null, Object? formData = freezed}) {
    return _then(
      _$OnboardingLoadedImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        formData: freezed == formData
            ? _value.formData
            : formData // ignore: cast_nullable_to_non_nullable
                  as OnboardingFormData?,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingLoadedImpl implements OnboardingLoaded {
  const _$OnboardingLoadedImpl({this.currentStep = 0, this.formData = null});

  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final OnboardingFormData? formData;

  @override
  String toString() {
    return 'OnboardingState.loaded(currentStep: $currentStep, formData: $formData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingLoadedImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.formData, formData) ||
                other.formData == formData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentStep, formData);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingLoadedImplCopyWith<_$OnboardingLoadedImpl> get copyWith =>
      __$$OnboardingLoadedImplCopyWithImpl<_$OnboardingLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentStep, OnboardingFormData? formData)
    initial,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loading,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loaded,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    success,
    required TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )
    error,
  }) {
    return loaded(currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult? Function(int currentStep, OnboardingFormData? formData)? success,
    TResult? Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
  }) {
    return loaded?.call(currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult Function(int currentStep, OnboardingFormData? formData)? success,
    TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(currentStep, formData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnboardingInitial value) initial,
    required TResult Function(OnboardingLoading value) loading,
    required TResult Function(OnboardingLoaded value) loaded,
    required TResult Function(OnboardingSuccess value) success,
    required TResult Function(OnboardingError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnboardingInitial value)? initial,
    TResult? Function(OnboardingLoading value)? loading,
    TResult? Function(OnboardingLoaded value)? loaded,
    TResult? Function(OnboardingSuccess value)? success,
    TResult? Function(OnboardingError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnboardingInitial value)? initial,
    TResult Function(OnboardingLoading value)? loading,
    TResult Function(OnboardingLoaded value)? loaded,
    TResult Function(OnboardingSuccess value)? success,
    TResult Function(OnboardingError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class OnboardingLoaded implements OnboardingState {
  const factory OnboardingLoaded({
    final int currentStep,
    final OnboardingFormData? formData,
  }) = _$OnboardingLoadedImpl;

  @override
  int get currentStep;
  @override
  OnboardingFormData? get formData;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingLoadedImplCopyWith<_$OnboardingLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnboardingSuccessImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingSuccessImplCopyWith(
    _$OnboardingSuccessImpl value,
    $Res Function(_$OnboardingSuccessImpl) then,
  ) = __$$OnboardingSuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int currentStep, OnboardingFormData? formData});

  @override
  $OnboardingFormDataCopyWith<$Res>? get formData;
}

/// @nodoc
class __$$OnboardingSuccessImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingSuccessImpl>
    implements _$$OnboardingSuccessImplCopyWith<$Res> {
  __$$OnboardingSuccessImplCopyWithImpl(
    _$OnboardingSuccessImpl _value,
    $Res Function(_$OnboardingSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentStep = null, Object? formData = freezed}) {
    return _then(
      _$OnboardingSuccessImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        formData: freezed == formData
            ? _value.formData
            : formData // ignore: cast_nullable_to_non_nullable
                  as OnboardingFormData?,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingSuccessImpl implements OnboardingSuccess {
  const _$OnboardingSuccessImpl({this.currentStep = 0, this.formData = null});

  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final OnboardingFormData? formData;

  @override
  String toString() {
    return 'OnboardingState.success(currentStep: $currentStep, formData: $formData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingSuccessImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.formData, formData) ||
                other.formData == formData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentStep, formData);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingSuccessImplCopyWith<_$OnboardingSuccessImpl> get copyWith =>
      __$$OnboardingSuccessImplCopyWithImpl<_$OnboardingSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentStep, OnboardingFormData? formData)
    initial,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loading,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loaded,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    success,
    required TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )
    error,
  }) {
    return success(currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult? Function(int currentStep, OnboardingFormData? formData)? success,
    TResult? Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
  }) {
    return success?.call(currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult Function(int currentStep, OnboardingFormData? formData)? success,
    TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(currentStep, formData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnboardingInitial value) initial,
    required TResult Function(OnboardingLoading value) loading,
    required TResult Function(OnboardingLoaded value) loaded,
    required TResult Function(OnboardingSuccess value) success,
    required TResult Function(OnboardingError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnboardingInitial value)? initial,
    TResult? Function(OnboardingLoading value)? loading,
    TResult? Function(OnboardingLoaded value)? loaded,
    TResult? Function(OnboardingSuccess value)? success,
    TResult? Function(OnboardingError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnboardingInitial value)? initial,
    TResult Function(OnboardingLoading value)? loading,
    TResult Function(OnboardingLoaded value)? loaded,
    TResult Function(OnboardingSuccess value)? success,
    TResult Function(OnboardingError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class OnboardingSuccess implements OnboardingState {
  const factory OnboardingSuccess({
    final int currentStep,
    final OnboardingFormData? formData,
  }) = _$OnboardingSuccessImpl;

  @override
  int get currentStep;
  @override
  OnboardingFormData? get formData;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingSuccessImplCopyWith<_$OnboardingSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnboardingErrorImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingErrorImplCopyWith(
    _$OnboardingErrorImpl value,
    $Res Function(_$OnboardingErrorImpl) then,
  ) = __$$OnboardingErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int currentStep, OnboardingFormData? formData});

  @override
  $OnboardingFormDataCopyWith<$Res>? get formData;
}

/// @nodoc
class __$$OnboardingErrorImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingErrorImpl>
    implements _$$OnboardingErrorImplCopyWith<$Res> {
  __$$OnboardingErrorImplCopyWithImpl(
    _$OnboardingErrorImpl _value,
    $Res Function(_$OnboardingErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? currentStep = null,
    Object? formData = freezed,
  }) {
    return _then(
      _$OnboardingErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        formData: freezed == formData
            ? _value.formData
            : formData // ignore: cast_nullable_to_non_nullable
                  as OnboardingFormData?,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingErrorImpl implements OnboardingError {
  const _$OnboardingErrorImpl(
    this.message, {
    this.currentStep = 0,
    this.formData = null,
  });

  @override
  final String message;
  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final OnboardingFormData? formData;

  @override
  String toString() {
    return 'OnboardingState.error(message: $message, currentStep: $currentStep, formData: $formData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.formData, formData) ||
                other.formData == formData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, currentStep, formData);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingErrorImplCopyWith<_$OnboardingErrorImpl> get copyWith =>
      __$$OnboardingErrorImplCopyWithImpl<_$OnboardingErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int currentStep, OnboardingFormData? formData)
    initial,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loading,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    loaded,
    required TResult Function(int currentStep, OnboardingFormData? formData)
    success,
    required TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )
    error,
  }) {
    return error(message, currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult? Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult? Function(int currentStep, OnboardingFormData? formData)? success,
    TResult? Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
  }) {
    return error?.call(message, currentStep, formData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int currentStep, OnboardingFormData? formData)? initial,
    TResult Function(int currentStep, OnboardingFormData? formData)? loading,
    TResult Function(int currentStep, OnboardingFormData? formData)? loaded,
    TResult Function(int currentStep, OnboardingFormData? formData)? success,
    TResult Function(
      String message,
      int currentStep,
      OnboardingFormData? formData,
    )?
    error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, currentStep, formData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnboardingInitial value) initial,
    required TResult Function(OnboardingLoading value) loading,
    required TResult Function(OnboardingLoaded value) loaded,
    required TResult Function(OnboardingSuccess value) success,
    required TResult Function(OnboardingError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OnboardingInitial value)? initial,
    TResult? Function(OnboardingLoading value)? loading,
    TResult? Function(OnboardingLoaded value)? loaded,
    TResult? Function(OnboardingSuccess value)? success,
    TResult? Function(OnboardingError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnboardingInitial value)? initial,
    TResult Function(OnboardingLoading value)? loading,
    TResult Function(OnboardingLoaded value)? loaded,
    TResult Function(OnboardingSuccess value)? success,
    TResult Function(OnboardingError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class OnboardingError implements OnboardingState {
  const factory OnboardingError(
    final String message, {
    final int currentStep,
    final OnboardingFormData? formData,
  }) = _$OnboardingErrorImpl;

  String get message;
  @override
  int get currentStep;
  @override
  OnboardingFormData? get formData;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingErrorImplCopyWith<_$OnboardingErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
