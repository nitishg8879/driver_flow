import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kalender/kalender.dart';

import '../../notifier/calendar_notifier.dart';

class CalendarConfigPanel extends ConsumerWidget {
  final VoidCallback? onDismiss;
  const CalendarConfigPanel({super.key, this.onDismiss});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(calendarConfigNotifierProvider);
    final notifier = ref.read(calendarConfigNotifierProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Configuration',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
                if (onDismiss != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onDismiss,
                    style: IconButton.styleFrom(minimumSize: const Size(28, 28), padding: EdgeInsets.zero),
                  ),
              ],
            ),
            SwitchListTile.adaptive(
              value: config.showHeader,
              onChanged: notifier.setShowHeader,
              title: const Text('Show Header'),
              dense: true,
            ),
            _DropdownRow<int>(
              label: 'Snap Interval',
              value: config.snapping.snapIntervalMinutes,
              items: const [5, 10, 15, 20, 30, 60],
              labelOf: (v) => '$v min',
              onChanged: (v) => notifier.setSnapping(
                config.snapping.copyWith(snapIntervalMinutes: v),
              ),
            ),
            if (config.viewConfiguration is MultiDayViewConfiguration) ...[
              _SectionTitle('Body'),
              SwitchListTile.adaptive(
                value: config.multiDayBodyConfiguration.showMultiDayEvents,
                onChanged: (v) => notifier.setMultiDayBodyConfiguration(
                  config.multiDayBodyConfiguration.copyWith(showMultiDayEvents: v),
                ),
                title: const Text('Show Multi-Day Events'),
                dense: true,
              ),
              _DropdownRow<bool>(
                label: 'Event Layout',
                value: config.multiDayBodyConfiguration.eventLayoutStrategy == sideBySideLayoutStrategy,
                items: const [true, false],
                labelOf: (v) => v ? 'Side by side' : 'Overlap',
                onChanged: (v) => notifier.setMultiDayBodyConfiguration(
                  config.multiDayBodyConfiguration.copyWith(
                    eventLayoutStrategy: v ? sideBySideLayoutStrategy : overlapLayoutStrategy,
                  ),
                ),
              ),
              _SectionTitle('Interaction'),
              SwitchListTile.adaptive(
                value: config.interactionBody.createEventGesture == CreateEventGesture.tap,
                onChanged: (v) => notifier.setInteractionBody(
                  CalendarInteraction(
                    createEventGesture: v ? CreateEventGesture.tap : CreateEventGesture.longPress,
                  ),
                ),
                title: const Text('Tap to Create Event'),
                dense: true,
              ),
              SwitchListTile.adaptive(
                value: config.interactionBody.allowRescheduling,
                onChanged: (v) => notifier.setInteractionBody(
                  config.interactionBody.copyWith(allowRescheduling: v),
                ),
                title: const Text('Enable Drag to Reschedule'),
                dense: true,
              ),
              SwitchListTile.adaptive(
                value: config.interactionBody.allowResizing,
                onChanged: (v) => notifier.setInteractionBody(
                  config.interactionBody.copyWith(allowResizing: v),
                ),
                title: const Text('Enable Resize'),
                dense: true,
              ),
            ] else if (config.viewConfiguration is MonthViewConfiguration) ...[
              _SectionTitle('Month View'),
              SwitchListTile.adaptive(
                value: config.interactionBody.createEventGesture == CreateEventGesture.tap,
                onChanged: (v) => notifier.setInteractionBody(
                  CalendarInteraction(
                    createEventGesture: v ? CreateEventGesture.tap : CreateEventGesture.longPress,
                  ),
                ),
                title: const Text('Tap to Create Event'),
                dense: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, top: 4),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
      );
}

class _DropdownRow<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          DropdownButton<T>(
            value: value,
            isDense: true,
            underline: const SizedBox.shrink(),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(labelOf(e))))
                .toList(),
            onChanged: (v) => v != null ? onChanged(v) : null,
          ),
        ],
      ),
    );
  }
}
