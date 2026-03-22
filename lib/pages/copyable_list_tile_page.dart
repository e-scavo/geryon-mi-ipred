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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text("$label: $value"),
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Copiado al portapapeles")),
          );
        },
      ),
    );
  }
}
