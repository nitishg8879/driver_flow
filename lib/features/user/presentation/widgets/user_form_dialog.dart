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
import '../../data/models/user_model.dart';
import '../../../vehicle_type/data/models/vehicle_type_model.dart';
import '../../../vehicle_type/data/repositories/vehicle_type_repository.dart';
import '../cubit/user_cubit.dart';

class UserFormDialog extends StatefulWidget {
  final UserModel? existing;

  const UserFormDialog({super.key, this.existing});

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _licenseController;
  VehicleTypeModel? _selectedVehicleType;
  UserRole? _selectedRole;
  List<AttachmentModel> _initialAttachments = [];
  List<AttachmentModel> _existingAttachments = [];
  List<PendingAttachment> _pendingAttachments = [];
  bool _isSaving = false;
  final _logger = AppLogger('UserFormDialog');

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
    _selectedRole = widget.existing?.role ?? UserRole.student;

    if (_selectedRole == UserRole.student && _isEditMode) {
      _loadExistingAttachments();
      _loadExistingVehicleType();
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
      _logger.error('Failed to load user attachments', e, stackTrace);
    }
  }

  Future<void> _loadExistingVehicleType() async {
    if (widget.existing?.vehicleTypeId == null) return;
    try {
      final types = await sl<VehicleTypeRepository>().getVehicleTypes();
      VehicleTypeModel? match;
      for (final type in types) {
        if (type.id == widget.existing?.vehicleTypeId) {
          match = type;
          break;
        }
      }
      if (mounted && match != null) {
        setState(() => _selectedVehicleType = match);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to load selected vehicle type', e, stackTrace);
    }
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
    if (_selectedRole == null) return;
    if (_selectedRole == UserRole.student && _selectedVehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle type')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final cubit = context.read<UserCubit>();
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => null,
    );

    final model = (widget.existing ?? const UserModel()).copyWith(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      role: _selectedRole,
      vehicleTypeId: _selectedRole == UserRole.student
          ? _selectedVehicleType?.id
          : null,
      vehicleTypeName: _selectedRole == UserRole.student
          ? _selectedVehicleType?.name
          : null,
      licenseNumber: _selectedRole == UserRole.instructor
          ? _licenseController.text.trim().isEmpty
                ? null
                : _licenseController.text.trim()
          : null,
    );

    final savedUser = _isEditMode
        ? await cubit.updateUser(model)
        : await cubit.createUser(model);

    if (savedUser == null) {
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    final userId = savedUser.id!;
    if (_selectedRole == UserRole.student && currentUserId != null) {
      final attachmentService = sl<AttachmentService>();

      for (final pending in _pendingAttachments) {
        try {
          await attachmentService.uploadAttachment(
            bytes: pending.bytes,
            fileName: pending.fileName,
            fileType: pending.fileType,
            source: AttachmentSource.student,
            ownerId: userId,
            uploadedBy: currentUserId,
          );
        } catch (e, stackTrace) {
          _logger.error('Failed to upload user attachment', e, stackTrace);
        }
      }

      final removed = _initialAttachments.where(
        (initial) => !_existingAttachments.any((a) => a.id == initial.id),
      );
      for (final attachment in removed) {
        try {
          await attachmentService.deleteAttachment(attachment);
        } catch (e, stackTrace) {
          _logger.error('Failed to delete user attachment', e, stackTrace);
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
                      if (_selectedRole != UserRole.student) {
                        _selectedVehicleType = null;
                      }
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a role' : null,
                ),
                const SizedBox(height: 16),
                if (_selectedRole == UserRole.student) ...[
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
                if (_selectedRole == UserRole.instructor) ...[
                  CustomTextField(
                    controller: _licenseController,
                    labelText: 'License Number (optional)',
                    hintText: 'Enter license number',
                  ),
                ],
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
