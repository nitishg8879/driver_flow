import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/helpers/validators.dart';
import '../../data/models/holiday_model.dart';
import '../cubit/profile_cubit.dart';

class HolidayDialog extends StatefulWidget {
  final HolidayModel? existing;

  const HolidayDialog({super.key, this.existing});

  @override
  State<HolidayDialog> createState() => _HolidayDialogState();
}

class _HolidayDialogState extends State<HolidayDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late DateTime _selectedDate;
  late bool _isHalfDay;
  bool _isSaving = false;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.existing?.label);
    _selectedDate = widget.existing?.date ?? DateTime.now();
    _isHalfDay = widget.existing?.isHalfDay ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final holiday = HolidayModel(
        id: widget.existing?.id,
        label: _labelController.text.trim(),
        date: _selectedDate,
        isHalfDay: _isHalfDay,
      );

      if (!mounted) return;

      if (_isEditMode) {
        context.read<ProfileCubit>().updateHoliday(holiday);
      } else {
        context.read<ProfileCubit>().addHoliday(holiday);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditMode ? 'Edit Holiday' : 'Add Holiday',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _labelController,
                    labelText: 'Holiday Label',
                    hintText: 'e.g. Diwali, Christmas',
                    validator: (value) =>
                        Validators.validateRequired(value, 'Holiday Label'),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Half Day'),
                    value: _isHalfDay,
                    onChanged: (value) {
                      setState(() => _isHalfDay = value ?? false);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: _isEditMode ? 'Update' : 'Add',
                  onPressed: _isSaving ? null : _submit,
                  isLoading: _isSaving,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: _selectDate,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
