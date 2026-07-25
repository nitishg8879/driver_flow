import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/extensions/context_extensions.dart';
import '../../data/models/vehicle_type_model.dart';
import '../cubit/vehicle_type_cubit.dart';
import '../widgets/vehicle_type_form_dialog.dart';

class VehicleTypeScreen extends StatefulWidget {
  const VehicleTypeScreen({super.key});

  @override
  State<VehicleTypeScreen> createState() => _VehicleTypeScreenState();
}

class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleTypeCubit>().loadVehicleTypes();
  }

  Future<void> _openForm({VehicleTypeModel? existing}) async {
    final cubit = context.read<VehicleTypeCubit>();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: VehicleTypeFormDialog(existing: existing),
      ),
    );

    if (result == true && mounted) {
      context.showSuccessSnackBar('Vehicle type saved successfully');
    }
  }

  Future<void> _toggleActive(VehicleTypeModel vehicleType) async {
    final newStatus = !vehicleType.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          newStatus ? 'Activate Vehicle Type' : 'Deactivate Vehicle Type',
        ),
        content: Text(
          'Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} "${vehicleType.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<VehicleTypeCubit>().setActiveStatus(
        vehicleType.id!,
        newStatus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Vehicle Types',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Vehicle Type'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<VehicleTypeCubit, VehicleTypeState>(
                bloc: context.read<VehicleTypeCubit>(),
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (message) => Center(child: Text('Error: $message')),
                    saving: () =>
                        const Center(child: CircularProgressIndicator()),
                    saved: () => const SizedBox.shrink(),
                    loaded: (vehicleTypes) {
                      if (vehicleTypes.isEmpty) {
                        return const Center(
                          child: Text('No vehicle types added yet'),
                        );
                      }
                      return ListView.separated(
                        itemCount: vehicleTypes.length,
                        separatorBuilder: (_, _) => const Divider(),
                        itemBuilder: (context, index) {
                          final vehicleType = vehicleTypes[index];
                          return ListTile(
                            leading: vehicleType.imageUrl != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      vehicleType.imageUrl!,
                                    ),
                                  )
                                : const CircleAvatar(
                                    child: Icon(Icons.two_wheeler),
                                  ),
                            title: Text(vehicleType.name),
                            subtitle: Text(
                              vehicleType.isActive ? 'Active' : 'Inactive',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () =>
                                      _openForm(existing: vehicleType),
                                ),
                                IconButton(
                                  icon: Icon(
                                    vehicleType.isActive
                                        ? Icons.toggle_on
                                        : Icons.toggle_off_outlined,
                                    color: vehicleType.isActive
                                        ? context.colorScheme.primary
                                        : null,
                                  ),
                                  onPressed: () => _toggleActive(vehicleType),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
