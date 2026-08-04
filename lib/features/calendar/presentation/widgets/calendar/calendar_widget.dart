import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kalender/kalender.dart';

import '../../../data/models/lesson_event.dart';
import '../../notifier/calendar_notifier.dart';
import '../configuration/configuration_panel.dart';
import 'event_detail_overlay.dart';
import 'event_tiles.dart';
import 'navigation_header.dart';
import 'resize_handle.dart';

class CalendarWidget extends HookConsumerWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(calendarConfigNotifierProvider);
    final eventsCtrl = ref.watch(eventsControllerProvider);
    final showConfig = useState(true);

    // CalendarController is local — no need to share globally
    final calendarController = useMemoized(() => CalendarController());
    useEffect(() => calendarController.dispose, []);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canShowConfig = constraints.maxWidth > 500;
        final configWidth = (constraints.maxWidth * 0.30).clamp(260.0, 380.0);

        return EventDetailOverlay(
          eventsController: eventsCtrl,
          calendarController: calendarController,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CalendarView(
                  calendarController: calendarController,
                  eventsController: eventsCtrl,
                  viewConfiguration: config.viewConfiguration,
                  header: _buildHeader(context, calendarController, config, canShowConfig, showConfig),
                  body: _buildBody(config),
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
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    CalendarController controller,
    dynamic config,
    bool canShowConfig,
    ValueNotifier<bool> showConfig,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: !config.showHeader
                ? Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  )
                : null,
          ),
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
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
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

  Widget _buildBody(dynamic config) {
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

  static Offset _dragAnchor(Draggable _, BuildContext ctx, Offset pos) {
    final box = ctx.findRenderObject()! as RenderBox;
    return Offset(20, box.size.height / 2);
  }

  static TileComponents _buildComponents({
    required Widget Function(CalendarEvent, DateTimeRange) tile,
    Widget Function(CalendarEvent, DateTimeRange)? overlayTile,
  }) {
    return TileComponents(
      tileBuilder: tile,
      overlayTileBuilder: overlayTile,
      dropTargetTile: DropTargetTile.builder,
      feedbackTileBuilder: FeedbackTile.builder,
      tileWhenDraggingBuilder: TileWhenDragging.builder,
      dragAnchorStrategy: _dragAnchor,
      verticalResizeHandle: const ResizeHandle.vertical(),
      horizontalResizeHandle: const ResizeHandle.horizontal(),
    );
  }

  static TileComponents get _tileComponents => _buildComponents(tile: EventTile.builder);

  static TileComponents get _multiDayTileComponents => _buildComponents(
        tile: MultiDayEventTile.builder,
        overlayTile: MultiDayEventTile.overlayBuilder,
      );

  static ScheduleTileComponents get _scheduleTileComponents => ScheduleTileComponents(
        tileBuilder: MultiDayEventTile.builder,
        feedbackTileBuilder: FeedbackTile.builder,
        tileWhenDraggingBuilder: TileWhenDragging.builder,
        dragAnchorStrategy: _dragAnchor,
      );

  CalendarCallbacks _callbacks(
    BuildContext context,
    CalendarController controller,
    DefaultEventsController eventsCtrl,
  ) {
    return CalendarCallbacks(
      onEventTapped: (event, renderBox) {
        controller.deselectEvent();
        controller.selectEvent(event);
        EventDetailOverlay.show(context, event as LessonEvent, renderBox);
      },
      onTapped: (_) => controller.deselectEvent(),
      onEventCreate: (event) => LessonEvent(
        dateTimeRange: DateTimeRange(start: event.start, end: event.end),
        title: 'New Lesson',
      ),
      onEventCreated: (event) => eventsCtrl.addEvent(event),
      onEventChanged: (event, updated) => eventsCtrl.updateEvent(
        event: event as LessonEvent,
        updatedEvent: updated as LessonEvent,
      ),
    );
  }
}
