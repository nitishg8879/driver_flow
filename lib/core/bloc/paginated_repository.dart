import '../models/paginated_result.dart';
import '../models/pagination_cursor.dart';

/// Contract that any feature repository must satisfy to be usable with
/// [PaginatedCubit]. Fetching must always be Future-based (no streams).
///
/// [cursor] is the [PaginationCursor] previously returned as
/// [PaginatedResult.cursor] — implementations cast it to their own
/// concrete subclass (e.g. `FirestoreCursor` for Firestore, a page
/// token/offset cursor for a REST API). Pass `null` to fetch the first
/// page.
@Deprecated(
  'PaginatedRepository is deprecated and will be removed in a future version. '
  'Use repository methods directly in AsyncDataTableSource implementations.',
)
abstract class PaginatedRepository<T> {
  Future<PaginatedResult<T>> getPage({
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
  });
}
