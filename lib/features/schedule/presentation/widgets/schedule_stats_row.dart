import 'package:driver_flow_admin/features/schedule/data/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/stat_card.dart';
import '../../../../utils/constants/app_enums.dart';
import '../cubit/schedule_cubit.dart';

class ScheduleStatsRow extends StatelessWidget {
  const ScheduleStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final schedules = state is ScheduleLoaded
            ? state.allSchedules
            : <ScheduleModel>[];
        final total = schedules.length;
        final pending = schedules
            .where((s) => s.status == ScheduleStatus.scheduled)
            .length;
        final completed = schedules
            .where((s) => s.status == ScheduleStatus.completed)
            .length;
        final cancelled = schedules.where((s) => s.status.isCancelled).length;

        return Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Total',
                count: total,
                accentColor: Colors.indigo,
                icon: Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Pending',
                count: pending,
                accentColor: Colors.orange,
                icon: Icons.hourglass_empty_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Completed',
                count: completed,
                accentColor: Colors.green,
                icon: Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Cancelled',
                count: cancelled,
                accentColor: Colors.red,
                icon: Icons.cancel_outlined,
              ),
            ),
          ],
        );
      },
    );
  }
}
