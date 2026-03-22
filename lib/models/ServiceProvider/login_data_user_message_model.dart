import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/CommonDateTimeModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonNumbersModel/number_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ServiceProviderLoginDataUserMessageModel {
  static final String _className = 'ServiceProviderLoginDataUserMessageModel';
  static final String logClassName = '.::$_className::.';
  final String dni;
  final String cuit;
  final String codCatIVA;
  final String descripcionCodCatIVA;
  final String razonSocial;
  final String email;
  final String firstName;
  final String hashConfirm;
  final String language;
  final CommonDateTimeModel lastLoggedDateTime;
  final String lastLoggedIP;
  final String lastName;
  final bool loggedIn;
  final String middleName;
  final String userName;
  final CommonNumbersModel saldoActual;
  final CommonDateTimeModel ultFechaPago;
  final CommonDateTimeModel ultFechaActSaldo;
  final String estado;
  final String roelaAliasCuentaBancaria;
  final String roelaCBUCuentaBancaria;
  final String numeroDeCuenta;
  final String codigoBarrasPMCnPF;
  final String codigoPMCnPF;
  final int codEmp;
  final String razonSocialCodEmp;
  final String tipoCliente;
  final int codClie;
  final List<ServiceProviderLoginDataUserMessageModel> clientes;
  int cCliente = 0;

  Map<String, dynamic> toMap() {
    return {
      'dni': dni,
      'cuit': cuit,
      'codCatIVA': codCatIVA,
      'descripcionCodCatIVA': descripcionCodCatIVA,
      'razonSocial': razonSocial,
      'email': email,
      'firstName': firstName,
      'hashConfirm': hashConfirm,
      'language': language,
      'lastLoggedDateTime': lastLoggedDateTime,
      'lastLoggedIP': lastLoggedIP,
      'lastName': lastName,
      'loggedIn': loggedIn,
      'middleName': middleName,
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
      'codEmp': codEmp,
      'razonSocialCodEmp': razonSocialCodEmp,
      'tipoCliente': tipoCliente,
      'codClie': codClie,
      'clientes': clientes,
      'cCliente': cCliente,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'DNI': dni,
      'CUIT': cuit,
      'CodCatIVA': codCatIVA,
      'DescripcionCodCatIVA': descripcionCodCatIVA,
      'RazonSocial': razonSocial,
      'EMail': email,
      'FirstName': firstName,
      'HashConfirm': hashConfirm,
      'Language': language,
      'LastLoggedDateTime': lastLoggedDateTime,
      'LastLoggedIP': lastLoggedIP,
      'LastName': lastName,
      'LoggedIn': loggedIn,
      'MiddleName': middleName,
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
      'CodEmp': codEmp,
      'RazonSocialCodEmp': razonSocialCodEmp,
      'TipoCliente': tipoCliente,
      'CodClie': codClie,
      'Clientes': clientes,
      'cCliente': cCliente,
    };
  }

  ServiceProviderLoginDataUserMessageModel._internal({
    required this.dni,
    required this.cuit,
    required this.codCatIVA,
    required this.descripcionCodCatIVA,
    required this.razonSocial,
    required this.email,
    required this.firstName,
    required this.hashConfirm,
    required this.language,
    required this.lastLoggedDateTime,
    required this.lastLoggedIP,
    required this.lastName,
    required this.loggedIn,
    required this.middleName,
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
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.tipoCliente,
    required this.codClie,
    required this.clientes,
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
      'DNI',
      'CUIT',
      'CodCatIVA',
      'RazonSocial',
      'EMail',
      'FirstName',
      'HashConfirm',
      'Language',
      'LastLoggedDateTime',
      'LastLoggedIP',
      'LastName',
      'LoggedIn',
      'MiddleName',
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
      'CodEmp',
      'RazonSocialCodEmp',
      'TipoCliente',
      'CodClie',
      'Clientes',
    ];
    List<String> errorPropSanity = [];
    for (String prop in propSanity) {
      if (!map.containsKey(prop)) {
        developer.log("MAPS:notfoudn: $prop");
        errorPropSanity.add(prop);
      }
    }
    if (errorPropSanity.isNotEmpty) {
      developer.log("MAPS: ${map.toString()}");
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
      /// `DNI`
      ///
      if (map['DNI'] == null || map['DNI'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'DNI',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String dni = map['DNI'];

      /// `CUIT`
      ///
      if (map['CUIT'] == null || map['CUIT'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'CUIT',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String cuit = map['CUIT'];

      /// `CodCatIVA`
      ///
      if (map['CodCatIVA'] == null || map['CodCatIVA'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'CodCatIVA',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String codCatIVA = map['CodCatIVA'];

      /// `DescripcionCodCatIVA`
      ///
      if (map['DescripcionCodCatIVA'] == null ||
          map['DescripcionCodCatIVA'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'DescripcionCodCatIVA',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String descripcionCodCatIVA = map['DescripcionCodCatIVA'];

      /// `RazonSocial`
      ///
      if (map['RazonSocial'] == null ||
          map['RazonSocial'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'RazonSocial',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String razonSocial = map['RazonSocial'];

      /// `EMail`
      ///
      if (map['EMail'] == null || map['EMail'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'EMail',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String email = map['EMail'];

      /// `FirstName`
      ///
      if (map['FirstName'] == null || map['FirstName'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'FirstName',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String firstName = map['FirstName'];

      /// `HashConfirm`
      ///
      if (map['HashConfirm'] == null ||
          map['HashConfirm'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'HashConfirm',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String hashConfirm = map['HashConfirm'];

      /// `Language`
      ///
      if (map['Language'] == null || map['Language'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'Language',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String language = map['Language'];

      /// `LastLoggedDateTime`
      ///
      var lastLoggedDateTime = CommonDateTimeModel.parse(
        map['LastLoggedDateTime'],
        fieldName: 'LastLoggedDateTime',
      );

      /// `LastLoggedIP`
      ///
      if (map['LastLoggedIP'] == null ||
          map['LastLoggedIP'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'LastLoggedIP',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String lastLoggedIP = map['LastLoggedIP'];

      /// `LastName`
      ///
      if (map['LastName'] == null || map['LastName'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'LastName',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String lastName = map['LastName'];

      /// `LoggedIn`
      ///
      bool loggedIn = false;
      if (map['LoggedIn'] == null &&
          map['LoggedIn'].runtimeType != bool &&
          //map['LoggedIn'].runtimeType != String ||
          (map['LoggedIn'].runtimeType == String &&
              bool.tryParse(map['LoggedIn'].toString()) == null)) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'LoggedIn',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      } else {
        if (map['LoggedIn'].runtimeType == bool) {
          loggedIn = map['LoggedIn'];
        } else {
          loggedIn = bool.parse(map['LoggedIn'].toString());
        }
      }

      /// `MiddleName`
      ///
      if (map['MiddleName'] == null ||
          map['MiddleName'].runtimeType != String) {
        throw ErrorHandler(
          errorCode: 200002,
          errorDsc: 'Can\'t be null. It must be a number.$supportMessage',
          className: _className,
          functionName: functionName,
          propertyName: 'MiddleName',
          propertyValue: null,
          stacktrace: StackTrace.current,
        );
      }
      String middleName = map['MiddleName'];

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
      var rSaldoActual = CommonNumbersModel.tryParse(
        map['SaldoActual'],
        fieldName: 'SaldoActual',
      );
      if (rSaldoActual.errorCode != 0) {
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
      CommonNumbersModel saldoActual = rSaldoActual.data;

      /// `UltFechaPago`
      var ultFechaPago = CommonDateTimeModel.parse(
        map['UltFechaPago'],
        fieldName: 'UltFechaPago',
      );

      /// `UltFechaActSaldo`
      var ultFechaActSaldo = CommonDateTimeModel.parse(
        map['UltFechaActSaldo'],
        fieldName: 'UltFechaActSaldo',
      );

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

      /// `CodEmp`
      int codEmp = map['CodEmp'] ?? 0;

      String razonSocialCodEmp = map['RazonSocialCodEmp'] ?? '';

      /// `TipoCliente`
      String tipoCliente = map['TipoCliente'] ?? '';

      /// `CodClie`
      int codClie = map['CodClie'] ?? 0;

      /// `Clientes`
      List<ServiceProviderLoginDataUserMessageModel> clientes = [];
      if (map['Clientes'] != null && map['Clientes'] is List<dynamic>) {
        for (var item in map['Clientes']) {
          if (item is Map<String, dynamic>) {
            clientes
                .add(ServiceProviderLoginDataUserMessageModel.fromJson(item));
          } else if (item is ServiceProviderLoginDataUserMessageModel) {
            clientes.add(item);
          } else {
            throw ErrorHandler(
              errorCode: 200003,
              errorDsc:
                  'Invalid type for Clientes. Expected Map<String, dynamic>. found ${item.runtimeType}.',
              className: _className,
              functionName: functionName,
              propertyName: 'Clientes',
              propertyValue: item.toString(),
              stacktrace: StackTrace.current,
            );
          }
        }
      } else {
        throw ErrorHandler(
          errorCode: 200003,
          errorDsc:
              'Invalid type for Clientes. Expected List<Map<String, dynamic>>.',
          className: _className,
          functionName: functionName,
          propertyName: 'Clientes',
          propertyValue: map['Clientes'].toString(),
          stacktrace: StackTrace.current,
        );
      }

      return ServiceProviderLoginDataUserMessageModel._internal(
        dni: dni,
        cuit: cuit,
        codCatIVA: codCatIVA,
        descripcionCodCatIVA: descripcionCodCatIVA,
        razonSocial: razonSocial,
        email: email,
        firstName: firstName,
        hashConfirm: hashConfirm,
        language: language,
        lastLoggedDateTime: lastLoggedDateTime,
        lastLoggedIP: lastLoggedIP,
        lastName: lastName,
        loggedIn: loggedIn,
        middleName: middleName,
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
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        tipoCliente: tipoCliente,
        codClie: codClie,
        clientes: clientes,
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
