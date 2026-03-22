part of '../common_utils.dart';

ErrorHandler standarizeErrors(List<CommonWholeMessageModel> pData) {
  String sErrors = '';
  developer.log(
    'Update1: standarizeErrors $pData runtime:${pData.runtimeType}',
    name: 'CommonUtils',
  );

  for (var element in pData) {
    developer.log(
      'Update2: standarizeErrors $element',
      name: 'CommonUtils',
    );
    if (sErrors.isNotEmpty) {
      sErrors += '\r\n';
    }
    sErrors +=
        'Código: ${element.code.toString().padLeft(4, '0')} - ${element.message}';
    // If there are NativeErrors (they are always an Array of Errors)
    String sNativeErrors = '';
    for (var nativeError in element.nativeErrors) {
      if (sNativeErrors.isNotEmpty) {
        sNativeErrors += '\r\n\t';
      }
      sNativeErrors +=
          'Código: ${nativeError.errorCode.toString().padLeft(4, '0')} - ${nativeError.errorDsc}';
    }
    if (sNativeErrors.isNotEmpty) {
      sNativeErrors = 'Error nativo:\r\n$sNativeErrors';
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
  int errorCode = 0;
  String errorDsc = sErrors;
  return ErrorHandler(errorCode: errorCode, errorDsc: errorDsc);
}
