import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/components/app_data_table.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../../data/repositories/tag_repository.dart';
import '../widgets/tag_data_source.dart';
import '../widgets/tag_form_dialog.dart';

class TagsScreen extends HookConsumerWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter state
    final activeOnly = useState(true);
    final searchQuery = useState('');
    final refreshCounter = useState(0);

    // Memoized data source based on filter changes and refresh counter
    final dataSource = useMemoized(() {
      return TagDataSource(
        ref: ref,
        context: context,
        activeOnly: activeOnly.value,
        searchQuery: searchQuery.value,
        onEdit: (tag) async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => TagFormDialog(existing: tag),
          );
          if (result == true) {
            context.showSuccessSnackBar('Tag updated successfully');
            refreshCounter.value++;
          }
        },
        onStatusChanged: (tagId, newStatus) async {
          try {
            await ref
                .read(tagRepositoryProvider)
                .setActiveStatus(tagId, newStatus);
            context.showSuccessSnackBar(
              'Tag ${newStatus ? 'activated' : 'deactivated'} successfully',
            );
            refreshCounter.value++;
          } catch (e) {
            context.showErrorSnackBar('Failed to update tag status');
          }
        },
      );
    }, [activeOnly.value, searchQuery.value, refreshCounter.value]);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Tags',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (_) => const TagFormDialog(),
                    );
                    if (result == true) {
                      context.showSuccessSnackBar('Tag saved successfully');
                      refreshCounter.value++;
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Tag'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
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
                minWidth: 800,
                dataRowHeight: 64,
                rowsPerPage: 10,
                columns: const [
                  DataColumn2(label: Text('Name'), size: ColumnSize.M),
                  DataColumn2(label: Text('Color'), size: ColumnSize.S),
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
