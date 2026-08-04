import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kalender/kalender.dart';

import '../../notifier/calendar_notifier.dart';
import '../../notifier/calendar_state.dart';
import '../toolbar/chip_dropdown.dart';

class CalendarNavigationHeader extends ConsumerWidget {
  final CalendarController controller;
  final VoidCallback? onToggleConfig;
  final bool configVisible;

  const CalendarNavigationHeader({
    super.key,
    required this.controller,
    this.onToggleConfig,
    this.configVisible = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(calendarConfigNotifierProvider);
    final notifier = ref.read(calendarConfigNotifierProvider.notifier);
    final cs = Theme.of(context).colorScheme;
    final allViews = CalendarConfig.viewConfigurations();

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;

        List<PopupMenuEntry<ViewConfiguration>> viewItems(BuildContext _) => [
              for (final v in allViews)
                ChipDropdown.checkMenuItem(
                  value: v,
                  label: v.name,
                  selected: v.runtimeType == config.viewConfiguration.runtimeType &&
                      v.name == config.viewConfiguration.name,
                  colorScheme: cs,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
            ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            spacing: 4,
            children: [
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final vc = controller.viewController;
                  String label = '';
                  if (vc is MultiDayViewController) {
                    final range = vc.visibleDateTimeRange.value;
                    if (range != null) {
                      label = _formatRange(context, range.start, range.end);
                    }
                  }
                  return TextButton(
                    onPressed: () => controller.animateToDate(DateTime.now()),
                    style: TextButton.styleFrom(
                      foregroundColor: cs.onSurface,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      label.isNotEmpty ? label : 'Today',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => controller.animateToPreviousPage(),
                tooltip: 'Previous',
              ),
              FilledButton.tonal(
                onPressed: () => controller.animateToDate(DateTime.now()),
                style: FilledButton.styleFrom(
                  backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                  foregroundColor: cs.onSurface,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Today'),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => controller.animateToNextPage(),
                tooltip: 'Next',
              ),
              if (wide)
                ChipDropdown<ViewConfiguration>(
                  tooltip: 'View type',
                  icon: Icons.view_week_outlined,
                  label: config.viewConfiguration.name,
                  onSelected: notifier.setViewConfiguration,
                  itemBuilder: viewItems,
                )
              else
                PopupMenuButton<ViewConfiguration>(
                  tooltip: 'View type',
                  onSelected: notifier.setViewConfiguration,
                  icon: Icon(Icons.view_week_outlined, color: cs.primary),
                  itemBuilder: viewItems,
                ),
              if (onToggleConfig != null)
                IconButton(
                  icon: Icon(configVisible ? Icons.tune : Icons.tune_outlined),
                  onPressed: onToggleConfig,
                  tooltip: configVisible ? 'Hide settings' : 'Show settings',
                  style: IconButton.styleFrom(
                    backgroundColor: configVisible
                        ? cs.primaryContainer
                        : cs.surfaceContainerHighest.withValues(alpha: 0.5),
                    foregroundColor: configVisible ? cs.onPrimaryContainer : cs.onSurface,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatRange(BuildContext context, DateTime start, DateTime end) {
    final loc = MaterialLocalizations.of(context);
    if (start.month == end.month && start.year == end.year) {
      return '${_monthName(start.month)} ${start.year}';
    }
    return '${loc.formatShortDate(start)} – ${loc.formatShortDate(end)}';
  }

  String _monthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month];
  }
}
