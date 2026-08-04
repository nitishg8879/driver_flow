import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import 'package:driver_flow_admin/features/schedule/data/models/schedule_model.dart';
import 'package:driver_flow_admin/utils/constants/app_enums.dart';

/// Calendar event backed by a real [ScheduleModel].
class ScheduleCalendarEvent extends CalendarEvent {
  final ScheduleModel schedule;

  ScheduleCalendarEvent({
    super.id,
    required this.schedule,
    required super.dateTimeRange,
    super.interaction,
    super.multiDayRule,
  });

  Color get color => _colorOf(schedule.status);

  static Color _colorOf(ScheduleStatus s) => switch (s) {
        ScheduleStatus.scheduled => const Color(0xFF6366F1),
        ScheduleStatus.completed => const Color(0xFF10B981),
        ScheduleStatus.cancelledByStudent ||
        ScheduleStatus.cancelledByInstructor ||
        ScheduleStatus.adminCancelled =>
          const Color(0xFFEF4444),
      };

  factory ScheduleCalendarEvent.from(ScheduleModel s) => ScheduleCalendarEvent(
        schedule: s,
        dateTimeRange: DateTimeRange(
          start: s.startTime ?? DateTime.now(),
          end: s.endTime ?? DateTime.now().add(const Duration(hours: 1)),
        ),
      );

  @override
  CalendarEvent copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction}) =>
      ScheduleCalendarEvent(
        id: id,
        schedule: schedule,
        dateTimeRange: dateTimeRange ?? this.dateTimeRange,
        interaction: interaction ?? this.interaction,
        multiDayRule: multiDayRule,
      );
}

/// All-day marker for non-working days — read-only, no interaction.
class ClosedDayEvent extends CalendarEvent {
  ClosedDayEvent({required super.dateTimeRange})
      : super(interaction: EventInteraction.allowNone());

  @override
  CalendarEvent copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction}) =>
      ClosedDayEvent(dateTimeRange: dateTimeRange ?? this.dateTimeRange);
}


