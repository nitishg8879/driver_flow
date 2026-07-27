import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../utils/components/async_dropdown.dart';
import '../../../../utils/components/searchable_async_dropdown.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../../../user/data/models/user_model.dart';
import '../../../user/data/repositories/user_repository.dart';
import '../../data/models/schedule_model.dart';
import '../cubit/schedule_cubit.dart';
import '../widgets/schedule_form_dialog.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  bool _showCalendarPicker = false;
  UserModel? _selectedInstructor;
  UserModel? _selectedStudent;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  void _loadSchedules() {
    context.read<ScheduleCubit>().loadSchedules(
      date: _selectedDate,
      instructorId: _selectedInstructor?.id,
      studentId: _selectedStudent?.id,
    );
  }

  void _changeDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _focusedDate = date;
    });
    _loadSchedules();
  }

  Future<void> _openAddForm({TimeOfDay? startTime, TimeOfDay? endTime}) async {
    final cubit = context.read<ScheduleCubit>();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: ScheduleFormDialog(
          prefillDate: _selectedDate,
          prefillStartTime: startTime,
          prefillEndTime: endTime,
        ),
      ),
    );

    if (result == true && mounted) {
      context.showSuccessSnackBar('Schedule saved successfully');
    }
  }

  Future<void> _openEditForm(ScheduleModel schedule) async {
    final cubit = context.read<ScheduleCubit>();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: ScheduleFormDialog(existing: schedule),
      ),
    );

    if (result == true && mounted) {
      context.showSuccessSnackBar('Schedule saved successfully');
    }
  }

  Future<void> _cancelSchedule(ScheduleModel schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Schedule'),
        content: Text(
          'Remove this schedule for "${schedule.studentName}" with "${schedule.instructorName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<ScheduleCubit>().cancelSchedule(schedule.id!, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Schedule',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeDate(
                    _selectedDate.subtract(const Duration(days: 1)),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_month, size: 18),
                  label: Text(
                    '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                  ),
                  onPressed: () => setState(
                    () => _showCalendarPicker = !_showCalendarPicker,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () =>
                      _changeDate(_selectedDate.add(const Duration(days: 1))),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => _openAddForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Schedule'),
                ),
              ],
            ),
            if (_showCalendarPicker)
              Card(
                margin: const EdgeInsets.only(top: 12),
                child: TableCalendar(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDate,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  calendarFormat: CalendarFormat.month,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() => _showCalendarPicker = false);
                    _changeDate(selectedDay);
                  },
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AsyncDropdown<UserModel>(
                    labelText: 'Filter by Instructor',
                    value: _selectedInstructor,
                    fetchItems: () => sl<UserRepository>().getAllActiveByRole(
                      UserRole.instructor,
                    ),
                    itemLabelBuilder: (item) => item.name ?? '-',
                    onChanged: (value) {
                      setState(() => _selectedInstructor = value);
                      _loadSchedules();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SearchableAsyncDropdown<UserModel>(
                    labelText: 'Filter by Student',
                    hintText: 'Type student name...',
                    value: _selectedStudent,
                    searchItems: (query) =>
                        sl<UserRepository>().searchActiveByRole(
                          role: UserRole.student,
                          query: query,
                          limit: 10,
                        ),
                    itemLabelBuilder: (item) => item.name ?? '-',
                    onChanged: (value) {
                      setState(() => _selectedStudent = value);
                      _loadSchedules();
                    },
                  ),
                ),
                if (_selectedInstructor != null || _selectedStudent != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear filters',
                    onPressed: () {
                      setState(() {
                        _selectedInstructor = null;
                        _selectedStudent = null;
                      });
                      _loadSchedules();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (message) => Center(child: Text('Error: $message')),
                    loaded: (schedules, date, instructorId, studentId) {
                      if (schedules.isEmpty) {
                        return const Center(
                          child: Text('No schedules for this day'),
                        );
                      }
                      return ListView.separated(
                        itemCount: schedules.length,
                        separatorBuilder: (_, _) => const Divider(),
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
                          final isCancelled = schedule.status.isCancelled;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isCancelled
                                  ? context.colorScheme.errorContainer
                                  : context.colorScheme.primaryContainer,
                              child: Icon(
                                isCancelled
                                    ? Icons.event_busy
                                    : Icons.event_available,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              '${TimeOfDay.fromDateTime(schedule.startTime).format(context)} - ${TimeOfDay.fromDateTime(schedule.endTime).format(context)}  •  ${schedule.studentName}',
                            ),
                            subtitle: Text(
                              'Instructor: ${schedule.instructorName}  •  Vehicle: ${schedule.vehicleNumber}  •  ${schedule.status.displayName}'
                              '${schedule.reason != null ? '  •  ${schedule.reason}' : ''}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => _openEditForm(schedule),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: 'Cancel',
                                  onPressed: () => _cancelSchedule(schedule),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
