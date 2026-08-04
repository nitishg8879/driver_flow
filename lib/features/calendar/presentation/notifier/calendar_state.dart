import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

final _displayRange = DateTimeRange(
  start: DateTime(2020),
  end: DateTime(DateTime.now().year + 5),
);

TimeOfDay get _initialTime {
  final now = TimeOfDay.now();
  final hour = now.hour < 2 ? 0 : now.hour - 2;
  return TimeOfDay(hour: hour, minute: 0);
}

@immutable
class CalendarConfig {
  final ViewConfiguration viewConfiguration;
  final MultiDayBodyConfiguration multiDayBodyConfiguration;
  final MultiDayHeaderConfiguration multiDayHeaderConfiguration;
  final MonthBodyConfiguration monthBodyConfiguration;
  final ScheduleBodyConfiguration scheduleBodyConfiguration;
  final CalendarInteraction interactionBody;
  final CalendarInteraction interactionHeader;
  final CalendarSnapping snapping;
  final bool showHeader;

  CalendarConfig({
    ViewConfiguration? viewConfiguration,
    this.multiDayBodyConfiguration = const MultiDayBodyConfiguration(),
    this.multiDayHeaderConfiguration = const MultiDayHeaderConfiguration(),
    this.monthBodyConfiguration = const MonthBodyConfiguration(),
    ScheduleBodyConfiguration? scheduleBodyConfiguration,
    CalendarInteraction? interactionBody,
    CalendarInteraction? interactionHeader,
    this.snapping = const CalendarSnapping(),
    this.showHeader = true,
  })  : viewConfiguration = viewConfiguration ??
            MultiDayViewConfiguration.week(
              displayRange: _displayRange,
              initialTimeOfDay: _initialTime,
            ),
        scheduleBodyConfiguration = scheduleBodyConfiguration ?? ScheduleBodyConfiguration(),
        interactionBody = interactionBody ?? CalendarInteraction(),
        interactionHeader = interactionHeader ?? CalendarInteraction();

  /// All available view configurations.
  static List<ViewConfiguration> viewConfigurations() => [
        MultiDayViewConfiguration.singleDay(displayRange: _displayRange, initialTimeOfDay: _initialTime),
        MultiDayViewConfiguration.week(displayRange: _displayRange, initialTimeOfDay: _initialTime),
        MultiDayViewConfiguration.workWeek(displayRange: _displayRange, initialTimeOfDay: _initialTime),
        MultiDayViewConfiguration.custom(
          numberOfDays: 3,
          name: '3 Days',
          displayRange: _displayRange,
          initialTimeOfDay: _initialTime,
        ),
        MonthViewConfiguration.singleMonth(displayRange: _displayRange),
        ScheduleViewConfiguration.continuous(name: 'Schedule', displayRange: _displayRange),
      ];

  CalendarConfig copyWith({
    ViewConfiguration? viewConfiguration,
    MultiDayBodyConfiguration? multiDayBodyConfiguration,
    MultiDayHeaderConfiguration? multiDayHeaderConfiguration,
    MonthBodyConfiguration? monthBodyConfiguration,
    ScheduleBodyConfiguration? scheduleBodyConfiguration,
    CalendarInteraction? interactionBody,
    CalendarInteraction? interactionHeader,
    CalendarSnapping? snapping,
    bool? showHeader,
  }) {
    return CalendarConfig(
      viewConfiguration: viewConfiguration ?? this.viewConfiguration,
      multiDayBodyConfiguration: multiDayBodyConfiguration ?? this.multiDayBodyConfiguration,
      multiDayHeaderConfiguration: multiDayHeaderConfiguration ?? this.multiDayHeaderConfiguration,
      monthBodyConfiguration: monthBodyConfiguration ?? this.monthBodyConfiguration,
      scheduleBodyConfiguration: scheduleBodyConfiguration ?? this.scheduleBodyConfiguration,
      interactionBody: interactionBody ?? this.interactionBody,
      interactionHeader: interactionHeader ?? this.interactionHeader,
      snapping: snapping ?? this.snapping,
      showHeader: showHeader ?? this.showHeader,
    );
  }
}
