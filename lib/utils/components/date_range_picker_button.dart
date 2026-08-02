import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePickerButton extends StatelessWidget {
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?> onChanged;
  final String placeholder;

  const DateRangePickerButton({
    super.key,
    required this.onChanged,
    this.value,
    this.placeholder = 'All Dates',
  });

  String get _label {
    if (value == null) return placeholder;
    final fmt = DateFormat('MMM d');
    return '${fmt.format(value!.start)} – ${fmt.format(value!.end)}';
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: value,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasValue = value != null;
    return OutlinedButton(
      onPressed: () => _pick(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        side: BorderSide(
          color: hasValue ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: colorScheme.onSurface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.date_range_outlined,
            size: 16,
            color: hasValue ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            _label,
            style: TextStyle(
              color: hasValue ? colorScheme.primary : colorScheme.onSurfaceVariant,
              fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
          if (hasValue) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onChanged(null),
              behavior: HitTestBehavior.opaque,
              child: Icon(Icons.close, size: 14, color: colorScheme.primary),
            ),
          ],
        ],
      ),
    );
  }
}
