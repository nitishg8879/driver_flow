import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final DataTableSource source;
  final int rowsPerPage;
  final double minWidth;
  final double dataRowHeight;
  final Widget? empty;
  final PaginatorController? controller;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.source,
    this.rowsPerPage = 10,
    this.minWidth = 800,
    this.dataRowHeight = 64,
    this.empty,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        color: colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PaginatedDataTable2(
          columns: columns,
          source: source,
          rowsPerPage: rowsPerPage,
          minWidth: minWidth,
          dataRowHeight: dataRowHeight,
          headingRowHeight: 52,
          headingRowDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
          ),
          headingTextStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
          dataTextStyle: theme.textTheme.bodyMedium,
          wrapInCard: false,
          dividerThickness: 1,
          renderEmptyRowsInTheEnd: false,
          controller: controller,
          empty:
              empty ??
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 52,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No records found',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
