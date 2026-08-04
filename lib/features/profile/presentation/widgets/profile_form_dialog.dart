import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/components/app_loader_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/helpers/validators.dart';
import '../../data/models/organization_profile_model.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileFormDialog extends ConsumerStatefulWidget {
  final OrganizationProfileModel? existing;
  final VoidCallback? onSaved;

  const ProfileFormDialog({super.key, this.existing, this.onSaved});

  @override
  ConsumerState<ProfileFormDialog> createState() => _ProfileFormDialogState();
}

class _ProfileFormDialogState extends ConsumerState<ProfileFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _aboutController;
  List<OrgWorkingDay> _selectedWorkingDays = [];
  TimeOfDay? _officeStartTime;
  TimeOfDay? _officeEndTime;
  TimeOfDay? _vechileStartTime;
  TimeOfDay? _vechileEndTime;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.organizationName);
    _phoneController = TextEditingController(text: existing?.phoneNumber);
    _aboutController = TextEditingController(text: existing?.aboutUs);
    _selectedWorkingDays = List.from(existing?.workingDays ?? []);
    _officeStartTime = existing?.officeStartTime;
    _officeEndTime = existing?.officeEndTime;
    _vechileStartTime = existing?.vechileStartTime;
    _vechileEndTime = existing?.vechileEndTime;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWorkingDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one working day')),
      );
      return;
    }

    try {
      final model = OrganizationProfileModel(
        email: widget.existing?.email,
        organizationName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        aboutUs: _aboutController.text.trim(),
        workingDays: _selectedWorkingDays,
        officeStartTime: _officeStartTime,
        officeEndTime: _officeEndTime,
        vechileStartTime: _vechileStartTime,
        vechileEndTime: _vechileEndTime,
      );
      await ref.read(profileRepositoryProvider).updateOrganizationProfile(model);
      if (!mounted) return;
      widget.onSaved?.call();
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
              'Edit Organization Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    initialValue: widget.existing?.email,
                    labelText: 'Email',
                    enabled: false,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Organization Name',
                    validator: (value) =>
                        Validators.validateRequired(value, 'Organization Name'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Phone Number'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _aboutController,
                    labelText: 'About Us',
                    maxLines: 4,
                    validator: (value) =>
                        Validators.validateRequired(value, 'About Us'),
                  ),
                  const SizedBox(height: 16),
                  _buildTimePickers(),
                  const SizedBox(height: 24),
                  _buildWorkingDaysSection(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledLoaderButton(
                  onPressed: _submit,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickers() {
    String fmt(TimeOfDay? t) => t != null ? t.format(context) : 'Not set';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Office Hours', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                label: 'Office Start',
                value: fmt(_officeStartTime),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _officeStartTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _officeStartTime = picked);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimeField(
                label: 'Office End',
                value: fmt(_officeEndTime),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _officeEndTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _officeEndTime = picked);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Vehicle Hours', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTimeField(
                label: 'Vehicle Start',
                value: fmt(_vechileStartTime),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _vechileStartTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _vechileStartTime = picked);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTimeField(
                label: 'Vehicle End',
                value: fmt(_vechileEndTime),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _vechileEndTime ?? TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => _vechileEndTime = picked);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.access_time),
        ),
        child: Text(value),
      ),
    );
  }

  Widget _buildWorkingDaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Working Days',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: OrgWorkingDay.values.map((day) {
            final isSelected = _selectedWorkingDays.contains(day);
            return FilterChip(
              label: Text(day.displayName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedWorkingDays.add(day);
                  } else {
                    _selectedWorkingDays.remove(day);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
