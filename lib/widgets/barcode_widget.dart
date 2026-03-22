import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart';
import 'dart:typed_data';
import 'dart:convert';

class BarcodeWidget extends StatelessWidget {
  final String data;

  const BarcodeWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bc = Barcode.code128();
    final svg = bc.toSvg(data, width: 300, height: 80);
    final bytes = Uint8List.fromList(utf8.encode(svg));

    return SizedBox(
      height: 100,
      child: Center(child: Image.memory(bytes, fit: BoxFit.contain)),
    );
  }
}