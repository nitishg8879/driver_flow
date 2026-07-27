import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/paginated_cubit.dart';
import '../../core/bloc/paginated_state.dart';

/// Generic paginated list widget driven by a [PaginatedCubit<T>].
///
/// Handles infinite-scroll load-more, loading/error/empty states and
/// delegates only the item rendering to the caller via [itemBuilder].
class PaginatedListView<T> extends StatefulWidget {
  final PaginatedCubit<T> cubit;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyMessage;
  final String emptyMessageInactive;

  const PaginatedListView({
    super.key,
    required this.cubit,
    required this.itemBuilder,
    this.emptyMessage = 'No records found',
    this.emptyMessageInactive = 'No inactive records found',
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginatedCubit<T>, PaginatedState<T>>(
      bloc: widget.cubit,
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text('Error: $message')),
          loaded: (items, hasMore, activeOnly, totalCount, isLoadingMore) {
            if (items.isEmpty) {
              return Center(
                child: Text(
                  activeOnly
                      ? widget.emptyMessage
                      : widget.emptyMessageInactive,
                ),
              );
            }
            final countText =
                totalCount > 0 ? '${items.length} of $totalCount records' :
                '${items.length} fetched';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    countText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: items.length + (hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      if (index >= items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return widget.itemBuilder(context, items[index]);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
