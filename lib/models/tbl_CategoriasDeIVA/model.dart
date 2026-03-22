import 'dart:developer';

import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_AFIP_WSFE_TiposDeDocumentos/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';

class TableCategoriaDeIVAModel
    implements
        CommonModel<TableCategoriaDeIVAModel>,
        CommonParamKeyValueCapable {
  static String className = 'TableCategoriaDeIVAModel';
  //static String defaultTable = "tbl_CategoriasDeIVA";

  //@override
  //String defaultTable() => "tbl_CategoriasDeIVA";
  static final String _defaultTable = "tbl_CategoriasDeIVA";

  @override
  String iDefaultTable() {
    return _defaultTable;
  }

  static String sDefaultTable() {
    return _defaultTable;
  }

  String codCatIVA;
  String descripcion;
  int codigoIDTipoDocFE;
  String descripcionCodigoIDTipoDocFE;
  int codEmp;
  String razonSocialCodEmp;
  String environment;
  TableEmpresaModel eEmpresa;
  TableAFIPWSFETiposDeDocumentos eAFIPWSFETipoDeDocuemnto;

  TableCategoriaDeIVAModel._internal({
    required this.codCatIVA,
    required this.descripcion,
    required this.codigoIDTipoDocFE,
    required this.descripcionCodigoIDTipoDocFE,
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.environment,
    required this.eEmpresa,
    required this.eAFIPWSFETipoDeDocuemnto,
  });

  factory TableCategoriaDeIVAModel.fromError({
    required TableEmpresaModel pEmpresa,
    required String pFilter,
  }) {
    var rObject = TableCategoriaDeIVAModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    rObject.codCatIVA = "";
    rObject.descripcion = "Error recibido";
    rObject.codigoIDTipoDocFE = -2;
    rObject.descripcionCodigoIDTipoDocFE = "";
    return rObject;
  }

  factory TableCategoriaDeIVAModel.fromKey({
    required String pCodCatIVA,
    required String pDescripcion,
    required TableEmpresaModel pEmpresa,
  }) {
    var rObject = TableCategoriaDeIVAModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    rObject.codCatIVA = pCodCatIVA;
    rObject.descripcion = pDescripcion;
    return rObject;
  }

  factory TableCategoriaDeIVAModel.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    var codCatIVA = '';
    var descripcion = '';
    var codigoIDTipoDocFE = -1;
    var descripcionCodigoIDTipoDocFE = "";
    var codEmp = -1;
    var razonSocialCodEmp = '';
    var environment = 'default';
    var eEmpresa = TableEmpresaModel.fromKey(
      pCodEmp: codEmp,
      pRazonSocial: razonSocialCodEmp,
      pEnvironment: environment,
    );
    if (pEmpresa.environment != "default") {
      eEmpresa = pEmpresa;
    }
    var eAFIPWSFETipoDeDocuemnto = TableAFIPWSFETiposDeDocumentos.fromKey(
      pID: codigoIDTipoDocFE,
      pDescripcion: descripcionCodigoIDTipoDocFE,
      pEmpresa: eEmpresa,
    );
    return TableCategoriaDeIVAModel._internal(
      codCatIVA: codCatIVA,
      descripcion: descripcion,
      codigoIDTipoDocFE: codigoIDTipoDocFE,
      descripcionCodigoIDTipoDocFE: descripcionCodigoIDTipoDocFE,
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      environment: environment,
      eEmpresa: eEmpresa,
      eAFIPWSFETipoDeDocuemnto: eAFIPWSFETipoDeDocuemnto,
    );
  }

  /// toJson
  ///
  @override
  Map<String, dynamic> toJson() {
    return {
      'CodCatIVA': codCatIVA,
      'Descripcion': codigoIDTipoDocFE,
      'CodigoIDTipoDocFE': codigoIDTipoDocFE,
      'DescripcionCodigoIDTipoDocFE': descripcionCodigoIDTipoDocFE,
      'CodEmp': codEmp,
      'RazonSocialCodEmp': razonSocialCodEmp,
      'Environment': environment,
      'EEmpresa': eEmpresa,
      'EAFIPWSFETipoDeDocuemnto': eAFIPWSFETipoDeDocuemnto,
    };
  }

  @override
  String toString() {
    return toJson.toString();
  }

  @override
  Map<String, dynamic> toMap() {
    return toJson();
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableCategoriaDeIVAModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
  }) {
    log('bbbbbb $map');
    return TableCategoriaDeIVAModel.fromJson2(
      map: map,
      errorCode: errorCode,
      pEmpresa: TableEmpresaModel.fromDefault(),
    );
  }

  factory TableCategoriaDeIVAModel.fromJson3({
    required Map<String, dynamic> map,
    int errorCode = 0,
  }) {
    return TableCategoriaDeIVAModel.fromJson2(
      map: map,
      errorCode: errorCode,
      pEmpresa: TableEmpresaModel.fromDefault(),
    );
  }

  factory TableCategoriaDeIVAModel.fromJson2({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
    int pVersion = 2,
  }) {
    String functionName = "fromJson";
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';

    try {
      int codEmp = -1;
      if (int.tryParse(map['CodEmp'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodEmp',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      codEmp = int.parse(map['CodEmp'].toString());
      var razonSocialCodEmp = map['RazonSocialCodEmp'].toString();
      var codCatIVA = map["CodCatIVA"].toString();
      var descripcion = map["Descripcion"].toString();
      int codigoIDTipoDocFE = -1;
      if (int.tryParse(map['CodigoIDTipoDocFE'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodigoIDTipoDocFE',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      codigoIDTipoDocFE = int.parse(map['CodigoIDTipoDocFE'].toString());
      var descripcionCodigoIDTipoDocFE =
          map["DescripcionCodigoIDTipoDocFE"].toString();

      var environment = map["Environment"].toString();

      if (pEmpresa.environment == 'default') {
        pEmpresa.codEmp = codEmp;
        pEmpresa.razonSocial = razonSocialCodEmp;
        pEmpresa.environment = environment;
      }
      var eEmpresa = pEmpresa;
      if (map['Empresa'] != null) {
        eEmpresa = TableEmpresaModel.fromJson(map['Empresa']);
      }
      var eAFIPWSFETipoDeDocuemnto = TableAFIPWSFETiposDeDocumentos.fromKey(
        pID: codigoIDTipoDocFE,
        pDescripcion: descripcionCodigoIDTipoDocFE,
        pEmpresa: eEmpresa,
      );
      if (map['AFIPWSFETipoDeDocuemnto'] != null) {
        eAFIPWSFETipoDeDocuemnto = TableAFIPWSFETiposDeDocumentos.fromJsonGral(
          map: map['AFIPWSFETipoDeDocuemnto'],
          pEmpresa: eEmpresa,
        );
      }
      return TableCategoriaDeIVAModel._internal(
        codCatIVA: codCatIVA,
        descripcion: descripcion,
        codigoIDTipoDocFE: codigoIDTipoDocFE,
        descripcionCodigoIDTipoDocFE: descripcionCodigoIDTipoDocFE,
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        environment: environment,
        eEmpresa: eEmpresa,
        eAFIPWSFETipoDeDocuemnto: eAFIPWSFETipoDeDocuemnto,
      );
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 888999,
          errorDsc: '<sub> ${e.toString()}',
          className: className,
          functionName: functionName,
          propertyName: '<desconocido>',
          propertyValue: '<desconocido>',
          stacktrace: stacktrace,
        );
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TableCategoriaDeIVAModel) return false;

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

  @override
  Map<String, dynamic> getKeyEntity() {
    return {
      'CodCatIVA': codCatIVA,
      'CodEmp': codEmp,
      'Environment': environment,
    };
  }

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownItemAsString => '$codCatIVA - $descripcion';

  @override
  String get dropDownKey => codCatIVA;

  @override
  String get dropDownSubTitle => '$codCatIVA - $descripcion';

  @override
  String get dropDownTitle => descripcion;

  @override
  String get dropDownValue => descripcion;

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({required String searchText}) {
    throw UnimplementedError();
  }

  @override
  CommonParamKeyValueCapable fromDefault() {
    throw UnimplementedError();
  }

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => '';

  @override
  CommonFieldNames getView({required String pViewName}) {
    throw UnimplementedError();
  }
}
