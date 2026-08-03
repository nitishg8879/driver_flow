// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:data_table_2/data_table_2.dart';
// import 'package:driver_flow_admin/core/di/service_locator.dart';
// import 'package:driver_flow_admin/features/user/data/repositories/user_repository.dart';
// import 'package:driver_flow_admin/utils/components/app_data_table.dart';
// import 'package:driver_flow_admin/utils/constants/app_enums.dart';
// import 'package:flutter/material.dart';

// class UsersTable extends StatefulWidget {
//   final UserRole? role;
//   final bool activeOnly;
//   final String searchQuery;

//   const UsersTable({
//     super.key,
//     this.role,
//     this.activeOnly = true,
//     this.searchQuery = '',
//   });

//   @override
//   State<UsersTable> createState() => _UsersTableState();
// }

// class _UsersTableState extends State<UsersTable> {
//   late UserDataSource _dataSource;
//   final PaginatorController _paginatorController = PaginatorController();

//   @override
//   void initState() {
//     super.initState();
//     _dataSource = UserDataSource(
//       role: widget.role,
//       activeOnly: widget.activeOnly,
//       searchQuery: widget.searchQuery,
//       context: context,
//     );
//   }

//   @override
//   void didUpdateWidget(UsersTable oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // If any filter changed, recreate the data source and reset pagination
//     if (oldWidget.role != widget.role ||
//         oldWidget.activeOnly != widget.activeOnly ||
//         oldWidget.searchQuery != widget.searchQuery) {
//       _dataSource = UserDataSource(
//         role: widget.role,
//         activeOnly: widget.activeOnly,
//         searchQuery: widget.searchQuery,
//         context: context,
//       );
//       // Reset pagination to first page
//       _paginatorController.goToPageWithRow(0);
//     }
//   }

//   @override
//   void dispose() {
//     _paginatorController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: AppDataTable(
//         minWidth: 1000,
//         dataRowHeight: 64,
//         rowsPerPage: 10,
//         columns: const [
//           DataColumn2(label: Text('Name'), size: ColumnSize.M),
//           DataColumn2(label: Text('Email'), size: ColumnSize.L),
//           DataColumn2(label: Text('Phone'), size: ColumnSize.M),
//           DataColumn2(label: Text('Role'), size: ColumnSize.S),
//           DataColumn2(label: Text('Status'), size: ColumnSize.S),
//           DataColumn2(label: Text('Actions'), fixedWidth: 72),
//         ],
//         source: _dataSource,
//         controller: _paginatorController,
//       ),
//     );
//   }
// }

// class UserDataSource extends AsyncDataTableSource {
//   final BuildContext context;
//   final UserRole? role;
//   final bool activeOnly;
//   final String searchQuery;

//   DocumentSnapshot? _lastDocument;

//   UserDataSource({
//     required this.context,
//     this.role,
//     this.activeOnly = true,
//     this.searchQuery = '',
//   });

//   static Widget _activeStatusChip(bool isActive, ThemeData theme) {
//     final (textColor, bgColor) = isActive
//         ? (const Color(0xFF2E7D32), const Color(0xFFE8F5E9))
//         : (const Color(0xFFC62828), const Color(0xFFFFEBEE));

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: textColor.withValues(alpha: 0.25)),
//       ),
//       child: Text(
//         isActive ? 'Active' : 'Inactive',
//         style: TextStyle(
//           color: textColor,
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.2,
//         ),
//       ),
//     );
//   }

//   @override
//   Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
//     final _theme = Theme.of(context);
//     final repository = sl<UserRepository>();

//     // Reset cursor on first page, use stored cursor for subsequent pages
//     final cursor = startIndex == 0 ? null : _lastDocument;

//     final users = await repository.getUsers(
//       activeOnly: activeOnly,
//       pageSize: 20,
//       searchQuery: searchQuery,
//       role: role,
//       lastDocument: cursor,
//     );

//     // Store the last document for next page fetch
//     _lastDocument = users.lastDocument;
//     final rows = users.items.map((user) {
//       return DataRow2(
//         cells: [
//           DataCell(
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.name ?? '',
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 if (user.email != null)
//                   Text(
//                     user.email!,
//                     style: _theme.textTheme.bodySmall?.copyWith(
//                       color: _theme.colorScheme.onSurfaceVariant,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//               ],
//             ),
//           ),
//           DataCell(Text(user.email ?? 'N/A', overflow: TextOverflow.ellipsis)),
//           DataCell(
//             Text(user.phoneNumber ?? 'N/A', overflow: TextOverflow.ellipsis),
//           ),
//           DataCell(
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: _theme.colorScheme.primaryContainer,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 user.role?.displayName ?? '',
//                 style: TextStyle(
//                   color: _theme.colorScheme.onPrimaryContainer,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           DataCell(_activeStatusChip(user.isActive, _theme)),
//           DataCell(
//             PopupMenuButton<String>(
//               itemBuilder: (_) => const [
//                 PopupMenuItem(value: 'view', child: Text('View Details')),
//                 PopupMenuItem(value: 'edit', child: Text('Edit')),
//                 PopupMenuItem(value: 'delete', child: Text('Delete')),
//               ],
//               icon: Icon(
//                 Icons.more_vert,
//                 size: 18,
//                 color: _theme.colorScheme.onSurfaceVariant,
//               ),
//             ),
//           ),
//         ],
//       );
//     }).toList();

//     return AsyncRowsResponse(users.totalCount, rows);
//   }
// }
