import 'package:flutter/material.dart';

class FeatureErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String? retryLabel;
  final VoidCallback? onRetry;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final bool compact;

  const FeatureErrorState({
    super.key,
    this.title = 'No pudimos cargar esta sección',
    required this.message,
    this.retryLabel,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.padding = const EdgeInsets.all(20),
    this.maxWidth = 560,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canRetry =
        onRetry != null && retryLabel != null && retryLabel!.trim().isNotEmpty;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: Card(
            elevation: 2,
            surfaceTintColor: theme.colorScheme.surface,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 18 : 24,
                vertical: compact ? 16 : 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: compact ? 32 : 40,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(height: compact ? 12 : 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: compact ? 8 : 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (canRetry) ...[
                    SizedBox(height: compact ? 12 : 18),
                    OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text(retryLabel!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
