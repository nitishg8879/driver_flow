import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/helpers/validators.dart';
import '../../data/models/organization_profile_model.dart';
import '../cubit/profile_cubit.dart';

const _workingDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class ProfileFormDialog extends StatefulWidget {
  final OrganizationProfileModel? existing;

  const ProfileFormDialog({super.key, this.existing});

  @override
  State<ProfileFormDialog> createState() => _ProfileFormDialogState();
}

class _ProfileFormDialogState extends State<ProfileFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _aboutController;
  late final TextEditingController _urlController;
  List<String> _websiteUrls = [];
  List<String> _selectedWorkingDays = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.organizationName);
    _phoneController = TextEditingController(text: existing?.phoneNumber);
    _aboutController = TextEditingController(text: existing?.aboutUs);
    _urlController = TextEditingController();
    _websiteUrls = List.from(existing?.websiteUrls ?? []);
    _selectedWorkingDays = List.from(existing?.workingDays ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _addUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty && !_websiteUrls.contains(url)) {
      setState(() {
        _websiteUrls.add(url);
        _urlController.clear();
      });
    }
  }

  void _removeUrl(String url) {
    setState(() => _websiteUrls.remove(url));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWorkingDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one working day')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final model = OrganizationProfileModel(
        organizationName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        aboutUs: _aboutController.text.trim(),
        websiteUrls: _websiteUrls,
        workingDays: _selectedWorkingDays,
      );

      if (!mounted) return;
      context.read<ProfileCubit>().updateProfile(model);
      Navigator.pop(context);
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
              'Edit Organization Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  const SizedBox(height: 24),
                  _buildWebsiteUrlsSection(),
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
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Save',
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

  Widget _buildWebsiteUrlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Website URLs',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _urlController,
                labelText: 'Add URL',
                hintText: 'https://example.com',
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _addUrl, child: const Text('Add')),
          ],
        ),
        const SizedBox(height: 12),
        if (_websiteUrls.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _websiteUrls.map((url) {
              return Chip(
                label: Text(url, overflow: TextOverflow.ellipsis),
                onDeleted: () => _removeUrl(url),
              );
            }).toList(),
          ),
      ],
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
          children: _workingDays.map((day) {
            final isSelected = _selectedWorkingDays.contains(day);
            return FilterChip(
              label: Text(day),
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
