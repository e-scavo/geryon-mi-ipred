import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/models/billing_workbench_column.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench_header.dart';
import 'package:geryon_web_app_ws_v2/features/billing/presentation/widgets/billing_workbench_row.dart';

class BillingWorkbenchTable extends StatefulWidget {
  final List<Map<String, dynamic>> rows;
  final List<BillingWorkbenchColumn> columns;
  final double tableWidth;
  final ValueChanged<Map<String, dynamic>> onDownload;

  const BillingWorkbenchTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.tableWidth,
    required this.onDownload,
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

    return DecoratedBox(
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
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,
            notificationPredicate: (notification) =>
                notification.metrics.axis == Axis.horizontal,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: widget.tableWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BillingWorkbenchHeader(
                      columns: widget.columns,
                      tableWidth: widget.tableWidth,
                    ),
                    if (widget.rows.isEmpty)
                      SizedBox(
                        width: widget.tableWidth,
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
                          tableWidth: widget.tableWidth,
                          alternate: index.isOdd,
                          onDownload: () {
                            widget.onDownload(widget.rows[index]);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
