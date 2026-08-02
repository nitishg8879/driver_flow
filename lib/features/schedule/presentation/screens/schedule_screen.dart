import 'package:driver_flow_admin/features/schedule/presentation/screens/onboarding/onboarding_student_form.dart';
import 'package:driver_flow_admin/features/schedule/presentation/widgets/schedule_data_source.dart';
import 'package:driver_flow_admin/features/schedule/presentation/widgets/students_sessions_calender_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../utils/components/async_dropdown.dart';
import '../../../../utils/components/capsule_tab_bar.dart';
import '../../../../utils/components/date_range_picker_button.dart';
import '../../../../utils/components/page_header.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../data/models/schedule_model.dart';
import '../cubit/schedule_cubit.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/schedule_stats_row.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _tabIndex = 1;
  ScheduleInstructorOption? _selectedInstructor;
  ScheduleStudentOption? _selectedStudent;
  ScheduleStatus? _selectedStatus;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    context.read<ScheduleCubit>().loadAll();
  }

  void _applyFilters() {
    context.read<ScheduleCubit>().applyFilters(
      instructorId: _selectedInstructor?.id,
      studentId: _selectedStudent?.id,
      status: _selectedStatus,
      dateRange: _dateRange,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Schedule',
            subtitle: 'Manage and coordinate driving lessons',
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterBar(context),
                  const SizedBox(height: 24),
                  const ScheduleStatsRow(),
                  const SizedBox(height: 20),
                  _buildContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final cubit = context.read<ScheduleCubit>();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: AsyncDropdown<ScheduleInstructorOption>(
            fetchItems: cubit.getInstructors,
            itemLabelBuilder: (i) => i.name,
            value: _selectedInstructor,
            labelText: 'Instructor',
            nullItemLabel: 'All Instructors',
            onChanged: (val) {
              setState(() => _selectedInstructor = val);
              _applyFilters();
            },
          ),
        ),
        SizedBox(
          width: 200,
          child: AsyncDropdown<ScheduleStudentOption>(
            fetchItems: cubit.getStudents,
            itemLabelBuilder: (s) => s.name,
            value: _selectedStudent,
            labelText: 'Student',
            nullItemLabel: 'All Students',
            onChanged: (val) {
              setState(() => _selectedStudent = val);
              _applyFilters();
            },
          ),
        ),
        SizedBox(
          width: 200,
          child: AsyncDropdown<ScheduleStatus>(
            fetchItems: () async => ScheduleStatus.values,
            itemLabelBuilder: (s) => s.displayName,
            value: _selectedStatus,
            labelText: 'Status',
            nullItemLabel: 'All Statuses',
            onChanged: (val) {
              setState(() => _selectedStatus = val);
              _applyFilters();
            },
          ),
        ),
        DateRangePickerButton(
          value: _dateRange,
          onChanged: (val) {
            setState(() => _dateRange = val);
            _applyFilters();
          },
        ),
        FilledButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => BlocProvider(
                create: (context) => sl<OnboardingCubit>(),
                child: OnboardingStudentForm(
                  onSuccess: () {
                    context.read<ScheduleCubit>().loadAll();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lesson booked successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Book Lesson'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Spacer(),
        CapsuleTabBar(
          tabs: const [
            (icon: Icons.table_rows_outlined, label: 'Table'),
            (icon: Icons.calendar_month_outlined, label: 'Calendar'),
          ],
          selectedIndex: _tabIndex,
          onChanged: (i) => setState(() => _tabIndex = i),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SizedBox(
      height: 700,
      child: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(60),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is ScheduleError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    Text(state.message),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.read<ScheduleCubit>().loadAll(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ScheduleLoaded) {
            return _tabIndex == 0
                ? Expanded(child: StudentsSessionTable())
                : StudentsSessions(schedules: state.filtered, context: context);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
