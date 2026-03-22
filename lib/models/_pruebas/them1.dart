import 'package:flutter/material.dart';

class StyledComponentsDemo extends StatelessWidget {
  const StyledComponentsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('IPRED UI Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔴 Botón principal (rojo IPRED)
            ElevatedButton.icon(
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Acción Principal'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // 🔵 Botón secundario (azul IPRED)
            OutlinedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text('Acción Secundaria'),
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.secondary,
                side: BorderSide(color: colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 24),

            // 📝 Card informativa
            Card(
              color: colorScheme.surface,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información Importante',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este componente está adaptado con los colores institucionales de IPRED.',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🔔 Diálogo personalizado
            ElevatedButton(
              child: const Text('Mostrar Diálogo'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: colorScheme.surface,
                    title: Text('Confirmar acción',
                        style: TextStyle(color: colorScheme.primary)),
                    content: Text('¿Deseás continuar?',
                        style: TextStyle(color: colorScheme.onSurface)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar',
                            style: TextStyle(color: colorScheme.secondary)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Aceptar',
                            style: TextStyle(color: colorScheme.primary)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
