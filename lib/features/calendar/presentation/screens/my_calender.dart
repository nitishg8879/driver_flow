import 'package:driver_flow_admin/features/calendar/data/models/lesson_event.dart';
import 'package:driver_flow_admin/features/profile/data/models/organization_profile_model.dart';
import 'package:driver_flow_admin/features/schedule/data/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class MyCalender extends StatefulWidget {
  final OrganizationProfileModel? profile;
  final List<ScheduleModel> schedules;

  const MyCalender({
    super.key,
    this.profile,
    this.schedules = const [],
  });

  @override
  State<MyCalender> createState() => _MyCalenderState();
}

class _MyCalenderState extends State<MyCalender> {
  late final DefaultEventsController _eventsCtrl;
  late final CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventsCtrl = DefaultEventsController();
    _loadEvents();
  }

  @override
  void didUpdateWidget(MyCalender oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.schedules != widget.schedules) _loadEvents();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _eventsCtrl.dispose();
    super.dispose();
  }

  void _loadEvents() {
    _eventsCtrl.clearEvents();
    for (final s in widget.schedules) {
      _eventsCtrl.addEvent(ScheduleCalendarEvent.from(s));
    }
  }

  ViewConfiguration get _viewConfig {
    final start = widget.profile?.vechileStartTime;
    final end = widget.profile?.vechileEndTime;
    final range = DateTimeRange(
      start: DateTime(2020),
      end: DateTime(DateTime.now().year + 5),
    );
    return MultiDayViewConfiguration.week(
      displayRange: range,
      timeOfDayRange: (start != null && end != null)
          ? TimeOfDayRange(start: start, end: end)
          : TimeOfDayRange(
              start: const TimeOfDay(hour: 6, minute: 0),
              end: const TimeOfDay(hour: 22, minute: 0),
            ),
      initialTimeOfDay: start ?? const TimeOfDay(hour: 8, minute: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      eventsController: _eventsCtrl,
      calendarController: _calendarController,
      viewConfiguration: _viewConfig,
      header: CalendarHeader(
        multiDayTileComponents: TileComponents(
          tileBuilder: (event, range) => _EventTile(event: event as ScheduleCalendarEvent, range: range),
        ),
      ),
      body: CalendarBody(
        multiDayTileComponents: TileComponents(
          tileBuilder: (event, range) => _EventTile(event: event as ScheduleCalendarEvent, range: range),
        ),
      ),
      callbacks: CalendarCallbacks(
        onEventTapped: (event, _) {
          if (event is ScheduleCalendarEvent) {
            _showDetail(context, event);
          }
        },
        onEventCreate: null,
      ),
    );
  }

  void _showDetail(BuildContext context, ScheduleCalendarEvent event) {
    final s = event.schedule;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.studentName ?? 'Lesson'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.instructorName != null) Text('Instructor: ${s.instructorName}'),
            if (s.startTime != null) Text('Start: ${TimeOfDay.fromDateTime(s.startTime!).format(context)}'),
            if (s.endTime != null) Text('End: ${TimeOfDay.fromDateTime(s.endTime!).format(context)}'),
            Text('Status: ${s.status.displayName}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final ScheduleCalendarEvent event;
  final DateTimeRange range;
  const _EventTile({required this.event, required this.range});

  @override
  Widget build(BuildContext context) {
    final color = event.color;
    final surface = Theme.of(context).colorScheme.surfaceContainerLow;
    final bg = Color.lerp(surface, color, Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.12)!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          event.schedule.studentName ?? 'Lesson',
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
