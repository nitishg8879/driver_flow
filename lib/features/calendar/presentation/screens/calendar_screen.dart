import 'package:flutter/material.dart';

import '../../../../../features/profile/data/models/organization_profile_model.dart';
import '../../../../../features/schedule/data/models/schedule_model.dart';
import '../widgets/calendar/calendar_widget.dart';

class CalendarScreen extends StatelessWidget {
  final OrganizationProfileModel? profile;
  final List<ScheduleModel> schedules;
  final Future<List<ScheduleModel>> Function(DateTimeRange range)? onRangeChanged;

  const CalendarScreen({
    super.key,
    this.profile,
    this.schedules = const [],
    this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CalendarWidget(
      profile: profile,
      schedules: schedules,
      onRangeChanged: onRangeChanged,
    );
  }
}
