import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/extensions/context_extensions.dart';
import '../../data/models/vehicle_type_model.dart';
import '../../data/repositories/vehicle_type_repository.dart';
import 'vehicle_type_form_dialog.dart';

class VehicleTypeDataSource extends AsyncDataTableSource {
  final WidgetRef ref;
  final BuildContext context;

  DocumentSnapshot? _lastDocument;

  VehicleTypeDataSource({required this.ref, required this.context});

  Future<void> _toggleActive(VehicleTypeModel vehicleType) async {
    final newStatus = !vehicleType.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(newStatus ? 'Activate Vehicle Type' : 'Deactivate Vehicle Type'),
        content: Text(
          'Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} "${vehicleType.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(vehicleTypeRepositoryProvider)
          .setActiveStatus(vehicleType.id!, newStatus);
      refreshDatasource();
    }
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    final theme = Theme.of(context);

    final cursor = startIndex == 0 ? null : _lastDocument;
    final result = await ref
        .read(vehicleTypeRepositoryProvider)
        .getVehicleTypes(activeOnly: false, pageSize: count, lastDocument: cursor);

    _lastDocument = result.lastDocument;

    final rows = result.items.map((vt) {
      return DataRow2(
        cells: [
          DataCell(
            vt.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(vt.imageUrl!,
                        width: 40, height: 40, fit: BoxFit.cover),
                  )
                : CircleAvatar(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.two_wheeler, size: 20),
                  ),
          ),
          DataCell(Text(vt.name, style: const TextStyle(fontWeight: FontWeight.w600))),
          DataCell(Text(vt.numberOfSessions.toString())),
          DataCell(Text(vt.sessionDurationMinutes.toString())),
          DataCell(Text(vt.pricePerSession.toString())),
          DataCell(_statusChip(vt.isActive)),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (_) => VehicleTypeFormDialog(
                        existing: vt,
                        onSaved: refreshDatasource,
                      ),
                    );
                    if (result == true && context.mounted) {
                      context.showSuccessSnackBar('Vehicle type saved successfully');
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    vt.isActive ? Icons.toggle_on : Icons.toggle_off_outlined,
                    color: vt.isActive ? theme.colorScheme.primary : null,
                  ),
                  onPressed: () => _toggleActive(vt),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return AsyncRowsResponse(result.totalCount, rows);
  }

  static Widget _statusChip(bool isActive) {
    final (textColor, bgColor) = isActive
        ? (const Color(0xFF2E7D32), const Color(0xFFE8F5E9))
        : (const Color(0xFFC62828), const Color(0xFFFFEBEE));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.25)),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
