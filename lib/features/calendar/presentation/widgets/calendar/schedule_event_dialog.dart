import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/lesson_event.dart';

class ScheduleEventDialog extends StatelessWidget {
  final ScheduleCalendarEvent event;
  const ScheduleEventDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final s = event.schedule;
    final cs = Theme.of(context).colorScheme;
    final color = event.color;
    final fmt = DateFormat('MMM dd, yyyy • hh:mm a');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 6, color: color),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s.studentName ?? 'Lesson',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(32, 32),
                          padding: EdgeInsets.zero,
                          backgroundColor: cs.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _row(context, Icons.person_outline, 'Student', s.studentName ?? '—'),
                  const SizedBox(height: 8),
                  _row(context, Icons.school_outlined, 'Instructor', s.instructorName ?? '—'),
                  const SizedBox(height: 8),
                  _row(
                    context,
                    Icons.play_circle_outline,
                    'Start',
                    s.startTime != null ? fmt.format(s.startTime!) : '—',
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  _row(
                    context,
                    Icons.stop_circle_outlined,
                    'End',
                    s.endTime != null ? fmt.format(s.endTime!) : '—',
                    iconColor: cs.error,
                  ),
                  const SizedBox(height: 8),
                  _row(context, Icons.info_outline, 'Status', s.status.displayName),
                  if (s.notes != null && s.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _row(context, Icons.notes_outlined, 'Notes', s.notes!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor ?? cs.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
