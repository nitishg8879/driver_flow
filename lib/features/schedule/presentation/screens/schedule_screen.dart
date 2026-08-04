import 'package:driver_flow_admin/features/schedule/data/repositories/onboarding_repository.dart';
import 'package:driver_flow_admin/features/schedule/presentation/screens/onboarding/onboarding_student_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/async_dropdown.dart';
import '../../../../utils/components/capsule_tab_bar.dart';
import '../../../../utils/components/date_range_picker_button.dart';
import '../../../../utils/components/page_header.dart';
import '../../../../utils/constants/app_enums.dart';
import '../cubit/onboarding_cubit.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _tabIndex = 1;
  // ScheduleInstructorOption? _selectedInstructor;
  // ScheduleStudentOption? _selectedStudent;
  ScheduleStatus? _selectedStatus;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
  }

  void _applyFilters() {}

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
                  // const ScheduleStatsRow(),
                  const SizedBox(height: 20),
                  // _buildContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    // final cubit = context.read<ScheduleCubit>();
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // SizedBox(
        //   width: 200,
        //   child: AsyncDropdown<UserModel>(
        //     fetchItems: () => sl<UserRepository>().getUsersByRole(
        //       role: UserRole.instructor,
        //       activeOnly: true,
        //       pageSize: 100,
        //     ),
        //     itemLabelBuilder: (i) => i.name,
        //     value: _selectedInstructor,
        //     labelText: 'Instructor',
        //     nullItemLabel: 'All Instructors',
        //     onChanged: (val) {
        //       setState(() => _selectedInstructor = val);
        //       _applyFilters();
        //     },
        //   ),
        // ),
        // SizedBox(
        //   width: 200,
        //   child: AsyncDropdown<ScheduleStudentOption>(
        //     fetchItems: cubit.getStudents,
        //     itemLabelBuilder: (s) => s.name,
        //     value: _selectedStudent,
        //     labelText: 'Student',
        //     nullItemLabel: 'All Students',
        //     onChanged: (val) {
        //       setState(() => _selectedStudent = val);
        //       _applyFilters();
        //     },
        //   ),
        // ),
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
                create: (context) =>
                    OnboardingCubit(repository: OnboardingRepositoryImpl()),
                child: OnboardingStudentForm(
                  onSuccess: () {
                    // context.read<ScheduleCubit>().loadAll();
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
}
