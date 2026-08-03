import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_state.freezed.dart';

/// Generic state for any paginated list (Students, Instructors, Vehicles...).
@Deprecated(
  'PaginatedState is deprecated and will be removed in a future version. '
  'Use AsyncDataTableSource and AppDataTable instead.',
)
@freezed
class PaginatedState<T> with _$PaginatedState<T> {
  const factory PaginatedState.initial() = PaginatedInitial<T>;
  const factory PaginatedState.loading() = PaginatedLoading<T>;
  const factory PaginatedState.loaded({
    required List<T> items,
    required bool hasMore,
    required bool activeOnly,
    required int totalCount,
    @Default(false) bool isLoadingMore,
  }) = PaginatedLoaded<T>;
  const factory PaginatedState.error(String message) = PaginatedError<T>;
}
