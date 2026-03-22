import 'dart:developer' as developer;
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/whole_message_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class StandarizeErrors {
  /// Function to handle errors
  /// Returns `ErrorHandler` normalized.
  ///
  StandarizeErrors();

  /// Function to standarize errors from a dynamic data source.
  /// It will return an `ErrorHandler` object with the error code and description.
  ///
  static ErrorHandler standarizeErrors(dynamic pData) {
    const String functionName = 'standarizeErrors';
    const String logFunctionName = '.::$functionName::.';
    developer.log(
      'Function called with data: ${pData.toString()}',
      name: logFunctionName,
    );
    String sErrors = '';
    List<String> sErrorsList = [];
    switch (pData.runtimeType) {
      case const (ServiceProviderWholeMessageModel):
        var pWholeMessage = pData as ServiceProviderWholeMessageModel;
        developer.log(
            '$logFunctionName - Whole message received: ${pWholeMessage.errors.toString()}');
        sErrorsList = pWholeMessage.errors
            .map((e) =>
                'Código: ${e.code.toString().padLeft(4, '0')} - ${e.message}')
            .toList();
        String joinedErrorsList = sErrorsList.join('\r\n');
        developer.log(
            '$logFunctionName - Errors list: ${joinedErrorsList.toString()}');
        sErrors += joinedErrorsList;
        break;
      default:
        break;
    }
    if (pData != null &&
        ((pData.runtimeType == List<dynamic>) ||
            (pData is List<Map<String, dynamic>>))) {
      for (var element in (pData as List<dynamic>)) {
        if (sErrors.isNotEmpty) {
          sErrors += '\r\n';
        }
        sErrors +=
            'Código: ${element["Code"].toString().padLeft(4, '0')} - ${element["Message"]}';
        // If there are NativeErrors (they are always an Array of Errors)
        String sNativeErrors = '';
        if (element['NativeErrors'] != null &&
            element['NativeErrors'] is List<dynamic>) {
          for (var nativeError in (element['NativeErrors'] as List<dynamic>)) {
            if (sNativeErrors.isNotEmpty) {
              sNativeErrors += '\r\n';
            }
            sNativeErrors +=
                'Código: ${nativeError["Error_Code"].toString().padLeft(4, '0')} - ${nativeError["Error_Dsc"]}';
          }
          if (sNativeErrors.isNotEmpty) {
            sNativeErrors = 'Error nativo:\r\n$sNativeErrors';
          }
        }
        if (sErrors.isNotEmpty) {
          if (sNativeErrors.isNotEmpty) {
            sErrors += '\r\n$sNativeErrors';
          }
        }
      }
      if (sErrors.isNotEmpty) {
        sErrors = '\r\n$sErrors';
      }
    }
    int errorCode = 0;
    String errorDsc = sErrors;
    return ErrorHandler(errorCode: errorCode, errorDsc: errorDsc);
  }
}
