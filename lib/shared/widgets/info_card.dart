import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onAction;
  final String? actionLabel;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasAction = onAction != null && actionLabel != null;

    return Card(
      elevation: 2,
      surfaceTintColor: theme.colorScheme.surface,
      child: SizedBox(
        width: 250,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 122,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: hasAction
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (hasAction) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAction,
                      icon: const Icon(Icons.payment, size: 18),
                      label: Text(
                        actionLabel!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
