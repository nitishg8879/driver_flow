import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/calendar_data_notifier.dart';
import '../widgets/calendar/calendar_widget.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(calendarDataNotifierProvider);
    final notifier = ref.read(calendarDataNotifierProvider.notifier);

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(e.toString()),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(calendarDataNotifierProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) => CalendarWidget(
        profile: data.profile,
        schedules: data.schedules,
        onRangeChanged: notifier.onRangeChanged,
      ),
    );
  }
}
