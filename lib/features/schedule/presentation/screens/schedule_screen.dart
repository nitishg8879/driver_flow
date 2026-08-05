import 'package:driver_flow_admin/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:driver_flow_admin/features/schedule/presentation/screens/onboarding/onboarding_student_form.dart';
import 'package:driver_flow_admin/features/user/data/models/user_model.dart';
import 'package:driver_flow_admin/features/user/data/repositories/user_repository.dart';
import 'package:driver_flow_admin/utils/components/searchable_async_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/components/async_dropdown.dart';
import '../../../../utils/components/capsule_tab_bar.dart';
import '../../../../utils/components/date_range_picker_button.dart';
import '../../../../utils/components/page_header.dart';
import '../../../../utils/constants/app_enums.dart';

class ScheduleScreen extends HookConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedInstructor = useState<UserModel?>(null);
    final selectedStudent = useState<UserModel?>(null);
    final selectedStatus = useState<ScheduleStatus?>(null);
    final selectedDateRange = useState<DateTimeRange?>(null);
    final tabIndex = useState<int>(0);

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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: AsyncDropdown<UserModel>(
                          fetchItems: () => ref
                              .read(userRepositoryProvider)
                              .getUsersByRole(
                                role: UserRole.instructor,
                                activeOnly: true,
                                paginated: false,
                                pageSize: 10,
                              )
                              .then((value) => value.items),
                          itemLabelBuilder: (i) => i.name ?? 'Unknown',
                          value: selectedInstructor.value,
                          labelText: 'Instructor',
                          nullItemLabel: 'All Instructors',
                          onChanged: (val) {
                            selectedInstructor.value = val;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: SearchableAsyncDropdown<UserModel>(
                          itemLabelBuilder: (s) => s.name ?? 'Unknown',
                          value: selectedStudent.value,
                          labelText: 'Student',
                          onChanged: (val) {
                            selectedStudent.value = val;
                          },
                          searchItems: (String query) {
                            return ref
                                .read(userRepositoryProvider)
                                .getUsers(
                                  role: UserRole.student,
                                  activeOnly: true,
                                  pageSize: 20,
                                  searchQuery: query,
                                )
                                .then((value) => value.items);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: AsyncDropdown<ScheduleStatus>(
                          fetchItems: () async => ScheduleStatus.values,
                          itemLabelBuilder: (s) => s.displayName,
                          value: selectedStatus.value,
                          labelText: 'Status',
                          nullItemLabel: 'All Statuses',
                          onChanged: (val) {
                            selectedStatus.value = val;
                          },
                        ),
                      ),
                      DateRangePickerButton(
                        value: selectedDateRange.value,
                        onChanged: (val) {
                          selectedDateRange.value = val;
                        },
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => OnboardingStudentForm(),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Book Lesson'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      CapsuleTabBar(
                        tabs: const [
                          (icon: Icons.table_rows_outlined, label: 'Table'),
                          (
                            icon: Icons.calendar_month_outlined,
                            label: 'Calendar',
                          ),
                        ],
                        selectedIndex: tabIndex.value,
                        onChanged: (i) => tabIndex.value = i,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Expanded(child: CalendarScreen()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
