// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsControllerHash() => r'42a837aec155912dff1d1abdb8879358af9f08bc';

/// Wraps DefaultEventsController so it's accessible from anywhere in the feature.
/// Disposed automatically when the provider is removed.
///
/// Copied from [eventsController].
@ProviderFor(eventsController)
final eventsControllerProvider =
    AutoDisposeProvider<DefaultEventsController>.internal(
      eventsController,
      name: r'eventsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$eventsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventsControllerRef = AutoDisposeProviderRef<DefaultEventsController>;
String _$calendarConfigNotifierHash() =>
    r'cbfcea88ab2101e85356dcc2c13b050b9cadafa7';

/// Manages view/body/header/interaction config that needs to persist
/// across widget rebuilds (e.g. sidebar config panel changes).
///
/// Copied from [CalendarConfigNotifier].
@ProviderFor(CalendarConfigNotifier)
final calendarConfigNotifierProvider =
    AutoDisposeNotifierProvider<
      CalendarConfigNotifier,
      CalendarConfig
    >.internal(
      CalendarConfigNotifier.new,
      name: r'calendarConfigNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calendarConfigNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CalendarConfigNotifier = AutoDisposeNotifier<CalendarConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
