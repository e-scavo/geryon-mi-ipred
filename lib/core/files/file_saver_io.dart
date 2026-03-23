import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFileDescriptorModel/common_file_descriptor_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileSaver {
  Future<ErrorHandler> saveFileOnLocalDisk({
    required CommonFileDescriptorModel pFile,
    String pSubFolder = '',
  }) async {
    debugPrint('[FileSaverIO] Ejecutando FileSaver para IO (Android/Desktop)');

    try {
      final directory = await getApplicationDocumentsDirectory();
      final subdirectory = Directory(path.join(directory.path, pSubFolder));
      final bytes = base64.decode(pFile.dataInBase64);

      if (!await subdirectory.exists()) {
        await subdirectory.create(recursive: true);
      }

      String fileNameOnDisk =
          pFile.fileNameOnDisk.replaceAll('.::counter::.', '');
      String filePath = path.join(subdirectory.path, fileNameOnDisk);
      File file = File(filePath);

      int counter = 1;
      while (await file.exists()) {
        fileNameOnDisk =
            pFile.fileNameOnDisk.replaceAll('.::counter::.', "-$counter");
        filePath = path.join(subdirectory.path, fileNameOnDisk);
        file = File(filePath);
        counter++;
      }

      await file.writeAsBytes(bytes);
      return ErrorHandler(
        errorCode: 0,
        errorDsc:
            'El archivo se guardó correctamente en disco.\nArchivo: $filePath',
      );
    } catch (e, stacktrace) {
      return ErrorHandler(
        errorCode: 8888,
        errorDsc: 'Error al guardar archivo.\nError: ${e.toString()}',
        stacktrace: stacktrace,
      );
    }
  }
}
