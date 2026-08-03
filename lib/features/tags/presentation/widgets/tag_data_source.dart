import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/tag_model.dart';
import '../../data/repositories/tag_repository.dart';

class TagDataSource extends AsyncDataTableSource {
  final WidgetRef ref;
  final BuildContext context;
  final bool activeOnly;
  final String searchQuery;
  final Function(TagModel) onEdit;
  final Function(String, bool) onStatusChanged;

  DocumentSnapshot? _lastDocument;

  TagDataSource({
    required this.ref,
    required this.context,
    this.activeOnly = true,
    this.searchQuery = '',
    required this.onEdit,
    required this.onStatusChanged,
  });

  static Widget _activeStatusChip(bool isActive, ThemeData theme) {
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
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    final theme = Theme.of(context);

    // Reset cursor on first page, use stored cursor for subsequent pages
    final cursor = startIndex == 0 ? null : _lastDocument;

    final result = await ref
        .read(tagRepositoryProvider)
        .getTags(
          activeOnly: activeOnly,
          pageSize: 20,
          searchQuery: searchQuery,
          lastDocument: cursor,
        );

    // Store the last document for next page fetch
    _lastDocument = result.lastDocument;

    final rows = result.items.map((tag) {
      return DataRow2(
        cells: [
          DataCell(
            Text(
              tag.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tag.color != null
                    ? Color(int.parse('0xFF${tag.color}'))
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          DataCell(_activeStatusChip(tag.isActive, theme)),
          DataCell(
            PopupMenuButton<String>(
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'toggle', child: Text('Toggle Status')),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit(tag);
                } else if (value == 'toggle' && tag.id != null) {
                  onStatusChanged(tag.id!, !tag.isActive);
                }
              },
              icon: Icon(
                Icons.more_vert,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      );
    }).toList();

    return AsyncRowsResponse(result.totalCount, rows);
  }
}
