import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../utils/components/async_dropdown.dart';
import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/components/searchable_async_dropdown.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../user/data/models/user_model.dart';
import '../../../user/data/repositories/user_repository.dart';
import '../../../vehicles/data/models/vehicle_model.dart';
import '../../../vehicles/data/repositories/vehicle_repository.dart';
import '../../data/models/schedule_model.dart';
import '../cubit/schedule_cubit.dart';

/// Dialog used both for creating and editing a [ScheduleModel] slot.
/// Pass [existing] to pre-fill the form for edit mode, or [prefillDate] +
/// [prefillStartTime]/[prefillEndTime] when creating from an empty
/// calendar slot.
class ScheduleFormDialog extends StatefulWidget {
  final ScheduleModel? existing;
  final DateTime? prefillDate;
  final TimeOfDay? prefillStartTime;
  final TimeOfDay? prefillEndTime;

  const ScheduleFormDialog({
    super.key,
    this.existing,
    this.prefillDate,
    this.prefillStartTime,
    this.prefillEndTime,
  });

  @override
  State<ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends State<ScheduleFormDialog> {
  late final TextEditingController _reasonController;
  UserModel? _selectedInstructor;
  UserModel? _selectedStudent;
  VehicleModel? _selectedVehicle;
  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  ScheduleStatus _status = ScheduleStatus.scheduled;
  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _date = existing?.date ?? widget.prefillDate ?? DateTime.now();
    _startTime = existing != null
        ? TimeOfDay.fromDateTime(existing.startTime)
        : widget.prefillStartTime ?? TimeOfDay.now();
    _endTime = existing != null
        ? TimeOfDay.fromDateTime(existing.endTime)
        : widget.prefillEndTime ??
              TimeOfDay(hour: _startTime.hour + 1, minute: _startTime.minute);
    _status = existing?.status ?? ScheduleStatus.scheduled;
    _reasonController = TextEditingController(text: existing?.reason);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (_selectedInstructor == null ||
        _selectedStudent == null ||
        _selectedVehicle == null) {
      setState(
        () => _errorMessage = 'Please select instructor, student and vehicle',
      );
      return;
    }

    final startDateTime = _combine(_date, _startTime);
    final endDateTime = _combine(_date, _endTime);
    if (!endDateTime.isAfter(startDateTime)) {
      setState(() => _errorMessage = 'End time must be after start time');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final cubit = context.read<ScheduleCubit>();
    final model =
        (widget.existing ??
                ScheduleModel(
                  studentId: '',
                  studentName: '',
                  instructorId: '',
                  instructorName: '',
                  vehicleId: '',
                  vehicleNumber: '',
                  date: _date,
                  startTime: startDateTime,
                  endTime: endDateTime,
                ))
            .copyWith(
              studentId: _selectedStudent!.id!,
              studentName: _selectedStudent!.name ?? '',
              instructorId: _selectedInstructor!.id!,
              instructorName: _selectedInstructor!.name ?? '',
              vehicleId: _selectedVehicle!.id!,
              vehicleNumber: _selectedVehicle!.vehicleNumber,
              date: _date,
              startTime: startDateTime,
              endTime: endDateTime,
              status: _status,
              reason: _reasonController.text.trim().isEmpty
                  ? null
                  : _reasonController.text.trim(),
            );

    final error = _isEditMode
        ? await cubit.updateSchedule(model)
        : await cubit.createSchedule(model);

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _isSaving = false;
        _errorMessage = error;
      });
      return;
    }

    setState(() => _isSaving = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Schedule' : 'Add Schedule'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.errorContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text(
                        '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _date = picked);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time, size: 16),
                      label: Text('Start: ${_startTime.format(context)}'),
                      onPressed: () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time, size: 16),
                      label: Text('End: ${_endTime.format(context)}'),
                      onPressed: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AsyncDropdown<UserModel>(
                labelText: 'Instructor',
                value: _selectedInstructor,
                fetchItems: () => sl<UserRepository>().getAllActiveByRole(
                  UserRole.instructor,
                ),
                itemLabelBuilder: (item) => item.name ?? '-',
                onChanged: (value) =>
                    setState(() => _selectedInstructor = value),
              ),
              const SizedBox(height: 16),
              SearchableAsyncDropdown<UserModel>(
                labelText: 'Student',
                value: _selectedStudent,
                searchItems: (query) => sl<UserRepository>().searchActiveByRole(
                  role: UserRole.student,
                  query: query,
                  limit: 10,
                ),
                itemLabelBuilder: (item) => item.name ?? '-',
                onChanged: (value) => setState(() => _selectedStudent = value),
              ),
              const SizedBox(height: 16),
              AsyncDropdown<VehicleModel>(
                labelText: 'Vehicle',
                value: _selectedVehicle,
                fetchItems: () => sl<VehicleRepository>().getAllActive(),
                itemLabelBuilder: (item) => item.vehicleNumber,
                onChanged: (value) => setState(() => _selectedVehicle = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ScheduleStatus>(
                initialValue: _status,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ScheduleStatus.values
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _reasonController,
                labelText: 'Reason (optional)',
                hintText: 'e.g. Instructor unavailable',
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: 'Save',
          isLoading: _isSaving,
          onPressed: _isSaving ? null : _submit,
          width: 100,
        ),
      ],
    );
  }
}
