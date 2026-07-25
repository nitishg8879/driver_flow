/// Marker type for "where to continue fetching from" in a paginated query.
///
/// The generic pagination layer ([PaginatedCubit], [PaginatedListView])
/// only ever passes a [PaginationCursor] around — it never looks inside
/// it. Each repository implementation defines its own subclass that holds
/// whatever it actually needs (e.g. [FirestoreCursor] below) and casts it
/// back when building the next query. This keeps the generic layer usable
/// with any backend (Firestore today, a REST API tomorrow) without
/// leaking backend-specific types into shared code.
abstract class PaginationCursor {
  const PaginationCursor();
}
