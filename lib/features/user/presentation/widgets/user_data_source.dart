import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:driver_flow_admin/utils/constants/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repositories/user_repository.dart';

class UserDataSource extends AsyncDataTableSource {
  final WidgetRef ref;
  final BuildContext context;
  final UserRole? role;
  final bool activeOnly;
  final String searchQuery;

  DocumentSnapshot? _lastDocument;

  UserDataSource({
    required this.ref,
    required this.context,
    this.role,
    this.activeOnly = true,
    this.searchQuery = '',
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

    final users = await ref
        .read(userRepositoryProvider)
        .getUsers(
          activeOnly: activeOnly,
          pageSize: 20,
          searchQuery: searchQuery,
          role: role,
          lastDocument: cursor,
        );

    // Store the last document for next page fetch
    _lastDocument = users.lastDocument;

    final rows = users.items.map((user) {
      return DataRow2(
        cells: [
          DataCell(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.email != null)
                  Text(
                    user.email!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          DataCell(Text(user.email ?? 'N/A', overflow: TextOverflow.ellipsis)),
          DataCell(
            Text(user.phoneNumber ?? 'N/A', overflow: TextOverflow.ellipsis),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                user.role?.displayName ?? '',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          DataCell(_activeStatusChip(user.isActive, theme)),
          DataCell(
            PopupMenuButton<String>(
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'view', child: Text('View Details')),
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
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

    return AsyncRowsResponse(users.totalCount, rows);
  }
}
