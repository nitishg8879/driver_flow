import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kalender/kalender.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/lesson_event.dart';
import 'calendar_state.dart';

part 'calendar_notifier.g.dart';

/// Manages view/body/header/interaction config that needs to persist
/// across widget rebuilds (e.g. sidebar config panel changes).
@riverpod
class CalendarConfigNotifier extends _$CalendarConfigNotifier {
  @override
  CalendarConfig build() => CalendarConfig();

  void setViewConfiguration(ViewConfiguration value) {
    if (state.viewConfiguration == value) return;
    state = state.copyWith(viewConfiguration: value);
  }

  void setMultiDayBodyConfiguration(MultiDayBodyConfiguration value) {
    if (state.multiDayBodyConfiguration == value) return;
    state = state.copyWith(multiDayBodyConfiguration: value);
  }

  void setMultiDayHeaderConfiguration(MultiDayHeaderConfiguration value) {
    if (state.multiDayHeaderConfiguration == value) return;
    state = state.copyWith(multiDayHeaderConfiguration: value);
  }

  void setMonthBodyConfiguration(MonthBodyConfiguration value) {
    if (state.monthBodyConfiguration == value) return;
    state = state.copyWith(monthBodyConfiguration: value);
  }

  void setScheduleBodyConfiguration(ScheduleBodyConfiguration value) {
    if (state.scheduleBodyConfiguration == value) return;
    state = state.copyWith(scheduleBodyConfiguration: value);
  }

  void setInteractionBody(CalendarInteraction value) {
    if (state.interactionBody == value) return;
    state = state.copyWith(interactionBody: value);
  }

  void setInteractionHeader(CalendarInteraction value) {
    if (state.interactionHeader == value) return;
    state = state.copyWith(interactionHeader: value);
  }

  void setSnapping(CalendarSnapping value) {
    if (state.snapping == value) return;
    state = state.copyWith(snapping: value);
  }

  void setShowHeader(bool value) {
    if (state.showHeader == value) return;
    state = state.copyWith(showHeader: value);
  }
}

/// Wraps DefaultEventsController so it's accessible from anywhere in the feature.
/// Disposed automatically when the provider is removed.
@riverpod
DefaultEventsController eventsController(Ref ref) {
  final controller = DefaultEventsController();
  controller.addEvents(_generateSampleEvents());
  ref.onDispose(controller.dispose);
  return controller;
}

List<LessonEvent> _generateSampleEvents() {
  const colors = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF3B82F6),
  ];

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final events = <LessonEvent>[];

  LessonEvent timed(DateTime day, int hour, int minute, Duration duration, String title, Color color) {
    final start = DateTime(day.year, day.month, day.day, hour, minute);
    return LessonEvent(
      dateTimeRange: DateTimeRange(start: start, end: start.add(duration)),
      title: title,
      color: color,
    );
  }

  for (var i = -14; i <= 30; i++) {
    final day = today.add(Duration(days: i));
    final weekday = day.weekday;
    final isWeekend = weekday >= 6;

    if (!isWeekend) {
      events.add(timed(day, 9, 0, const Duration(hours: 1), 'Driving Lesson', colors[0]));
      if (weekday == DateTime.monday) {
        events.add(timed(day, 11, 0, const Duration(hours: 1, minutes: 30), 'Theory Class', colors[1]));
      }
      if (weekday == DateTime.wednesday) {
        events.add(timed(day, 14, 0, const Duration(hours: 1), 'Test Prep', colors[2]));
      }
      if (weekday == DateTime.friday) {
        events.add(timed(day, 16, 0, const Duration(minutes: 45), 'Mock Test', colors[4]));
      }
    }
  }

  // Multi-day events
  events.add(LessonEvent(
    dateTimeRange: DateTimeRange(
      start: today.add(const Duration(days: 3)),
      end: today.add(const Duration(days: 5)),
    ),
    title: 'Batch Holiday',
    color: colors[5],
  ));

  return events;
}
