import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/helpers/validators.dart';
import '../../data/models/vehicle_type_model.dart';
import '../cubit/vehicle_type_cubit.dart';

/// Dialog used both for creating and editing a [VehicleTypeModel].
/// Pass [existing] to pre-fill the form for edit mode.
class VehicleTypeFormDialog extends StatefulWidget {
  final VehicleTypeModel? existing;

  const VehicleTypeFormDialog({super.key, this.existing});

  @override
  State<VehicleTypeFormDialog> createState() => _VehicleTypeFormDialogState();
}

class _VehicleTypeFormDialogState extends State<VehicleTypeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _isSaving = false;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
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

    setState(() => _isSaving = true);

    final cubit = context.read<VehicleTypeCubit>();
    final model = (widget.existing ?? const VehicleTypeModel(name: ''))
        .copyWith(name: _nameController.text.trim());

    final success = _isEditMode
        ? await cubit.updateVehicleType(
            model,
            imageBytes: _imageBytes,
            imageFileName: _imageFileName,
          )
        : await cubit.createVehicleType(
            model,
            imageBytes: _imageBytes,
            imageFileName: _imageFileName,
          );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      Navigator.of(context).pop(true);
    }
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
