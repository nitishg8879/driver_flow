import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/components/app_loader_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../../../../utils/helpers/validators.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserFormDialog extends ConsumerStatefulWidget {
  final UserModel? existing;

  const UserFormDialog({super.key, this.existing});

  @override
  ConsumerState<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends ConsumerState<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  UserRole? _selectedRole;
  final _logger = AppLogger('UserFormDialog');

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name);
    _phoneController = TextEditingController(text: widget.existing?.phoneNumber);
    _selectedRole = widget.existing?.role ?? UserRole.student;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) return;

    final model = (widget.existing ?? const UserModel()).copyWith(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      role: _selectedRole,
    );

    try {
      final repo = ref.read(userRepositoryProvider);
      _isEditMode
          ? await repo.updateUser(model)
          : await repo.createUser(model);
    } catch (e, stackTrace) {
      _logger.error('Failed to save user', e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit User' : 'Add User'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter full name',
                  validator: (value) =>
                      Validators.validateRequired(value, 'Full name'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  hintText: 'Enter 10-digit phone number',
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhoneNumber,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UserRole>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: UserRole.values
                      .where((role) => role != UserRole.admin)
                      .map(
                        (role) => DropdownMenuItem<UserRole>(
                          value: role,
                          child: Text(role.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a role' : null,
                ),

              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledLoaderButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
