import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDataTable extends StatefulWidget {
  const AppDataTable({
    required this.columns,
    required this.source,
    super.key,
    this.rowsPerPage = 10,
    this.minWidth = 800,
    this.dataRowHeight = 64,
    this.headingRowHeight = 52,
    this.columnSpacing = 16,
    this.fixedLeftColumns = 0,
    this.smRatio = 0.67,
    this.lmRatio = 1.2,
    this.autoRowsToHeight = false,
    this.hidePaginator = false,
    this.wrapInCard = false,
    this.isOverlayChildEnabled = true,
    this.empty,
    this.onError,
    this.controller,
    this.overlayController,
    this.overlayChildBuilder,
    this.dataRowCheckboxTheme,
    this.headerCheckboxTheme,
    this.onTapOutside,
  });

  final List<DataColumn> columns;
  final DataTableSource source;
  final int rowsPerPage;
  final double minWidth;
  final double dataRowHeight;
  final double headingRowHeight;
  final double columnSpacing;
  final int fixedLeftColumns;
  final double smRatio;
  final double lmRatio;
  final bool autoRowsToHeight;
  final bool hidePaginator;
  final bool wrapInCard;
  final bool isOverlayChildEnabled;

  final Widget? empty;
  final Widget Function(Object?)? onError;
  final PaginatorController? controller;
  final OverlayPortalController? overlayController;
  final Widget Function(BuildContext)? overlayChildBuilder;
  final CheckboxThemeData? dataRowCheckboxTheme;
  final CheckboxThemeData? headerCheckboxTheme;
  final VoidCallback? onTapOutside;

  @override
  State<AppDataTable> createState() => _AppDataTableState();
}

class _AppDataTableState extends State<AppDataTable> {
  final GlobalKey _overlayKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _dismissOverlayAndDeselect() {
    widget.overlayController?.hide();
    if (widget.source is AsyncDataTableSource) {
      (widget.source as AsyncDataTableSource).deselectAll();
    }
    widget.onTapOutside?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        color: colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildOverlayWrapper(context),
      ),
    );
  }

  Widget _buildOverlayWrapper(BuildContext context) {
    if (widget.overlayController == null ||
        widget.overlayChildBuilder == null) {
      return _buildTable(context);
    }

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _dismissOverlayAndDeselect();
        }
      },
      child: TapRegion(
        onTapOutside: (event) {
          final overlayBox =
              _overlayKey.currentContext?.findRenderObject() as RenderBox?;
          final tableBox = context.findRenderObject() as RenderBox?;

          if (overlayBox == null || tableBox == null) return;

          final overlayRect = Rect.fromPoints(
            overlayBox.localToGlobal(Offset.zero),
            overlayBox.localToGlobal(overlayBox.size.bottomRight(Offset.zero)),
          );
          final tableRect = Rect.fromPoints(
            tableBox.localToGlobal(Offset.zero),
            tableBox.localToGlobal(tableBox.size.bottomRight(Offset.zero)),
          );

          final tapPos = event.position;
          if (!overlayRect.contains(tapPos) && !tableRect.contains(tapPos)) {
            _dismissOverlayAndDeselect();
          }
        },
        child: OverlayPortal(
          controller: widget.overlayController!,
          overlayChildBuilder: (ctx) => !widget.isOverlayChildEnabled
              ? const SizedBox()
              : Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    key: _overlayKey,
                    child: widget.overlayChildBuilder!(ctx),
                  ),
                ),
          child: _buildTable(context),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final headingDecoration = BoxDecoration(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    );

    final headingStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurfaceVariant,
      letterSpacing: 0.5,
    );

    const tableBorder = TableBorder.symmetric(
      inside: BorderSide(color: Colors.transparent),
    );

    final defaultCheckboxTheme = CheckboxThemeData(
      splashRadius: 10,
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.error)
              ? colorScheme.error
              : states.contains(WidgetState.disabled)
              ? colorScheme.onSurface.withValues(alpha: 0.38)
              : colorScheme.primary,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );

    if (widget.source is AsyncDataTableSource) {
      return AsyncPaginatedDataTable2(
        columns: widget.columns,
        source: widget.source as AsyncDataTableSource,
        rowsPerPage: widget.rowsPerPage,
        minWidth: widget.minWidth,
        dataRowHeight: widget.dataRowHeight,
        headingRowHeight: widget.headingRowHeight,
        columnSpacing: widget.columnSpacing,
        fixedLeftColumns: widget.fixedLeftColumns,
        smRatio: widget.smRatio,
        lmRatio: widget.lmRatio,
        autoRowsToHeight: widget.autoRowsToHeight,
        hidePaginator: widget.hidePaginator,
        wrapInCard: widget.wrapInCard,
        pageSyncApproach: PageSyncApproach.goToFirst,
        headingRowDecoration: headingDecoration,
        headingTextStyle: headingStyle,
        dataTextStyle: theme.textTheme.bodyMedium,
        border: tableBorder,
        dividerThickness: 1,
        renderEmptyRowsInTheEnd: false,
        isHorizontalScrollBarVisible: true,
        isVerticalScrollBarVisible: true,
        controller: widget.controller,
        datarowCheckboxTheme:
            widget.dataRowCheckboxTheme ?? defaultCheckboxTheme,
        headingCheckboxTheme:
            widget.headerCheckboxTheme ?? defaultCheckboxTheme,
        loading: _buildLoadingIndicator(colorScheme),
        empty: widget.empty ?? _buildEmptyWidget(theme, colorScheme),
        errorBuilder:
            widget.onError ??
            (error) => _buildErrorWidget(theme, colorScheme, error),
      );
    }

    return PaginatedDataTable2(
      columns: widget.columns,
      source: widget.source,
      rowsPerPage: widget.rowsPerPage,
      minWidth: widget.minWidth,
      dataRowHeight: widget.dataRowHeight,
      headingRowHeight: widget.headingRowHeight,
      columnSpacing: widget.columnSpacing,
      fixedLeftColumns: widget.fixedLeftColumns,
      smRatio: widget.smRatio,
      lmRatio: widget.lmRatio,
      autoRowsToHeight: widget.autoRowsToHeight,
      hidePaginator: widget.hidePaginator,
      wrapInCard: widget.wrapInCard,
      headingRowDecoration: headingDecoration,
      headingTextStyle: headingStyle,
      dataTextStyle: theme.textTheme.bodyMedium,
      border: tableBorder,
      dividerThickness: 1,
      renderEmptyRowsInTheEnd: false,
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      controller: widget.controller,
      datarowCheckboxTheme: widget.dataRowCheckboxTheme ?? defaultCheckboxTheme,
      headingCheckboxTheme: widget.headerCheckboxTheme ?? defaultCheckboxTheme,
      empty: widget.empty ?? _buildEmptyWidget(theme, colorScheme),
    );
  }

  Widget _buildLoadingIndicator(ColorScheme colorScheme) {
    return Center(
      child: SizedBox(
        width: 34,
        height: 34,
        child: CircularProgressIndicator(
          color: colorScheme.primary,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 52,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
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
    );
  }

  Widget _buildErrorWidget(
    ThemeData theme,
    ColorScheme colorScheme,
    Object? error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 52,
              color: colorScheme.error.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            SelectableText(
              kDebugMode
                  ? 'Error loading data: ${error.toString()}'
                  : 'Technical Error, Please try again later.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: widget.source is AsyncDataTableSource
                  ? (widget.source as AsyncDataTableSource).refreshDatasource
                  : null,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
