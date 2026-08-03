import 'package:cloud_firestore/cloud_firestore.dart';

import 'pagination_cursor.dart';

/// Generic result of a single paginated fetch.
///
/// Used by feature repositories (Students, Instructors, Vehicles, ...) so
/// that the pagination cubit/UI can stay backend-agnostic.
///
/// [cursor] is a [PaginationCursor] rather than a Firestore-specific type
/// (e.g. `DocumentSnapshot`). The generic pagination layer
/// (`PaginatedCubit`/`PaginatedListView`) never inspects it — it only
/// stores whatever a repository returns and passes it back unchanged on
/// the next `getPage` call. Each repository implementation decides what
/// concrete [PaginationCursor] subclass to use (e.g. `FirestoreCursor` for
/// Firestore today, a page-token/offset cursor for a future REST API).
// class PaginatedResult<T> {
//   final List<T> items;
//   final PaginationCursor? cursor;
//   final bool hasMore;
//   final int totalCount;

//   PaginatedResult({
//     required this.items,
//     required this.cursor,
//     required this.hasMore,
//     required this.totalCount,
//   });
// }

class PaginatedResult<T> {
  final List<T> items;
  final int totalCount;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.lastDocument,
    required this.hasMore,
  });
}
