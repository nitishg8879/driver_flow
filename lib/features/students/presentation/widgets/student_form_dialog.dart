import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/attachment_model.dart';
import '../../../../core/services/attachment_service.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../utils/components/async_dropdown.dart';
import '../../../../utils/components/attachment_picker_field.dart';
import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../../../../utils/helpers/validators.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../vehicle_type/data/models/vehicle_type_model.dart';
import '../../../vehicle_type/data/repositories/vehicle_type_repository.dart';
import '../cubit/student_cubit.dart';

/// Dialog used both for creating and editing a student (a [UserModel]
/// with `role == UserRole.student`).
/// Pass [existing] to pre-fill the form for edit mode.
class StudentFormDialog extends StatefulWidget {
  final UserModel? existing;

  const StudentFormDialog({super.key, this.existing});

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  VehicleTypeModel? _selectedVehicleType;
  List<AttachmentModel> _initialAttachments = [];
  List<AttachmentModel> _existingAttachments = [];
  List<PendingAttachment> _pendingAttachments = [];
  bool _isSaving = false;
  final _logger = AppLogger('StudentFormDialog');

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name);
    _phoneController = TextEditingController(
      text: widget.existing?.phoneNumber,
    );

    if (_isEditMode) {
      _loadExistingAttachments();
    }
  }

  Future<void> _loadExistingAttachments() async {
    try {
      final attachments = await sl<AttachmentService>().getAttachmentsByOwner(
        ownerId: widget.existing!.id!,
        source: AttachmentSource.student,
      );
      if (mounted) {
        setState(() {
          _initialAttachments = attachments;
          _existingAttachments = attachments;
        });
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to load student attachments', e, stackTrace);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle type')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final cubit = context.read<StudentCubit>();
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => null,
    );

    final model = (widget.existing ?? const UserModel()).copyWith(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      vehicleTypeId: _selectedVehicleType!.id,
      vehicleTypeName: _selectedVehicleType!.name,
    );

    final savedStudent = _isEditMode
        ? await cubit.updateStudent(model)
        : await cubit.createStudent(model);

    if (savedStudent == null) {
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    final studentId = savedStudent.id!;

    if (currentUserId != null) {
      final attachmentService = sl<AttachmentService>();

      for (final pending in _pendingAttachments) {
        try {
          await attachmentService.uploadAttachment(
            bytes: pending.bytes,
            fileName: pending.fileName,
            fileType: pending.fileType,
            source: AttachmentSource.student,
            ownerId: studentId,
            uploadedBy: currentUserId,
          );
        } catch (e, stackTrace) {
          _logger.error('Failed to upload student attachment', e, stackTrace);
        }
      }

      // Delete attachments that were present initially but removed by the
      // user from the picker before saving.
      final removed = _initialAttachments.where(
        (initial) => !_existingAttachments.any((a) => a.id == initial.id),
      );
      for (final attachment in removed) {
        try {
          await attachmentService.deleteAttachment(attachment);
        } catch (e, stackTrace) {
          _logger.error('Failed to delete student attachment', e, stackTrace);
        }
      }
    }

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Student' : 'Add Student'),
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
                AsyncDropdown<VehicleTypeModel>(
                  labelText: 'Vehicle Type',
                  value: _selectedVehicleType,
                  fetchItems: () =>
                      sl<VehicleTypeRepository>().getVehicleTypes(),
                  itemLabelBuilder: (item) => item.name,
                  onChanged: (value) =>
                      setState(() => _selectedVehicleType = value),
                ),
                const SizedBox(height: 16),
                AttachmentPickerField(
                  initialAttachments: _existingAttachments,
                  onChanged: (existing, pending) {
                    _existingAttachments = existing;
                    _pendingAttachments = pending;
                  },
                ),
              ],
            ),
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
