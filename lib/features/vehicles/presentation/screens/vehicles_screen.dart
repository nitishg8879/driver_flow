import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/paginated_list_view.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../../data/models/vehicle_model.dart';
import '../cubit/vehicle_cubit.dart';
import '../widgets/vehicle_form_dialog.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  bool _showActive = true;

  @override
  void initState() {
    super.initState();
    context.read<VehicleCubit>().load(activeOnly: _showActive);
  }

  void _onFilterChanged(bool showActive) {
    setState(() => _showActive = showActive);
    context.read<VehicleCubit>().load(activeOnly: showActive);
  }

  Future<void> _openForm({VehicleModel? existing}) async {
    final cubit = context.read<VehicleCubit>();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: VehicleFormDialog(existing: existing),
      ),
    );

    if (result == true && mounted) {
      context.showSuccessSnackBar('Vehicle saved successfully');
    }
  }

  Future<void> _toggleActive(VehicleModel vehicle) async {
    final newStatus = !vehicle.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(newStatus ? 'Activate Vehicle' : 'Deactivate Vehicle'),
        content: Text(
          'Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} "${vehicle.vehicleNumber}"?',
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
      await context.read<VehicleCubit>().setActiveStatus(
        vehicle.id!,
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
                  'Vehicles',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Vehicle'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Active')),
                ButtonSegment(value: false, label: Text('Inactive')),
              ],
              selected: {_showActive},
              onSelectionChanged: (selection) =>
                  _onFilterChanged(selection.first),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PaginatedListView<VehicleModel>(
                cubit: context.read<VehicleCubit>(),
                emptyMessage: 'No active vehicles found',
                emptyMessageInactive: 'No inactive vehicles found',
                itemBuilder: (context, vehicle) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.directions_car_outlined),
                    ),
                    title: Text(vehicle.vehicleNumber),
                    subtitle: Text(
                      '${vehicle.model} • ${vehicle.vehicleTypeName ?? '-'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _openForm(existing: vehicle),
                        ),
                        IconButton(
                          icon: Icon(
                            vehicle.isActive
                                ? Icons.remove_circle_outline
                                : Icons.check_circle_outline,
                          ),
                          tooltip: vehicle.isActive ? 'Deactivate' : 'Activate',
                          onPressed: () => _toggleActive(vehicle),
                        ),
                      ],
                    ),
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
