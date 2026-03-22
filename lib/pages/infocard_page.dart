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
    return Card(
      elevation: 3,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey[700],
                      )),
              const SizedBox(height: 8),
              Text(value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.payment, size: 18),
                  label: Text(actionLabel!),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
