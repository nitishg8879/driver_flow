import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/helpers/app_logger.dart';
import '../models/pagination_cursor.dart';
import 'paginated_repository.dart';
import 'paginated_state.dart';

/// Generic cubit that drives any paginated, Active/Inactive-filterable list
/// (Students, Instructors, Vehicles, ...). Feature cubits should extend this
/// and simply provide the [PaginatedRepository] implementation plus any
/// feature-specific mutation methods (create/update/setActiveStatus), calling
/// [refresh] afterwards to reload the current page.
///
/// This cubit is backend-agnostic: it only stores the [PaginationCursor]
/// returned by the repository and hands it back unchanged on the next
/// [loadMore] call, without ever inspecting it.
@Deprecated(
  'PaginatedCubit is deprecated and will be removed in a future version. '
  'Use AsyncDataTableSource implementations with repository methods directly instead. '
  'See ScheduleDataSource or UserDataSource for the new pattern.',
)
class PaginatedCubit<T> extends Cubit<PaginatedState<T>> {
  final PaginatedRepository<T> repository;
  final int pageSize;
  final _logger = AppLogger('PaginatedCubit');
  PaginationCursor? _cursor;

  PaginatedCubit({required this.repository, this.pageSize = 20})
    : super(const PaginatedState.initial());

  Future<void> load({bool activeOnly = true}) async {
    emit(const PaginatedState.loading());
    _cursor = null;
    try {
      final page = await repository.getPage(
        activeOnly: activeOnly,
        pageSize: pageSize,
      );
      // _cursor = page.cursor;
      emit(
        PaginatedState.loaded(
          items: page.items,
          hasMore: page.hasMore,
          activeOnly: activeOnly,
          totalCount: page.totalCount,
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to load page', e, stackTrace);
      emit(PaginatedState.error(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! PaginatedLoaded<T> ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final page = await repository.getPage(
        activeOnly: currentState.activeOnly,
        pageSize: pageSize,
        cursor: _cursor,
      );
      // _cursor = page.cursor ?? _cursor;
      emit(
        currentState.copyWith(
          items: [...currentState.items, ...page.items],
          hasMore: page.hasMore,
          isLoadingMore: false,
          totalCount: page.totalCount,
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to load more items', e, stackTrace);
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Reloads the first page using the currently active filter (or
  /// [activeOnly] default true if nothing has been loaded yet). Call this
  /// after create/update/status-change mutations.
  Future<void> refresh() async {
    final currentState = state;
    final activeOnly = currentState is PaginatedLoaded<T>
        ? currentState.activeOnly
        : true;
    await load(activeOnly: activeOnly);
  }
}
