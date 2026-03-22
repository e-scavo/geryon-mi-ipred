import 'package:equatable/equatable.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonNativeErrorMessageModel extends Equatable {
  final className = 'CommonNativeErrorMessageModel';
  final int errorCode;
  final String errorDsc;
  final int errorCodeRaw;
  final String errorDscRaw;

  const CommonNativeErrorMessageModel._internal({
    required this.errorCode,
    required this.errorDsc,
    required this.errorCodeRaw,
    required this.errorDscRaw,
  });

  Map<String, dynamic> toMap() {
    return {
      'errorCode': errorCode,
      'errorDsc': errorDsc,
      'errorCodeRaw': errorCodeRaw,
      'errorDscRaw': errorDscRaw,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'Error_Code': errorCode,
      'Error_Dsc': errorDsc,
      'Error_Code_Raw': errorCodeRaw,
      'Error_Dsc_Raw': errorDscRaw,
    };
  }

  factory CommonNativeErrorMessageModel.fromJson(Map<String, dynamic> map) {
    /// We must validate the minimum needed properties to create a new instance of this.
    /// Otherwise, I MUST throw an exception PropertyException
    ///
    const String className = 'CommonNativeErrorMessageModel';
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    List<String> propSanity = [
      'Error_Code',
      'Error_Dsc',
      'Error_Code_Raw',
      'Error_Dsc_Raw',
    ];
    List<String> errorPropSanity = [];
    for (String prop in propSanity) {
      if (!map.containsKey(prop)) {
        errorPropSanity.add(prop);
      }
    }
    if (errorPropSanity.isNotEmpty) {
      var eMessage =
          'The following properties {${propSanity.toString()}} haven\'t been provided by the backend.$supportMessage';
      throw ErrorHandler(
        errorCode: 200001,
        errorDsc: eMessage,
        className: className,
      );
    }
    try {
      /// `Error_Code` can't be null and must be a number
      ///
      if (map['Error_Code'] == null ||
          int.tryParse(map['Error_Code'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          propertyName: 'Error_Code',
          className: className,
        );
      }
      int errorCode = map['Error_Code'];

      /// `Error_Dsc`
      ///
      String errorDsc = "";
      if (map['Error_Dsc'] == null || map['Error_Dsc'].runtimeType != String) {
        if (errorCode != 0) {
          errorDsc = "No se informó descripción del error encontrado";
        }
      } else {
        errorDsc = map['Error_Dsc'];
      }

      /// `Error_Code_Raw` can't be null and must be a number
      ///
      if (map['Error_Code_Raw'] == null ||
          int.tryParse(map['Error_Code_Raw'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          propertyName: 'Error_Code_Raw',
          className: className,
        );
      }
      int errorCodeRaw = map['Error_Code_Raw'];

      /// `Error_Dsc_Raw`
      ///
      String errorDscRaw = "";
      if (map['Error_Dsc_Raw'] == null ||
          map['Error_Dsc_Raw'].runtimeType != String) {
        if (errorCodeRaw != 0) {
          errorDscRaw = "No se informó descripción del error encontrado";
        }
      } else {
        errorDscRaw = map['Error_Dsc_Raw'];
      }

      return CommonNativeErrorMessageModel._internal(
        errorCode: errorCode,
        errorDsc: errorDsc,
        errorCodeRaw: errorCodeRaw,
        errorDscRaw: errorDscRaw,
      );
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        throw ErrorHandler(
          errorCode: e.errorCode,
          errorDsc: e.errorDsc,
          propertyName: e.propertyName,
          className: e.className,
          stacktrace: e.stacktrace ?? stacktrace,
        );
      } else {
        throw ErrorHandler(
          errorCode: 500005,
          errorDsc: '${e.toString()}.\r\n$supportMessage',
          propertyName: 'unknown',
          className: className,
          stacktrace: stacktrace,
        );
      }
    }
  }
  @override
  List<Object?> get props => [
        errorCode,
        errorDsc,
        errorCodeRaw,
        errorDscRaw,
      ];
}
