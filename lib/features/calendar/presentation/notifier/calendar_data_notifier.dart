import 'package:driver_flow_admin/features/profile/data/models/organization_profile_model.dart';
import 'package:driver_flow_admin/features/profile/data/repositories/profile_repository.dart';
import 'package:driver_flow_admin/features/schedule/data/models/schedule_model.dart';
import 'package:driver_flow_admin/features/schedule/data/repositories/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_data_notifier.g.dart';

class CalendarData {
  final OrganizationProfileModel? profile;
  final List<ScheduleModel> schedules;

  const CalendarData({this.profile, this.schedules = const []});

  CalendarData copyWith({OrganizationProfileModel? profile, List<ScheduleModel>? schedules}) =>
      CalendarData(
        profile: profile ?? this.profile,
        schedules: schedules ?? this.schedules,
      );
}

@riverpod
class CalendarDataNotifier extends _$CalendarDataNotifier {
  @override
  Future<CalendarData> build() async {
    final today = DateTime.now();
    final results = await Future.wait([
      ref.read(profileRepositoryProvider).getOrganizationProfile(),
      ref.read(scheduleRepositoryProvider).getSchedules(
            dateRange: DateTimeRange(start: today, end: today),
          ),
    ]);

    return CalendarData(
      profile: results[0] as OrganizationProfileModel?,
      schedules: results[1] as List<ScheduleModel>,
    );
  }

  Future<void> onRangeChanged(DateTimeRange range) async {
    final current = state.valueOrNull;
    final schedules = await ref.read(scheduleRepositoryProvider).getSchedules(dateRange: range);
    state = AsyncData(CalendarData(
      profile: current?.profile,
      schedules: schedules,
    ));
  }
}
