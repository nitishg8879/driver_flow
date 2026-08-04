import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import '../../../data/models/lesson_event.dart'; // ScheduleCalendarEvent
import 'event_detail_card.dart';

class EventDetailOverlay extends StatefulWidget {
  final Widget child;
  final DefaultEventsController eventsController;
  final CalendarController calendarController;

  const EventDetailOverlay({
    super.key,
    required this.child,
    required this.eventsController,
    required this.calendarController,
  });

  static void show(BuildContext context, ScheduleCalendarEvent event, RenderBox renderBox) {
    context.findAncestorStateOfType<_EventDetailOverlayState>()?.show(event, renderBox);
  }

  @override
  State<EventDetailOverlay> createState() => _EventDetailOverlayState();
}

class _EventDetailOverlayState extends State<EventDetailOverlay> with SingleTickerProviderStateMixin {
  final _overlayController = OverlayPortalController();
  late final AnimationController _anim;
  late final Animation<double> _scale;

  CalendarEvent? _event;
  RenderBox? _renderBox;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void show(ScheduleCalendarEvent event, RenderBox renderBox) {
    _event = event;
    _renderBox = renderBox;
    _overlayController.show();
    _anim.forward(from: 0.0);
  }

  void _dismiss() {
    _anim.reverse().then((_) {
      if (_overlayController.isShowing) _overlayController.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (_) {
        return LayoutBuilder(
          builder: (context, constraints) {
            const width = 300.0;
            const height = 220.0;
            final size = constraints.biggest;

            var pos = _renderBox!.localToGlobal(Offset.zero);

            // Vertical bounds
            if (pos.dy + height > size.height) {
              pos = pos.translate(0, size.height - (pos.dy + height) - 25);
            }
            if (pos.dy < 0) pos = pos.translate(0, -pos.dy);

            // Horizontal — prefer right of event, fall back to left
            if (pos.dx + width + _renderBox!.size.width > size.width) {
              pos = pos.translate(-width - 16, 0);
            } else {
              pos = pos.translate(_renderBox!.size.width, 0);
            }
            if (pos.dx < 0) pos = Offset(8, pos.dy);
            if (pos.dx + width > size.width) {
              pos = Offset(size.width - width - 8, pos.dy);
            }

            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: ScaleTransition(
                scale: _scale,
                alignment: Alignment.topLeft,
                child: EventDetailCard(
                  event: _event as ScheduleCalendarEvent,
                  width: min(width, size.width - 16),
                  height: height,
                  onDismiss: _dismiss,
                  eventsController: widget.eventsController,
                  controller: widget.calendarController,
                ),
              ),
            );
          },
        );
      },
      child: widget.child,
    );
  }
}
