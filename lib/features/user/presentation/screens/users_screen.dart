import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/components/app_data_table.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../widgets/user_data_source.dart';
import '../widgets/user_form_dialog.dart';

class UsersScreen extends HookConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter state
    final selectedRole = useState<UserRole?>(null);
    final activeOnly = useState(true);
    final searchQuery = useState('');

    // Memoized data source based on filter changes
    final dataSource = useMemoized(() {
      return UserDataSource(
        ref: ref,
        context: context,
        role: selectedRole.value,
        activeOnly: activeOnly.value,
        searchQuery: searchQuery.value,
      );
    }, [selectedRole.value, activeOnly.value, searchQuery.value]);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Users',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (_) => const UserFormDialog(),
                    );
                    if (result == true) {
                      context.showSuccessSnackBar('User saved successfully');
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) {
                      searchQuery.value = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownMenu<UserRole?>(
                    initialSelection: selectedRole.value,
                    onSelected: (role) {
                      selectedRole.value = role;
                    },
                    dropdownMenuEntries: [
                      const DropdownMenuEntry<UserRole?>(
                        value: null,
                        label: 'All Roles',
                      ),
                      ...UserRole.values.map(
                        (role) => DropdownMenuEntry<UserRole?>(
                          value: role,
                          label: role.displayName,
                        ),
                      ),
                    ],
                    label: const Text('Role'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Active')),
                ButtonSegment(value: false, label: Text('Inactive')),
              ],
              selected: {activeOnly.value},
              onSelectionChanged: (selection) {
                activeOnly.value = selection.first;
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AppDataTable(
                minWidth: 1000,
                dataRowHeight: 64,
                rowsPerPage: 10,
                columns: const [
                  DataColumn2(label: Text('Name'), size: ColumnSize.M),
                  DataColumn2(label: Text('Email'), size: ColumnSize.L),
                  DataColumn2(label: Text('Phone'), size: ColumnSize.M),
                  DataColumn2(label: Text('Role'), size: ColumnSize.S),
                  DataColumn2(label: Text('Status'), size: ColumnSize.S),
                  DataColumn2(label: Text('Actions'), fixedWidth: 72),
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
