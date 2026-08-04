import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import '../../../data/models/lesson_event.dart';

Color _resolveColor(BuildContext context, Color eventColor, double blend) {
  final surface = Theme.of(context).colorScheme.surfaceContainerLow;
  return Color.lerp(surface, eventColor, blend)!;
}

Color _colorOf(LessonEvent event) => event.color ?? LessonEvent.defaultColor;

abstract class _BaseTile extends StatelessWidget {
  final LessonEvent event;
  final DateTimeRange tileRange;
  const _BaseTile({super.key, required this.event, required this.tileRange});

  Color get color => _colorOf(event);
  bool get continuesAfter => event.dateTimeRange.end.isAfter(tileRange.end);
  bool get continuesBefore => event.dateTimeRange.start.isBefore(tileRange.start);

  static final defaultRadius = BorderRadius.circular(6);
}

class EventTile extends _BaseTile {
  const EventTile({super.key, required super.event, required super.tileRange});

  static EventTile builder(CalendarEvent e, DateTimeRange r) =>
      EventTile(event: e as LessonEvent, tileRange: r);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _resolveColor(context, color, isDark ? 0.25 : 0.12),
        borderRadius: _BaseTile.defaultRadius,
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          event.title,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class MultiDayEventTile extends _BaseTile {
  final bool overlay;
  const MultiDayEventTile({super.key, required super.event, required super.tileRange, this.overlay = false});

  static MultiDayEventTile builder(CalendarEvent e, DateTimeRange r) =>
      MultiDayEventTile(event: e as LessonEvent, tileRange: r);
  static MultiDayEventTile overlayBuilder(CalendarEvent e, DateTimeRange r) =>
      MultiDayEventTile(event: e as LessonEvent, tileRange: r, overlay: true);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blend = overlay ? (isDark ? 0.35 : 0.22) : (isDark ? 0.30 : 0.18);
    const r = Radius.circular(6);
    final radius = BorderRadius.horizontal(
      left: continuesBefore ? Radius.zero : r,
      right: continuesAfter ? Radius.zero : r,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _resolveColor(context, color, blend),
        borderRadius: radius,
        border: continuesBefore ? null : Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
        child: Row(
          children: [
            if (continuesBefore) Icon(Icons.chevron_left, size: 14, color: color.withValues(alpha: 0.6)),
            Expanded(
              child: Text(
                event.title,
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (continuesAfter) Icon(Icons.chevron_right, size: 14, color: color.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}

class FeedbackTile extends StatelessWidget {
  final LessonEvent event;
  final Size size;
  const FeedbackTile({super.key, required this.event, required this.size});
  static FeedbackTile builder(CalendarEvent e, Size s) =>
      FeedbackTile(event: e as LessonEvent, size: s);

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(event);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size.width * 0.85,
      height: size.height,
      decoration: BoxDecoration(
        color: _resolveColor(context, color, 0.18),
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: color, width: 3)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))],
      ),
    );
  }
}

class DropTargetTile extends StatelessWidget {
  final LessonEvent event;
  const DropTargetTile({super.key, required this.event});
  static DropTargetTile builder(CalendarEvent e) => DropTargetTile(event: e as LessonEvent);

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(event);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _resolveColor(context, color, 0.08).withValues(alpha: 0.3),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class TileWhenDragging extends StatelessWidget {
  final LessonEvent event;
  const TileWhenDragging({super.key, required this.event});
  static TileWhenDragging builder(CalendarEvent e) => TileWhenDragging(event: e as LessonEvent);

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(event);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _resolveColor(context, color, 0.06),
        border: Border(left: BorderSide(color: color.withValues(alpha: 0.25), width: 3)),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
