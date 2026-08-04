import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/components/app_loader_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../../../../utils/helpers/validators.dart';
import '../../data/models/vehicle_type_model.dart';
import '../../data/repositories/vehicle_type_repository.dart';

class VehicleTypeFormDialog extends ConsumerStatefulWidget {
  final VehicleTypeModel? existing;
  final VoidCallback? onSaved;

  const VehicleTypeFormDialog({super.key, this.existing, this.onSaved});

  @override
  ConsumerState<VehicleTypeFormDialog> createState() =>
      _VehicleTypeFormDialogState();
}

class _VehicleTypeFormDialogState
    extends ConsumerState<VehicleTypeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _sessionsController;
  late final TextEditingController _durationController;
  late final TextEditingController _priceController;
  Uint8List? _imageBytes;
  String? _imageFileName;
  final _logger = AppLogger('VehicleTypeFormDialog');

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name);
    _sessionsController = TextEditingController(
      text: widget.existing?.numberOfSessions.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: widget.existing?.sessionDurationMinutes.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.existing?.pricePerSession.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sessionsController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    if (result == null || result.files.isEmpty) return;
    final picked = result.files.single;
    if (picked.bytes == null) return;
    setState(() {
      _imageBytes = picked.bytes;
      _imageFileName = picked.name;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final model = (widget.existing ?? const VehicleTypeModel(name: '')).copyWith(
      name: _nameController.text.trim(),
      numberOfSessions: int.tryParse(_sessionsController.text.trim()) ?? 0,
      sessionDurationMinutes: int.tryParse(_durationController.text.trim()) ?? 0,
      pricePerSession: num.tryParse(_priceController.text.trim()) ?? 0,
    );

    try {
      final repo = ref.read(vehicleTypeRepositoryProvider);
      _isEditMode
          ? await repo.updateVehicleType(model,
              imageBytes: _imageBytes, imageFileName: _imageFileName)
          : await repo.createVehicleType(model,
              imageBytes: _imageBytes, imageFileName: _imageFileName);
    } catch (e, st) {
      _logger.error('Failed to save vehicle type', e, st);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      return;
    }

    if (!mounted) return;
    widget.onSaved?.call();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Vehicle Type' : 'Add Vehicle Type'),
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
                labelText: 'Name',
                hintText: 'e.g. Two Wheeler - Gear',
                validator: (value) =>
                    Validators.validateRequired(value, 'Name'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _sessionsController,
                labelText: 'Number of Sessions Required',
                hintText: 'e.g. 20',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sessions required';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _durationController,
                labelText: 'Session Duration (minutes)',
                hintText: 'e.g. 60',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Duration required';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Enter a valid duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _priceController,
                labelText: 'Price Per Session',
                hintText: 'e.g. 60',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price required';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (_imageBytes != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _imageBytes!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else if (widget.existing?.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.existing!.imageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: Text(
                        _imageFileName ?? 'Select Image (optional)',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
