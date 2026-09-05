import 'package:flutter/material.dart';

class AppOverlayPanel extends StatelessWidget {
  final String title;
  final BoxConstraints constraints;
  final Color? titleColorBackground;
  final Widget? headerWidget;
  final Widget? bodyWidget;
  final Widget? footerWidget;
  final VoidCallback? onClose;

  const AppOverlayPanel({
    super.key,
    required this.title,
    required this.constraints,
    this.titleColorBackground,
    this.headerWidget,
    this.bodyWidget,
    this.footerWidget,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool hasHeader = headerWidget != null;
    final bool hasFooter = footerWidget != null;
    final Color effectiveTitleBackground =
        titleColorBackground ?? colorScheme.primary;
    final Color titleForeground =
        effectiveTitleBackground == colorScheme.primary
            ? colorScheme.onPrimary
            : effectiveTitleBackground == colorScheme.secondary
                ? colorScheme.onSecondary
                : effectiveTitleBackground == colorScheme.error
                    ? colorScheme.onError
                    : ThemeData.estimateBrightnessForColor(
                                effectiveTitleBackground) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 12),
              color: theme.shadowColor.withValues(alpha: 0.14),
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
                color: effectiveTitleBackground,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: titleForeground,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (onClose != null)
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed: onClose,
                        icon: Icon(
                          Icons.close,
                          color: titleForeground,
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
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: colorScheme.outlineVariant),
                      left: BorderSide(color: colorScheme.outlineVariant),
                      right: BorderSide(color: colorScheme.outlineVariant),
                      bottom: BorderSide(color: colorScheme.outlineVariant),
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
