import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ServiceProviderLoginDataUserMessageModel {
  static final String _className = 'ServiceProviderLoginDataUserMessageModel';
  static final String logClassName = '.::$_className::.';
  final int userDefaultCodEmp;
  final String userDNI;
  final String userCUIT;
  final String userCodCatIVA;
  final String userRazonSocial;
  final String userEMail;
  final String userFirstName;
  final String userHashConfirm;
  final String userLanguage;
  final String userLastLoggedDate;
  final String userLastLoggedIP;
  final String userLastLoggedTime;
  final String userLastName;
  final bool userLoggedIn;
  final String userMiddleName;
  final String userName;
  final String saldoActual;
  final String ultFechaPago;
  final String ultFechaActSaldo;
  final String estado;
  final String roelaAliasCuentaBancaria;
  final String roelaCBUCuentaBancaria;
  final String numeroDeCuenta;
  final String codigoBarrasPMCnPF;
  final String codigoPMCnPF;

  Map<String, dynamic> toMap() {
    return {
      'userDefaultCodEmp': userDefaultCodEmp,
      'userDNI': userDNI,
      'userCUIT': userCUIT,
      'userCodCatIVA': userCodCatIVA,
      'userRazonSocial': userRazonSocial,
      'userEMail': userEMail,
      'userFirstName': userFirstName,
      'userHashConfirm': userHashConfirm,
      'userLanguage': userLanguage,
      'userLastLoggedDate': userLastLoggedDate,
      'userLastLoggedIP': userLastLoggedIP,
      'userLastLoggedTime': userLastLoggedTime,
      'userLastName': userLastName,
      'userLoggedIn': userLoggedIn,
      'userMiddleName': userMiddleName,
      'userName': userName,
      'saldoActual': saldoActual,
      'ultFechaPago': ultFechaPago,
      'ultFechaActSaldo': ultFechaActSaldo,
      'estado': estado,
      'roelaAliasCuentaBancaria': roelaAliasCuentaBancaria,
      'roelaCBUCuentaBancaria': roelaCBUCuentaBancaria,
      'numeroDeCuenta': numeroDeCuenta,
      'codigoBarrasPMCnPF': codigoBarrasPMCnPF,
      'codigoPMCnPF': codigoPMCnPF,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'UserDefaultCodEmp': userDefaultCodEmp,
      'UserDNI': userDNI,
      'UserCUIT': userCUIT,
      'UserCodCatIVA': userCodCatIVA,
      'UserRazonSocial': userRazonSocial,
      'UserEMail': userEMail,
      'UserFirstName': userFirstName,
      'UserHashConfirm': userHashConfirm,
      'UserLanguage': userLanguage,
      'UserLastLoggedDate': userLastLoggedDate,
      'UserLastLoggedIP': userLastLoggedIP,
      'UserLastLoggedTime': userLastLoggedTime,
      'UserLastName': userLastName,
      'UserLoggedIn': userLoggedIn,
      'UserMiddleName': userMiddleName,
      'UserName': userName,
      'SaldoActual': saldoActual,
      'UltFechaPago': ultFechaPago,
      'UltFechaActSaldo': ultFechaActSaldo,
      'Estado': estado,
      'RoelaAliasCuentaBancaria': roelaAliasCuentaBancaria,
      'RoelaCBUCuentaBancaria': roelaCBUCuentaBancaria,
      'NumeroDeCuenta': numeroDeCuenta,
      'CodigoBarrasPMCnPF': codigoBarrasPMCnPF,
      'CodigoPMCnPF': codigoPMCnPF,
    };
  }

  const ServiceProviderLoginDataUserMessageModel._internal({
    required this.userDefaultCodEmp,
    required this.userDNI,
    required this.userCUIT,
    required this.userCodCatIVA,
    required this.userRazonSocial,
    required this.userEMail,
    required this.userFirstName,
    required this.userHashConfirm,
    required this.userLanguage,
    required this.userLastLoggedDate,
    required this.userLastLoggedIP,
    required this.userLastLoggedTime,
    required this.userLastName,
    required this.userLoggedIn,
    required this.userMiddleName,
    required this.userName,
    required this.saldoActual,
    required this.ultFechaPago,
    required this.ultFechaActSaldo,
    required this.estado,
    required this.roelaAliasCuentaBancaria,
    required this.roelaCBUCuentaBancaria,
    required this.numeroDeCuenta,
    required this.codigoBarrasPMCnPF,
    required this.codigoPMCnPF,
  });

  factory ServiceProviderLoginDataUserMessageModel.fromJson(
      Map<String, dynamic> map) {
    final String functionName = 'fromJson';
    final String logFunctionName = '.::$functionName::.';

    /// We must validate the minimum needed properties to create a new instance of this.
    /// Otherwise, I MUST throw an exception PropertyException
    ///
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    List<String> propSanity = [
      'UserDefaultCodEmp',
      'UserDNI',
      'UserCUIT',
      'UserCodCatIVA',
      'UserRazonSocial',
      'UserEMail',
      'UserFirstName',
      'UserHashConfirm',
      'UserLanguage',
      'UserLastLoggedDate',
      'UserLastLoggedIP',
      'UserLastLoggedTime',
      'UserLastName',
      'UserLoggedIn',
      'UserMiddleName',
      'UserName',
      'SaldoActual',
      'UltFechaPago',
      'UltFechaActSaldo',
      'Estado',
      'RoelaAliasCuentaBancaria',
      'RoelaCBUCuentaBancaria',
      'NumeroDeCuenta',
      'CodigoBarrasPMCnPF',
      'CodigoPMCnPF',
    ];
    List<String> errorPropSanity = [];
    for (String prop in propSanity) {
      if (!map.containsKey(prop)) {
        errorPropSanity.add(prop);
      }
    }
    if (errorPropSanity.isNotEmpty) {
      var eMessage =
          'The following properties {${errorPropSanity.toString()}} haven\'t been provided by the backend.$supportMessage';
      throw ErrorHandler(
        errorCode: 200001,
        errorDsc: eMessage,
        className: _className,
        functionName: functionName,
        propertyName: propSanity.toString(),
        propertyValue: null,
        stacktrace: StackTrace.current,
      );
    }
    try {
      /// `UserDefaultCodEmp` can't be null and must be a number
      ///
      if (map['UserDefaultCodEmp'] == null ||
          int.tryParse(map['UserDefaultCodEmp'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserDefaultCodEmp',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      int userDefaultCodEmp = map['UserDefaultCodEmp'];

      /// `UserDNI`
      ///
      if (map['UserDNI'] == null || map['UserDNI'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserDNI',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userDNI = map['UserDNI'];

      /// `UserCUIT`
      ///
      if (map['UserCUIT'] == null || map['UserCUIT'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserCUIT',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userCUIT = map['UserCUIT'];

      /// `UserCodCatIVA`
      ///
      if (map['UserCodCatIVA'] == null ||
          map['UserCodCatIVA'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserCodCatIVA',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userCodCatIVA = map['UserCodCatIVA'];

      /// `UserRazonSocial`
      ///
      if (map['UserRazonSocial'] == null ||
          map['UserRazonSocial'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserRazonSocial',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userRazonSocial = map['UserRazonSocial'];

      /// `UserEMail`
      ///
      if (map['UserEMail'] == null || map['UserEMail'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserEMail',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userEMail = map['UserEMail'];

      /// `UserFirstName`
      ///
      if (map['UserFirstName'] == null ||
          map['UserFirstName'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserFirstName',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userFirstName = map['UserFirstName'];

      /// `UserHashConfirm`
      ///
      if (map['UserHashConfirm'] == null ||
          map['UserHashConfirm'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserHashConfirm',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userHashConfirm = map['UserHashConfirm'];

      /// `UserLanguage`
      ///
      if (map['UserLanguage'] == null ||
          map['UserLanguage'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserLanguage',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userLanguage = map['UserLanguage'];

      /// `UserLastLoggedIP`
      ///
      if (map['UserLastLoggedDate'] == null ||
          map['UserLastLoggedDate'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserLastLoggedDate',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userLastLoggedDate = map['UserLastLoggedDate'];

      /// `UserLastLoggedIP`
      ///
      if (map['UserLastLoggedIP'] == null ||
          map['UserLastLoggedIP'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserLastLoggedIP',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userLastLoggedIP = map['UserLastLoggedIP'];

      /// `UserLastLoggedTime`
      ///
      if (map['UserLastLoggedTime'] == null ||
          map['UserLastName'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserLastLoggedTime',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userLastLoggedTime = map['UserLastLoggedTime'];

      /// `UserLastName`
      ///
      if (map['UserLastName'] == null ||
          map['UserLastName'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserLastName',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userLastName = map['UserLastName'];

      /// `UserLoggedIn`
      ///
      bool userLoggedIn = false;
      if (map['UserLoggedIn'] == null &&
          map['UserLoggedIn'].runtimeType != bool &&
          //map['UserLoggedIn'].runtimeType != String ||
          (map['UserLoggedIn'].runtimeType == String &&
              bool.tryParse(map['UserLoggedIn'].toString()) == null)) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserLoggedIn',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      } else {
        if (map['UserLoggedIn'].runtimeType == bool) {
          userLoggedIn = map['UserLoggedIn'];
        } else {
          userLoggedIn = bool.parse(map['UserLoggedIn'].toString());
        }
      }

      /// `UserMiddleName`
      ///
      if (map['UserMiddleName'] == null ||
          map['UserMiddleName'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserMiddleName',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userMiddleName = map['UserMiddleName'];

      /// `UserName`
      ///
      if (map['UserName'] == null || map['UserName'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UserName',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String userName = map['UserName'];

      /// `SaldoActual`
      if (map['SaldoActual'] == null ||
          map['SaldoActual'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'SaldoActual',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String saldoActual = map['SaldoActual'];

      /// `UltFechaPago`
      if (map['UltFechaPago'] == null ||
          map['UltFechaPago'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UltFechaPago',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String ultFechaPago = map['UltFechaPago'];

      /// `UltFechaActSaldo`
      if (map['UltFechaActSaldo'] == null ||
          map['UltFechaActSaldo'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'UltFechaActSaldo',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String ultFechaActSaldo = map['UltFechaActSaldo'];

      /// `Estado`
      if (map['Estado'] == null || map['Estado'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'Estado',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String estado = map['Estado'];

      /// `RoelaAliasCuentaBancaria`
      String roelaAliasCuentaBancaria = map['RoelaAliasCuentaBancaria'] ?? '';

      /// `RoelaCBUCuentaBancaria`
      String roelaCBUCuentaBancaria = map['RoelaCBUCuentaBancaria'] ?? '';

      /// `NumeroDeCuenta`
      String numeroDeCuenta = map['NumeroDeCuenta'] ?? '';

      /// `CodigoBarrasPMCnPF`
      String codigoBarrasPMCnPF = map['CodigoBarrasPMCnPF'] ?? '';

      /// `CodigoPMCnPF`
      String codigoPMCnPF = map['CodigoPMCnPF'] ?? '';

      return ServiceProviderLoginDataUserMessageModel._internal(
        userDefaultCodEmp: userDefaultCodEmp,
        userDNI: userDNI,
        userCUIT: userCUIT,
        userCodCatIVA: userCodCatIVA,
        userRazonSocial: userRazonSocial,
        userEMail: userEMail,
        userFirstName: userFirstName,
        userHashConfirm: userHashConfirm,
        userLanguage: userLanguage,
        userLastLoggedDate: userLastLoggedDate,
        userLastLoggedIP: userLastLoggedIP,
        userLastLoggedTime: userLastLoggedTime,
        userLastName: userLastName,
        userLoggedIn: userLoggedIn,
        userMiddleName: userMiddleName,
        userName: userName,
        saldoActual: saldoActual,
        ultFechaPago: ultFechaPago,
        ultFechaActSaldo: ultFechaActSaldo,
        estado: estado,
        roelaAliasCuentaBancaria: roelaAliasCuentaBancaria,
        roelaCBUCuentaBancaria: roelaCBUCuentaBancaria,
        numeroDeCuenta: numeroDeCuenta,
        codigoBarrasPMCnPF: codigoBarrasPMCnPF,
        codigoPMCnPF: codigoPMCnPF,
      );
    } catch (e, stacktrace) {
      developer.log('$logClassName - $logFunctionName - [CATCHED] $e');
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 9999999,
          errorDsc: e.toString(),
          className: _className,
          functionName: functionName,
          propertyName: 'Desconocido',
          propertyValue: 'Desconocido',
          stacktrace: stacktrace,
        );
      }
    }
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! ServiceProviderLoginDataUserMessageModel) return false;

    Map<String, dynamic> thisMap = toMap();
    Map<String, dynamic> otherMap = other.toMap();

    for (String key in thisMap.keys) {
      if (thisMap[key].runtimeType != otherMap[key].runtimeType) {
        return false;
      }
      if (thisMap[key] != otherMap[key]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    return toMap().values.fold(0,
        (previousValue, element) => previousValue.hashCode + element.hashCode);
  }
}
