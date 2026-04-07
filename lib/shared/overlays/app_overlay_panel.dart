import 'package:flutter/material.dart';

class AppOverlayPanel extends StatelessWidget {
  final String title;
  final BoxConstraints constraints;
  final Color titleColorBackground;
  final Widget? headerWidget;
  final Widget? bodyWidget;
  final Widget? footerWidget;
  final VoidCallback? onClose;

  const AppOverlayPanel({
    super.key,
    required this.title,
    required this.constraints,
    this.titleColorBackground = Colors.black45,
    this.headerWidget,
    this.bodyWidget,
    this.footerWidget,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasHeader = headerWidget != null;
    final bool hasFooter = footerWidget != null;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 24,
              offset: Offset(0, 12),
              color: Color(0x24000000),
            ),
          ],
        ),
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Container(
                height: 44,
                width: double.infinity,
                color: titleColorBackground,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (onClose != null)
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed: onClose,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.black26),
                      left: BorderSide(color: Colors.black26),
                      right: BorderSide(color: Colors.black26),
                      bottom: BorderSide(color: Colors.black26),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (hasHeader) headerWidget!,
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: bodyWidget ?? const SizedBox(),
                        ),
                      ),
                      if (hasFooter) footerWidget!,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
