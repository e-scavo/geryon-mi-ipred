import 'package:equatable/equatable.dart';
import 'package:geryon_web_app_ws_v2/models/CommonMessages/common_native_error_message_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonWholeMessageModel extends Equatable {
  final className = 'CommonWholeMessageModel';
  final int code;
  final String message;
  final String title;
  final String icon;
  final String redirectTo;
  final bool forceRedirectTo;
  final List<CommonNativeErrorMessageModel> nativeErrors;

  const CommonWholeMessageModel._internal({
    required this.code,
    required this.message,
    required this.title,
    required this.icon,
    required this.redirectTo,
    required this.forceRedirectTo,
    required this.nativeErrors,
  });

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Message': message,
      'Title': title,
      'Icon': icon,
      'RedirectTo': redirectTo,
      'ForceRedirectTo': forceRedirectTo,
      'NativeErrors': nativeErrors,
    };
  }

  factory CommonWholeMessageModel.fromJson(Map<String, dynamic> map) {
    /// We must validate the minimum needed properties to create a new instance of this.
    /// Otherwise, I MUST throw an exception PropertyException
    ///
    const className = 'CommonWholeMessageModel';
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    List<String> propSanity = [
      'Code',
      'Message',
      'Title',
      'Icon',
      'RedirectTo',
      'ForceRedirectTo',
      'NativeErrors',
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
      throw ErrorHandler(errorCode: 200001, errorDsc: eMessage);
    }
    try {
      /// `Code` can't be null and must be a number
      ///
      if (map['Code'] == null || int.tryParse(map['Code'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          propertyName: 'Code',
          className: className,
        );
      }
      int code = map['Code'];

      /// `Message`
      ///
      String message = "";
      if (map['Message'] == null || map['Message'].runtimeType != String) {
        if (code != 0) {
          message = "No se informó descripción del error encontrado";
        }
      } else {
        message = map['Message'];
      }

      /// `Title`
      ///
      String title = "";
      if (map['Title'] == null || map['Title'].runtimeType != String) {
        if (code != 0) {
          title = "¡Error!";
        }
      } else {
        title = map['Title'];
      }

      /// `Icon`
      ///
      String icon = "";
      if (map['Icon'] == null || map['Icon'].runtimeType != String) {
        if (code != 0) {
          icon = "error";
        }
      } else {
        icon = map['Icon'];
      }

      /// `RedirectTo`
      ///
      String redirectTo = "";
      if (map['RedirectTo'] == null ||
          map['RedirectTo'].runtimeType != String) {
        if (code != 0) {
          redirectTo = "";
        }
      } else {
        redirectTo = map['RedirectTo'];
      }

      /// `ForceRedirectTo`
      ///
      bool forceRedirectTo = false;
      if (map['ForceRedirectTo'] == null ||
          map['ForceRedirectTo'].runtimeType != bool ||
          map['ForceRedirectTo'].runtimeType != String) {
        if (code != 0) {
          forceRedirectTo = false;
        }
      } else {
        if (map['ForceRedirectTo'].runtimeType == bool) {
          forceRedirectTo = map['ForceRedirectTo'];
        } else {
          forceRedirectTo =
              bool.tryParse(map['ForceRedirectTo'].toString()) ?? false;
        }
      }

      /// `data` can't be null and must be Map<String, dynamic>.
      ///
      if (map['NativeErrors'] == null ||
          map['NativeErrors'] is! List<dynamic>) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc:
              'Can\'t be null AND must be a valid List<dyanmic>. It is ${map['NativeErrors'].runtimeType}.$supportMessage',
          propertyName: 'NativeErrors',
          className: className,
        );
      }
      List<CommonNativeErrorMessageModel> nativeErrors;
      try {
        nativeErrors = (map['NativeErrors'] as List<dynamic>)
            .map((e) => CommonNativeErrorMessageModel.fromJson(e))
            .toList();
      } catch (e, stacktrace) {
        if (e is ErrorHandler) {
          throw ErrorHandler(
            errorCode: e.errorCode,
            errorDsc: 'NativeErrors => ${e.errorDsc}',
            propertyName: 'nativeErrors => ${e.propertyName}',
            className: e.className,
            stacktrace: e.stacktrace,
          );
        } else {
          throw ErrorHandler(
            errorCode: 500004,
            errorDsc: '${e.toString()}.\r\n$supportMessage',
            propertyName: 'NativeErros => unknown',
            className: className,
            stacktrace: stacktrace,
          );
        }
      }

      return CommonWholeMessageModel._internal(
        code: code,
        message: message,
        title: title,
        icon: icon,
        redirectTo: redirectTo,
        forceRedirectTo: forceRedirectTo,
        nativeErrors: nativeErrors,
      );
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 500003,
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
        code,
        message,
        title,
        icon,
        redirectTo,
        forceRedirectTo,
        nativeErrors,
      ];
}
