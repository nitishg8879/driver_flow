import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kalender/kalender.dart';

import '../../../../../features/profile/data/models/organization_profile_model.dart';
import '../../../../../features/schedule/data/models/schedule_model.dart';
import '../../../data/models/lesson_event.dart';
import '../../notifier/calendar_notifier.dart';
import '../../notifier/calendar_state.dart';
import '../configuration/configuration_panel.dart';
import 'event_tiles.dart';
import 'navigation_header.dart';
import 'resize_handle.dart';
import 'schedule_event_dialog.dart';

class CalendarWidget extends HookConsumerWidget {
  final OrganizationProfileModel? profile;
  final List<ScheduleModel> schedules;

  /// Called when the visible date range changes; return new schedules to display.
  final Future<List<ScheduleModel>> Function(DateTimeRange range)? onRangeChanged;

  const CalendarWidget({
    super.key,
    this.profile,
    this.schedules = const [],
    this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(calendarConfigNotifierProvider);
    final showConfig = useState(false);

    final calendarController = useMemoized(() => CalendarController());
    useEffect(() => calendarController.dispose, const []);

    // Own the events controller locally; rebuild events when schedules/profile change.
    final eventsCtrl = useMemoized(() => DefaultEventsController(), const []);
    useEffect(() => eventsCtrl.dispose, const []);

    // Rebuild calendar events whenever the schedule list or profile changes.
    useEffect(() {
      _rebuildEvents(eventsCtrl, schedules, profile);
      return null;
    }, [schedules, profile]);

    // Notify parent when visible range changes so it can fetch fresh data.
    useEffect(() {
      void listener() {
        final vc = calendarController.viewController;
        if (vc is MultiDayViewController) {
          final range = vc.visibleDateTimeRange.value;
          if (range != null) {
            final flutterRange = range.forLocation();
            onRangeChanged?.call(flutterRange);
          }
        }
      }

      calendarController.addListener(listener);
      return () => calendarController.removeListener(listener);
    }, [calendarController, onRangeChanged]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowConfig = constraints.maxWidth > 500;
        final configWidth = (constraints.maxWidth * 0.30).clamp(260.0, 380.0);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CalendarView(
                calendarController: calendarController,
                eventsController: eventsCtrl,
                viewConfiguration: config.viewConfiguration,
                header: _header(context, calendarController, config, canShowConfig, showConfig),
                body: _body(config),
                callbacks: _callbacks(context, calendarController, eventsCtrl),
              ),
            ),
            if (canShowConfig)
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.centerLeft,
                child: showConfig.value
                    ? SizedBox(
                        width: configWidth,
                        height: constraints.maxHeight,
                        child: CalendarConfigPanel(
                          onDismiss: () => showConfig.value = false,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
          ],
        );
      },
    );
  }

  // ── Event building ─────────────────────────────────────────────────────────

  static void _rebuildEvents(
    DefaultEventsController ctrl,
    List<ScheduleModel> schedules,
    OrganizationProfileModel? profile,
  ) {
    ctrl.clearEvents();
    // Add schedule events.
    for (final s in schedules) {
      ctrl.addEvent(ScheduleCalendarEvent.from(s));
    }
    // Mark non-working days for the visible year range.
    if (profile?.workingDays != null) {
      final now = DateTime.now();
      for (var i = -180; i <= 365; i++) {
        final day = DateTime(now.year, now.month, now.day).add(Duration(days: i));
        if (!_isWorkingDay(day, profile!.workingDays!)) {
          ctrl.addEvent(ClosedDayEvent(
            dateTimeRange: DateTimeRange(
              start: day,
              end: day.add(const Duration(days: 1)),
            ),
          ));
        }
      }
    }
  }

  static bool _isWorkingDay(DateTime day, List<OrgWorkingDay>? workingDays) {
    if (workingDays == null || workingDays.isEmpty) return true;
    final weekday = day.weekday;
    for (final wd in workingDays) {
      switch (wd) {
        case OrgWorkingDay.monday:
          if (weekday == DateTime.monday) return true;
        case OrgWorkingDay.tuesday:
          if (weekday == DateTime.tuesday) return true;
        case OrgWorkingDay.wednesday:
          if (weekday == DateTime.wednesday) return true;
        case OrgWorkingDay.thursday:
          if (weekday == DateTime.thursday) return true;
        case OrgWorkingDay.friday:
          if (weekday == DateTime.friday) return true;
        case OrgWorkingDay.saturday:
          if (weekday == DateTime.saturday) return true;
        case OrgWorkingDay.sunday:
          if (weekday == DateTime.sunday) return true;
        default:
          break;
      }
    }
    return false;
  }

  // ── Layout helpers ─────────────────────────────────────────────────────────

  Widget _header(
    BuildContext context,
    CalendarController controller,
    CalendarConfig config,
    bool canShowConfig,
    ValueNotifier<bool> showConfig,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          color: cs.surface,
          child: CalendarNavigationHeader(
            controller: controller,
            onToggleConfig: canShowConfig ? () => showConfig.value = !showConfig.value : null,
            configVisible: showConfig.value,
          ),
        ),
        if (config.showHeader)
          Container(
            padding: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.4)),
              ),
            ),
            child: CalendarHeader(
              multiDayTileComponents: _multiDayTileComponents,
              multiDayHeaderConfiguration: config.multiDayHeaderConfiguration,
              interaction: config.interactionHeader,
            ),
          ),
      ],
    );
  }

  Widget _body(CalendarConfig config) {
    return CalendarBody(
      multiDayTileComponents: _tileComponents,
      monthTileComponents: _multiDayTileComponents,
      multiDayBodyConfiguration: config.multiDayBodyConfiguration,
      monthBodyConfiguration: config.monthBodyConfiguration,
      scheduleTileComponents: _scheduleTileComponents,
      interaction: config.interactionBody,
      snapping: config.snapping,
    );
  }

  // ── Tile components ────────────────────────────────────────────────────────

  static Offset _dragAnchor(Draggable _, BuildContext ctx, Offset __) {
    final box = ctx.findRenderObject()! as RenderBox;
    return Offset(20, box.size.height / 2);
  }

  static TileComponents _buildTileComponents({
    required Widget Function(CalendarEvent, DateTimeRange) tile,
    Widget Function(CalendarEvent, DateTimeRange)? overlayTile,
  }) =>
      TileComponents(
        tileBuilder: tile,
        overlayTileBuilder: overlayTile,
        dropTargetTile: DropTargetTile.builder,
        feedbackTileBuilder: FeedbackTile.builder,
        tileWhenDraggingBuilder: TileWhenDragging.builder,
        dragAnchorStrategy: _dragAnchor,
        verticalResizeHandle: const ResizeHandle.vertical(),
        horizontalResizeHandle: const ResizeHandle.horizontal(),
      );

  static TileComponents get _tileComponents =>
      _buildTileComponents(tile: EventTile.builder);

  static TileComponents get _multiDayTileComponents => _buildTileComponents(
        tile: MultiDayEventTile.builder,
        overlayTile: MultiDayEventTile.overlayBuilder,
      );

  static ScheduleTileComponents get _scheduleTileComponents => ScheduleTileComponents(
        tileBuilder: MultiDayEventTile.builder,
        feedbackTileBuilder: FeedbackTile.builder,
        tileWhenDraggingBuilder: TileWhenDragging.builder,
        dragAnchorStrategy: _dragAnchor,
      );

  // ── Callbacks ──────────────────────────────────────────────────────────────

  CalendarCallbacks _callbacks(
    BuildContext context,
    CalendarController controller,
    DefaultEventsController eventsCtrl,
  ) {
    return CalendarCallbacks(
      onEventTapped: (event, _) {
        controller.deselectEvent();
        if (event is ScheduleCalendarEvent) {
          showDialog(
            context: context,
            builder: (_) => ScheduleEventDialog(event: event),
          );
        }
      },
      onTapped: (_) => controller.deselectEvent(),
      // Disable creation; lessons are booked via the Book Lesson form.
      onEventCreate: null,
    );
  }
}
