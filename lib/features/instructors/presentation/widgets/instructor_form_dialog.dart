import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/helpers/validators.dart';
import '../../../auth/data/models/user_model.dart';
import '../cubit/instructor_cubit.dart';

/// Dialog used both for creating and editing an instructor (a [UserModel]
/// with `role == UserRole.instructor`).
/// Pass [existing] to pre-fill the form for edit mode.
class InstructorFormDialog extends StatefulWidget {
  final UserModel? existing;

  const InstructorFormDialog({super.key, this.existing});

  @override
  State<InstructorFormDialog> createState() => _InstructorFormDialogState();
}

class _InstructorFormDialogState extends State<InstructorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _licenseController;
  bool _isSaving = false;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name);
    _phoneController = TextEditingController(
      text: widget.existing?.phoneNumber,
    );
    _licenseController = TextEditingController(
      text: widget.existing?.licenseNumber,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final cubit = context.read<InstructorCubit>();
    final model = (widget.existing ?? const UserModel()).copyWith(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      licenseNumber: _licenseController.text.trim().isEmpty
          ? null
          : _licenseController.text.trim(),
    );

    final saved = _isEditMode
        ? await cubit.updateInstructor(model)
        : await cubit.createInstructor(model);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (saved != null) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Instructor' : 'Add Instructor'),
      content: SizedBox(
        width: 420,
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
              CustomTextField(
                controller: _licenseController,
                labelText: 'License Number (optional)',
                hintText: 'Enter license number',
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
