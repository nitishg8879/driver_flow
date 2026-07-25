import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../utils/components/async_dropdown.dart';
import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/helpers/validators.dart';
import '../../../vehicle_type/data/models/vehicle_type_model.dart';
import '../../../vehicle_type/data/repositories/vehicle_type_repository.dart';
import '../../data/models/vehicle_model.dart';
import '../cubit/vehicle_cubit.dart';

/// Dialog used both for creating and editing a [VehicleModel].
/// Pass [existing] to pre-fill the form for edit mode.
class VehicleFormDialog extends StatefulWidget {
  final VehicleModel? existing;

  const VehicleFormDialog({super.key, this.existing});

  @override
  State<VehicleFormDialog> createState() => _VehicleFormDialogState();
}

class _VehicleFormDialogState extends State<VehicleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _vehicleNumberController;
  late final TextEditingController _modelController;
  VehicleTypeModel? _selectedVehicleType;
  bool _isSaving = false;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _vehicleNumberController = TextEditingController(
      text: widget.existing?.vehicleNumber,
    );
    _modelController = TextEditingController(text: widget.existing?.model);
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _modelController.dispose();
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

    final cubit = context.read<VehicleCubit>();
    final model =
        (widget.existing ?? const VehicleModel(vehicleNumber: '', model: ''))
            .copyWith(
              vehicleNumber: _vehicleNumberController.text.trim(),
              model: _modelController.text.trim(),
              vehicleTypeId: _selectedVehicleType!.id,
              vehicleTypeName: _selectedVehicleType!.name,
            );

    final saved = _isEditMode
        ? await cubit.updateVehicle(model)
        : await cubit.createVehicle(model);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (saved != null) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Vehicle' : 'Add Vehicle'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _vehicleNumberController,
                labelText: 'Vehicle Number',
                hintText: 'e.g. MH12AB1234',
                validator: (value) =>
                    Validators.validateRequired(value, 'Vehicle number'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _modelController,
                labelText: 'Model',
                hintText: 'e.g. Honda Activa',
                validator: (value) =>
                    Validators.validateRequired(value, 'Model'),
              ),
              const SizedBox(height: 16),
              AsyncDropdown<VehicleTypeModel>(
                labelText: 'Vehicle Type',
                value: _selectedVehicleType,
                fetchItems: () => sl<VehicleTypeRepository>().getVehicleTypes(),
                itemLabelBuilder: (item) => item.name,
                onChanged: (value) =>
                    setState(() => _selectedVehicleType = value),
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
