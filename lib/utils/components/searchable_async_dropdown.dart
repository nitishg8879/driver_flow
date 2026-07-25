import 'dart:async';

import 'package:flutter/material.dart';

/// A searchable dropdown that re-fetches its options from the server as
/// the user types (debounced), instead of loading everything up-front.
///
/// Useful for large collections where fetching "all" records isn't
/// practical (e.g. Students) — pair with [AsyncDropdown] for small,
/// load-once collections (e.g. Instructors).
///
/// Renders as a text field showing the selected item's label; tapping it
/// opens a search dialog with results updating as the user types.
class SearchableAsyncDropdown<T> extends StatefulWidget {
  final Future<List<T>> Function(String query) searchItems;
  final String Function(T item) itemLabelBuilder;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String labelText;
  final String hintText;
  final bool enabled;
  final Duration debounceDuration;

  const SearchableAsyncDropdown({
    super.key,
    required this.searchItems,
    required this.itemLabelBuilder,
    required this.onChanged,
    required this.labelText,
    this.value,
    this.hintText = 'Type to search...',
    this.enabled = true,
    this.debounceDuration = const Duration(milliseconds: 350),
  });

  @override
  State<SearchableAsyncDropdown<T>> createState() =>
      _SearchableAsyncDropdownState<T>();
}

class _SearchableAsyncDropdownState<T>
    extends State<SearchableAsyncDropdown<T>> {
  Future<void> _openSearch() async {
    if (!widget.enabled) return;

    final selected = await showDialog<T>(
      context: context,
      builder: (context) => _SearchDialog<T>(
        searchItems: widget.searchItems,
        itemLabelBuilder: widget.itemLabelBuilder,
        hintText: widget.hintText,
        debounceDuration: widget.debounceDuration,
      ),
    );

    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.value != null
        ? widget.itemLabelBuilder(widget.value as T)
        : null;

    return InkWell(
      onTap: _openSearch,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.search),
        ),
        child: Text(
          label ?? 'Tap to search',
          style: label == null
              ? TextStyle(color: Theme.of(context).hintColor)
              : null,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _SearchDialog<T> extends StatefulWidget {
  final Future<List<T>> Function(String query) searchItems;
  final String Function(T item) itemLabelBuilder;
  final String hintText;
  final Duration debounceDuration;

  const _SearchDialog({
    required this.searchItems,
    required this.itemLabelBuilder,
    required this.hintText,
    required this.debounceDuration,
  });

  @override
  State<_SearchDialog<T>> createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T> extends State<_SearchDialog<T>> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<T> _results = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() => _isLoading = true);
    try {
      final results = await widget.searchItems(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _results = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 400,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _onQueryChanged,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        return ListTile(
                          title: Text(widget.itemLabelBuilder(item)),
                          onTap: () => Navigator.of(context).pop(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
