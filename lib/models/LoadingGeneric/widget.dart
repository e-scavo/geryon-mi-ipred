import 'package:flutter/material.dart';

class LoadingGeneric extends StatefulWidget {
  final String loadingText;
  const LoadingGeneric({
    super.key,
    this.loadingText = 'Cargando...',
  });

  @override
  State<LoadingGeneric> createState() => _LoadingGenericState();
}

class _LoadingGenericState extends State<LoadingGeneric> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(
          widget.loadingText,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        if (1 == 2)
          SizedBox(
            height: 63.75,
            width: 85,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 5),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.back_hand),
                  Text(
                    'Volver',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
      ],
    );
  }
}
