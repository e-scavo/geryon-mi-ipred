import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const CopyableListTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  void _copyValue(BuildContext context) {
    final String normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      return;
    }

    Clipboard.setData(ClipboardData(text: normalizedValue));

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1400),
          content: Text('"$label" copiado al portapapeles'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _copyValue(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        value,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Copiar $label',
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copyValue(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
