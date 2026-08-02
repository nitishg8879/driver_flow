import 'package:flutter/material.dart';

/// A generic dropdown that fetches its items asynchronously (Future-based)
/// and lets the caller decide how to render/label each item.
///
/// Example:
/// ```dart
/// AsyncDropdown<VehicleTypeModel>(
///   fetchItems: () => vehicleTypeRepository.getActiveVehicleTypes(),
///   itemLabelBuilder: (type) => type.name,
///   value: _selectedVehicleType,
///   onChanged: (type) => setState(() => _selectedVehicleType = type),
///   labelText: 'Vehicle Type',
/// )
/// ```
class AsyncDropdown<T> extends StatefulWidget {
  final Future<List<T>> Function() fetchItems;
  final String Function(T item) itemLabelBuilder;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String labelText;
  final String? Function(T?)? validator;
  final bool enabled;
  // When set, prepends a null "All" item with this label (e.g., "All Instructors")
  final String? nullItemLabel;

  const AsyncDropdown({
    super.key,
    required this.fetchItems,
    required this.itemLabelBuilder,
    required this.onChanged,
    required this.labelText,
    this.value,
    this.validator,
    this.enabled = true,
    this.nullItemLabel,
  });

  @override
  State<AsyncDropdown<T>> createState() => _AsyncDropdownState<T>();
}

class _AsyncDropdownState<T> extends State<AsyncDropdown<T>> {
  late Future<List<T>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.fetchItems();
  }

  Future<void> _reload() async {
    setState(() {
      _itemsFuture = widget.fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: _itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
            ),
            child: const SizedBox(
              height: 20,
              child: Center(
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
              errorText: 'Failed to load options',
            ),
            child: Row(
              children: [
                const Expanded(child: Text('Could not load options')),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  onPressed: _reload,
                ),
              ],
            ),
          );
        }

        final items = snapshot.data ?? [];

        return DropdownButtonFormField<T?>(
          value: widget.value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: [
            if (widget.nullItemLabel != null)
              DropdownMenuItem<T?>(
                value: null,
                child: Text(
                  widget.nullItemLabel!,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ...items.map(
              (item) => DropdownMenuItem<T?>(
                value: item,
                child: Text(widget.itemLabelBuilder(item)),
              ),
            ),
          ],
          onChanged: widget.enabled ? widget.onChanged : null,
          validator: widget.validator,
        );
      },
    );
  }
}
