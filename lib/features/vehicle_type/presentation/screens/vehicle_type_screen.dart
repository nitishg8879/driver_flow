import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/components/app_data_table.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../../data/models/vehicle_type_model.dart';
import '../widgets/vehicle_type_data_source.dart';
import '../widgets/vehicle_type_form_dialog.dart';

class VehicleTypeScreen extends HookConsumerWidget {
  const VehicleTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = useMemoized(
      () => VehicleTypeDataSource(ref: ref, context: context),
    );

    Future<void> openForm({VehicleTypeModel? existing}) async {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => VehicleTypeFormDialog(
          existing: existing,
          onSaved: dataSource.refreshDatasource,
        ),
      );
      if (result == true && context.mounted) {
        context.showSuccessSnackBar('Vehicle type saved successfully');
      }
    }

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
                  onPressed: () => openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Vehicle Type'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AppDataTable(
                minWidth: 800,
                columns: const [
                  DataColumn2(label: Text('Image'), fixedWidth: 64),
                  DataColumn2(label: Text('Name'), size: ColumnSize.L),
                  DataColumn2(label: Text('Sessions'), size: ColumnSize.S),
                  DataColumn2(label: Text('Duration (min)'), size: ColumnSize.S),
                  DataColumn2(label: Text('Price / Session'), size: ColumnSize.S),
                  DataColumn2(label: Text('Status'), size: ColumnSize.S),
                  DataColumn2(label: Text('Actions'), fixedWidth: 96),
                ],
                source: dataSource,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
