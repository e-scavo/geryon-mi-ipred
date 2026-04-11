import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/models/billing_workbench_column.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench_header.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench_row.dart';

class BillingWorkbenchTable extends StatefulWidget {
  final List<Map<String, dynamic>> rows;
  final List<BillingWorkbenchColumn> columns;
  final double tableWidth;
  final String sortField;
  final bool sortAsc;
  final bool isRefreshing;
  final ValueChanged<BillingWorkbenchColumn>? onSortRequested;
  final ValueChanged<Map<String, dynamic>> onDownload;
  final Future<void> Function(BuildContext context, Map<String, dynamic> item)
      onCopy;
  final Future<void> Function(BuildContext context, Map<String, dynamic> item)
      onShare;

  const BillingWorkbenchTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.tableWidth,
    required this.sortField,
    required this.sortAsc,
    this.isRefreshing = false,
    this.onSortRequested,
    required this.onDownload,
    required this.onCopy,
    required this.onShare,
  });

  @override
  State<BillingWorkbenchTable> createState() => _BillingWorkbenchTableState();
}

class _BillingWorkbenchTableState extends State<BillingWorkbenchTable> {
  late final ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollBehavior = MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double effectiveTableWidth = math.max(
          widget.tableWidth,
          constraints.hasBoundedWidth
              ? constraints.maxWidth
              : widget.tableWidth,
        );
        final bool showHorizontalScrollbar = constraints.hasBoundedWidth &&
            effectiveTableWidth > constraints.maxWidth;

        return Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ScrollConfiguration(
                  behavior: scrollBehavior,
                  child: Scrollbar(
                    controller: _horizontalController,
                    thumbVisibility: showHorizontalScrollbar,
                    trackVisibility: showHorizontalScrollbar,
                    interactive: true,
                    notificationPredicate: (notification) =>
                        notification.metrics.axis == Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        width: effectiveTableWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BillingWorkbenchHeader(
                              columns: widget.columns,
                              tableWidth: effectiveTableWidth,
                              sortField: widget.sortField,
                              sortAsc: widget.sortAsc,
                              onSortRequested: widget.onSortRequested,
                            ),
                            if (widget.rows.isEmpty)
                              SizedBox(
                                width: effectiveTableWidth,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'No hay comprobantes por mostrar en esta página.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            else
                              ...List.generate(
                                widget.rows.length,
                                (index) => BillingWorkbenchRow(
                                  item: widget.rows[index],
                                  columns: widget.columns,
                                  tableWidth: effectiveTableWidth,
                                  alternate: index.isOdd,
                                  onDownload: () =>
                                      widget.onDownload(widget.rows[index]),
                                  onCopy: () => widget.onCopy(
                                    context,
                                    widget.rows[index],
                                  ),
                                  onShare: () => widget.onShare(
                                    context,
                                    widget.rows[index],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !widget.isRefreshing,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: widget.isRefreshing ? 1 : 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.60),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        const LinearProgressIndicator(minHeight: 2),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 10),
                              Text('Actualizando tabla...'),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
