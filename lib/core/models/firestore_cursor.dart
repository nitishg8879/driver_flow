import 'package:cloud_firestore/cloud_firestore.dart';

import 'pagination_cursor.dart';

/// [PaginationCursor] implementation used by Firestore-backed repositories.
/// Wraps the last [DocumentSnapshot] of a page so the next query can call
/// `.startAfterDocument(...)`.
class FirestoreCursor extends PaginationCursor {
  final DocumentSnapshot<Map<String, dynamic>> document;

  const FirestoreCursor(this.document);
}
