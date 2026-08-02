import 'package:driver_flow_admin/features/schedule/data/models/schedule_model.dart';
import 'package:driver_flow_admin/utils/constants/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleCalendarDataSource extends CalendarDataSource {
  ScheduleCalendarDataSource(List<ScheduleModel> schedules) {
    appointments = schedules
        .map(
          (s) => Appointment(
            startTime: s.startTime,
            endTime: s.endTime,
            subject: s.studentName,
            notes: '${s.instructorName} • ${s.vehicleName}',
            color: _colorFor(s.status),
          ),
        )
        .toList();
  }

  static Color _colorFor(ScheduleStatus status) => switch (status) {
        ScheduleStatus.completed => const Color(0xFF2E7D32),
        ScheduleStatus.scheduled => const Color(0xFF1565C0),
        _ => const Color(0xFFC62828),
      };
}
