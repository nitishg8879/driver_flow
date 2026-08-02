import 'package:driver_flow_admin/features/schedule/data/models/schedule_model.dart';
import 'package:driver_flow_admin/features/schedule/presentation/widgets/schedule_calendar_data_source.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class StudentsSessions extends StatelessWidget {
  const StudentsSessions({
    super.key,
    required this.schedules,
    required this.context,
  });

  final List<ScheduleModel> schedules;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 700,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        color: colorScheme.surface,
      ),
      clipBehavior: Clip.hardEdge,
      child: SfCalendar(
        view: CalendarView.week,
        initialDisplayDate: DateTime.now(),
        dataSource: ScheduleCalendarDataSource(schedules),
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 7,
          endHour: 20,
          timeIntervalHeight: 60,
          timeFormat: 'h a',
        ),
        headerStyle: CalendarHeaderStyle(
          backgroundColor: colorScheme.surfaceContainerHighest,
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            fontSize: 15,
          ),
        ),
        viewHeaderStyle: ViewHeaderStyle(
          backgroundColor: colorScheme.surfaceContainerHighest,
          dayTextStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          dateTextStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        todayHighlightColor: colorScheme.primary,
        selectionDecoration: BoxDecoration(
          border: Border.all(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        appointmentBuilder: (context, details) {
          final appointment = details.appointments.first as Appointment;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: appointment.color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: appointment.color.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appointment.subject,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (appointment.notes != null)
                  Text(
                    appointment.notes!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
