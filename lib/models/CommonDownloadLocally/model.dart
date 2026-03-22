import 'dart:developer';

import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';

class CommonDownloadLocallyModel
    implements CommonModel<CommonDownloadLocallyModel> {
  static String className = 'CommonDownloadLocallyModel';

  String modulo;
  String claseCpbte;
  int codEmp;
  int nroCpbte;
  String tipoCliente;
  int codClie;
  String razonSocial;

  CommonDownloadLocallyModel._internal({
    required this.modulo,
    required this.claseCpbte,
    required this.codEmp,
    required this.nroCpbte,
    required this.tipoCliente,
    required this.codClie,
    required this.razonSocial,
  });

  factory CommonDownloadLocallyModel.fromDefault() {
    var modulo = '';
    var claseCpbte = '';
    var codEmp = -1;
    var nroCpbte = -1;
    var tipoCliente = '';
    var codClie = -1;
    var razonSocial = '';
    return CommonDownloadLocallyModel._internal(
      modulo: modulo,
      claseCpbte: claseCpbte,
      codEmp: codEmp,
      nroCpbte: nroCpbte,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocial: razonSocial,
    );
  }

  factory CommonDownloadLocallyModel.fromClaseCpbte({
    required String pModulo,
    required String pClaseCpbte,
    required int pCodEmp,
    required int pNroCpbte,
  }) {
    var modulo = pModulo;
    var claseCpbte = pClaseCpbte;
    var codEmp = pCodEmp;
    var nroCpbte = pNroCpbte;
    var tipoCliente = '';
    var codClie = -1;
    var razonSocial = '';
    return CommonDownloadLocallyModel._internal(
      modulo: modulo,
      claseCpbte: claseCpbte,
      codEmp: codEmp,
      nroCpbte: nroCpbte,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocial: razonSocial,
    );
  }

  /// toJson
  ///
  @override
  Map<String, dynamic> toJson() {
    return {
      'Modulo': modulo,
      'ClaseCpbte': claseCpbte,
      'CodEmp': codEmp,
      'NroCpbte': nroCpbte,
      'TipoCliente': tipoCliente,
      'CodClie': codClie,
      'RazonSocial': razonSocial,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return toJson();
  }

  @override
  String toString() {
    return toJson.toString();
  }

  @override
  Map<String, dynamic> getKeyEntity() {
    return toJson();
  }

  factory CommonDownloadLocallyModel.fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
  }) {
    log("Generic_FromJSON - CommonDownloadLocallyModel.fromJson");
    var modulo = map["Modulo"].toString();
    var claseCpbte = map["ClaseCpbte"].toString();
    var codEmp = int.parse(map["CodEmp"].toString());
    var nroCpbte = int.parse(map["NroCpbte"].toString());
    var tipoCliente = map["TipoCliente"].toString();
    var codClie = int.parse(map["CodClie"].toString());
    var razonSocial = map["RazonSocial"].toString();
    return CommonDownloadLocallyModel._internal(
      modulo: modulo,
      claseCpbte: claseCpbte,
      codEmp: codEmp,
      nroCpbte: nroCpbte,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocial: razonSocial,
    );
  }

  static String sDefaultTable() {
    throw UnimplementedError();
  }

  @override
  String iDefaultTable() {
    throw UnimplementedError();
  }

  @override
  CommonFieldNames getView({required String pViewName}) {
    throw UnimplementedError();
  }
}
