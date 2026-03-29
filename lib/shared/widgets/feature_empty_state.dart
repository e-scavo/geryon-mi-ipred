import 'package:flutter/material.dart';

class FeatureEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const FeatureEmptyState({
    super.key,
    this.title = 'No hay datos disponibles',
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
    this.padding = const EdgeInsets.all(20),
    this.maxWidth = 560,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAction = onAction != null &&
        actionLabel != null &&
        actionLabel!.trim().isNotEmpty;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: Card(
            elevation: 2,
            surfaceTintColor: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (hasAction) ...[
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: onAction,
                      icon: const Icon(Icons.refresh),
                      label: Text(actionLabel!),
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
