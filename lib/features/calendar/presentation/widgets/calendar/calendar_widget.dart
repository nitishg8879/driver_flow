import 'package:driver_flow_admin/utils/helpers/app_logger.dart';
import 'package:flutter/material.dart';
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

class CalendarWidget extends ConsumerStatefulWidget {
  final OrganizationProfileModel? profile;
  final List<ScheduleModel> schedules;
  final Future<void> Function(DateTimeRange range)? onRangeChanged;

  const CalendarWidget({
    super.key,
    this.profile,
    this.schedules = const [],
    this.onRangeChanged,
  });

  @override
  ConsumerState<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<CalendarWidget> {
  late final CalendarController _calendarController;
  late final DefaultEventsController _eventsCtrl;
  bool _showConfig = false;
  final _logger = AppLogger("CalendarWidget");

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventsCtrl = DefaultEventsController();
    _logger.debug(
      "Schedules Length:${widget.schedules.length}\nProfile Data:${widget.profile?.toJson()}\nSchedules List Data:${widget.schedules.map((e) => e.toJson())}",
    );

    _rebuildEvents();
    _calendarController.addListener(_onRangeChanged);
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.schedules != widget.schedules ||
        oldWidget.profile != widget.profile) {
      _rebuildEvents();
    }
  }

  @override
  void dispose() {
    _calendarController.removeListener(_onRangeChanged);
    _calendarController.dispose();
    _eventsCtrl.dispose();
    super.dispose();
  }

  void _rebuildEvents() {
    _eventsCtrl.clearEvents();
    for (final s in widget.schedules) {
      _eventsCtrl.addEvent(ScheduleCalendarEvent.from(s));
    }
    final workingDays = widget.profile?.workingDays;
    if (workingDays != null) {
      final today = DateTime.now();
      final base = DateTime(today.year, today.month, today.day);
      for (var i = -180; i <= 365; i++) {
        final day = base.add(Duration(days: i));
        if (!_isWorkingDay(day, workingDays)) {
          _eventsCtrl.addEvent(
            ClosedDayEvent(
              dateTimeRange: DateTimeRange(
                start: day,
                end: day.add(const Duration(days: 1)),
              ),
            ),
          );
        }
      }
    }
  }

  void _onRangeChanged() {
    final vc = _calendarController.viewController;
    if (vc is MultiDayViewController) {
      final range = vc.visibleDateTimeRange.value;
      if (range != null) {
        widget.onRangeChanged?.call(range.forLocation());
      }
    }
  }

  static bool _isWorkingDay(DateTime day, List<OrgWorkingDay> workingDays) {
    if (workingDays.isEmpty) return true;
    final w = day.weekday;
    for (final wd in workingDays) {
      switch (wd) {
        case OrgWorkingDay.monday:
          if (w == DateTime.monday) return true;
        case OrgWorkingDay.tuesday:
          if (w == DateTime.tuesday) return true;
        case OrgWorkingDay.wednesday:
          if (w == DateTime.wednesday) return true;
        case OrgWorkingDay.thursday:
          if (w == DateTime.thursday) return true;
        case OrgWorkingDay.friday:
          if (w == DateTime.friday) return true;
        case OrgWorkingDay.saturday:
          if (w == DateTime.saturday) return true;
        case OrgWorkingDay.sunday:
          if (w == DateTime.sunday) return true;
        default:
          break;
      }
    }
    return false;
  }

  /// Applies profile vehicle times to the view config inline — avoids post-frame timing issues.
  ViewConfiguration _effectiveViewConfig(CalendarConfig config) {
    final vc = config.viewConfiguration;
    final start = widget.profile?.vechileStartTime;
    final end = widget.profile?.vechileEndTime;
    if (vc is MultiDayViewConfiguration && start != null && end != null) {
      return vc.copyWith(
        timeOfDayRange: TimeOfDayRange(start: start, end: end),
        initialTimeOfDay: start,
      );
    }
    return vc;
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(calendarConfigNotifierProvider);
    final effectiveViewConfig = _effectiveViewConfig(config);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowConfig = constraints.maxWidth > 500;
        final configWidth = (constraints.maxWidth * 0.30).clamp(260.0, 380.0);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CalendarView(
                calendarController: _calendarController,
                eventsController: _eventsCtrl,
                viewConfiguration: effectiveViewConfig,
                header: _buildHeader(context, config, canShowConfig),
                body: _buildBody(config),
                callbacks: _buildCallbacks(context),
              ),
            ),
            if (canShowConfig)
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.centerLeft,
                child: _showConfig
                    ? SizedBox(
                        width: configWidth,
                        height: constraints.maxHeight,
                        child: CalendarConfigPanel(
                          onDismiss: () => setState(() => _showConfig = false),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
          ],
        );
      },
    );
  }

  // ── Layout helpers ─────────────────────────────────────────────────────────

  Widget _buildHeader(
    BuildContext context,
    CalendarConfig config,
    bool canShowConfig,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          color: cs.surface,
          child: CalendarNavigationHeader(
            controller: _calendarController,
            onToggleConfig: canShowConfig
                ? () => setState(() => _showConfig = !_showConfig)
                : null,
            configVisible: _showConfig,
          ),
        ),
        if (config.showHeader)
          Container(
            padding: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                ),
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

  Widget _buildBody(CalendarConfig config) {
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
  }) => TileComponents(
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

  static ScheduleTileComponents get _scheduleTileComponents =>
      ScheduleTileComponents(
        tileBuilder: MultiDayEventTile.builder,
        feedbackTileBuilder: FeedbackTile.builder,
        tileWhenDraggingBuilder: TileWhenDragging.builder,
        dragAnchorStrategy: _dragAnchor,
      );

  // ── Callbacks ──────────────────────────────────────────────────────────────

  CalendarCallbacks _buildCallbacks(BuildContext context) {
    return CalendarCallbacks(
      onEventTapped: (event, _) {
        _calendarController.deselectEvent();
        if (event is ScheduleCalendarEvent) {
          showDialog(
            context: context,
            builder: (_) => ScheduleEventDialog(event: event),
          );
        }
      },
      onTapped: (_) => _calendarController.deselectEvent(),
      // Disable creation; lessons are booked via the Book Lesson form.
      onEventCreate: null,
    );
  }
}
