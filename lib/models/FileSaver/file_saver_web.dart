import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'package:js/js_util.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFileDescriptorModel/common_file_descriptor_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class FileSaver {
  Future<ErrorHandler> saveFileOnLocalDisk({
    required CommonFileDescriptorModel pFile,
    String pSubFolder = '',
  }) async {
    debugPrint('[FileSaverWEB] Ejecutando FileSaver para Web');

    try {
      final bytes = base64.decode(pFile.dataInBase64);
      final blobParts = jsify([Uint8List.fromList(bytes)]);
      final blob = web.Blob(blobParts);
      final url = web.URL.createObjectURL(blob);

      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = pFile.fileNameOnDisk.replaceAll('.::counter::.', '');
      anchor.style.display = 'none';
      web.document.body!.appendChild(anchor);
      anchor.click();
      web.document.body!.removeChild(anchor);

      web.URL.revokeObjectURL(url);

      return ErrorHandler(
        errorCode: 0,
        errorDsc: 'El archivo se descargó correctamente en el navegador.',
      );
    } catch (e, stacktrace) {
      return ErrorHandler(
        errorCode: 8888,
        errorDsc: 'Error al guardar archivo en Web.\nError: ${e.toString()}',
        stacktrace: stacktrace,
      );
    }
  }
}
