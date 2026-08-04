import 'package:cloud_firestore/cloud_firestore.dart';

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
