import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

import '../../../data/models/lesson_event.dart';

class EventDetailCard extends StatefulWidget {
  final LessonEvent event;
  final double height;
  final double width;
  final VoidCallback onDismiss;
  final DefaultEventsController eventsController;
  final CalendarController controller;

  const EventDetailCard({
    super.key,
    required this.event,
    required this.height,
    required this.width,
    required this.onDismiss,
    required this.eventsController,
    required this.controller,
  });

  @override
  State<EventDetailCard> createState() => _EventDetailCardState();
}

class _EventDetailCardState extends State<EventDetailCard> {
  late LessonEvent event = widget.event;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loc = MaterialLocalizations.of(context);
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final color = event.color ?? LessonEvent.defaultColor;

    return Card(
      elevation: 8,
      shadowColor: cs.shadow.withValues(alpha: 0.2),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Column(
            children: [
              Container(height: 4, color: color),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 36,
                            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: event.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: cs.primary)),
                                hintText: 'Event title',
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                final updated = event.copyWith(title: value);
                                widget.eventsController.updateEvent(event: event, updatedEvent: updated);
                                setState(() => event = updated);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: widget.onDismiss,
                            icon: const Icon(Icons.close, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: cs.surfaceContainerHighest,
                              minimumSize: const Size(32, 32),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _TimeRow(
                        icon: Icons.play_circle_outline,
                        iconColor: Colors.green,
                        label: 'Start',
                        dateText: loc.formatShortDate(event.start),
                        timeText: loc.formatTimeOfDay(TimeOfDay.fromDateTime(event.start), alwaysUse24HourFormat: use24),
                        onDateTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: event.start,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                          );
                          if (d == null) return;
                          final s = d.copyWith(hour: event.start.hour, minute: event.start.minute);
                          if (s.isAfter(event.end)) return;
                          _update(DateTimeRange(start: s, end: event.end));
                        },
                        onTimeTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(event.start),
                          );
                          if (t == null) return;
                          final s = event.start.copyWith(hour: t.hour, minute: t.minute);
                          if (s.isAfter(event.end)) return;
                          _update(DateTimeRange(start: s, end: event.end));
                        },
                      ),
                      const SizedBox(height: 4),
                      _TimeRow(
                        icon: Icons.stop_circle_outlined,
                        iconColor: cs.error,
                        label: 'End',
                        dateText: loc.formatShortDate(event.end),
                        timeText: loc.formatTimeOfDay(TimeOfDay.fromDateTime(event.end), alwaysUse24HourFormat: use24),
                        onDateTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: event.end,
                            firstDate: event.start,
                            lastDate: DateTime(2035),
                          );
                          if (d == null) return;
                          final e = d.copyWith(hour: event.end.hour, minute: event.end.minute);
                          if (e.isBefore(event.start)) return;
                          _update(DateTimeRange(start: event.start, end: e));
                        },
                        onTimeTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(event.end),
                          );
                          if (t == null) return;
                          final e = event.end.copyWith(hour: t.hour, minute: t.minute);
                          if (e.isBefore(event.start)) return;
                          _update(DateTimeRange(start: event.start, end: e));
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            widget.controller.deselectEvent();
                            widget.eventsController.removeEvent(event);
                            widget.onDismiss();
                          },
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Delete'),
                          style: FilledButton.styleFrom(
                            backgroundColor: cs.errorContainer,
                            foregroundColor: cs.onErrorContainer,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _update(DateTimeRange range) {
    final updated = event.copyWith(dateTimeRange: range);
    widget.eventsController.updateEvent(event: event, updatedEvent: updated);
    setState(() => event = updated);
  }
}

class _TimeRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String dateText;
  final String timeText;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;

  const _TimeRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.dateText,
    required this.timeText,
    required this.onDateTap,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 12),
        _chip(context, cs, dateText, onDateTap),
        const SizedBox(width: 8),
        _chip(context, cs, timeText, onTimeTap),
      ],
    );
  }

  Widget _chip(BuildContext context, ColorScheme cs, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
