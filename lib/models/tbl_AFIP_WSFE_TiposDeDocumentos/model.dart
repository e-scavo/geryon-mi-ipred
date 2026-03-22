import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';

class TableAFIPWSFETiposDeDocumentos
    implements
        CommonModel<TableAFIPWSFETiposDeDocumentos>,
        CommonParamKeyValueCapable {
  static String className = 'TableAFIPWSFETiposDeDocumentos';
  //static String defaultTable = 'tbl_AFIP_WSFE_TiposDeDocumentos';
  // @override
  // String defaultTable() => "tbl_AFIP_WSFE_TiposDeDocumentos";
  static final String _defaultTable = "tbl_AFIP_WSFE_TiposDeDocumentos";

  @override
  String iDefaultTable() {
    return _defaultTable;
  }

  static String sDefaultTable() {
    return _defaultTable;
  }

  int id;
  String descripcion;
  CommonDateModel fchDesde;
  CommonDateModel fchHasta;
  int codEmp;
  String razonSocialCodEmp;
  String environment;
  TableEmpresaModel eEmpresa;

  TableAFIPWSFETiposDeDocumentos._internal({
    required this.id,
    required this.descripcion,
    required this.fchDesde,
    required this.fchHasta,
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.environment,
    required this.eEmpresa,
  });

  factory TableAFIPWSFETiposDeDocumentos.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    var id = -1;
    var descripcion = '';
    var fchDesde = CommonDateModel.fromDefault();
    var fchHasta = CommonDateModel.fromDefault();
    var codEmp = pEmpresa.codEmp;
    var razonSocialCodEmp = pEmpresa.razonSocial;
    var environment = 'default';
    var eEmpresa = pEmpresa;
    return TableAFIPWSFETiposDeDocumentos._internal(
      id: id,
      descripcion: descripcion,
      fchDesde: fchDesde,
      fchHasta: fchHasta,
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      environment: environment,
      eEmpresa: eEmpresa,
    );
  }

  factory TableAFIPWSFETiposDeDocumentos.fromKey({
    required int pID,
    required String pDescripcion,
    required TableEmpresaModel pEmpresa,
  }) {
    var rObject = TableAFIPWSFETiposDeDocumentos.fromDefault(
      pEmpresa: pEmpresa,
    );
    rObject.codEmp = pEmpresa.codEmp;
    rObject.razonSocialCodEmp = pEmpresa.razonSocial;
    rObject.id = pID;
    rObject.descripcion = pDescripcion;
    rObject.environment = pEmpresa.environment;
    return rObject;
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableAFIPWSFETiposDeDocumentos fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
  }) {
    return TableAFIPWSFETiposDeDocumentos.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: TableEmpresaModel.fromDefault(),
    );
  }

  factory TableAFIPWSFETiposDeDocumentos.fromError({
    required TableEmpresaModel pEmpresa,
    required String pFilter,
  }) {
    var rObject = TableAFIPWSFETiposDeDocumentos.fromDefault(
      pEmpresa: pEmpresa,
    );
    rObject.id = -2;
    rObject.descripcion = "Error recibido";
    rObject.codEmp = -2;
    rObject.descripcion = "";
    return rObject;
  }

  /// toJson
  ///
  @override
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Descripcion': descripcion,
      'FchDesde': fchDesde,
      'FchHasta': fchHasta,
      'CodEmp': codEmp,
      'RazonSocialCodEmp': razonSocialCodEmp,
      'Environment': environment,
      'EEmpresa': eEmpresa,
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

  factory TableAFIPWSFETiposDeDocumentos.fromJsonGral({
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
      int id = -1;
      if (int.tryParse(map['ID'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'ID',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      id = int.parse(map['ID'].toString());
      var descripcion = map["Descripcion"].toString();
      var fchDesde = CommonDateModel.parse(
        map['FchDesde'],
        fieldName: 'FchDesde',
      );
      var fchHasta = CommonDateModel.parse(
        map['FchHasta'],
        fieldName: 'FchHasta',
      );

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
      return TableAFIPWSFETiposDeDocumentos._internal(
        id: id,
        descripcion: descripcion,
        fchDesde: fchDesde,
        fchHasta: fchHasta,
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        environment: environment,
        eEmpresa: eEmpresa,
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

    if (other is! TableAFIPWSFETiposDeDocumentos) return false;

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
      'ID': id,
      'CodEmp': codEmp,
      'Environment': environment,
    };
  }

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownItemAsString =>
      '${id.toString().padLeft(2, '0')} - $descripcion';

  @override
  String get dropDownKey => id.toString();

  @override
  String get dropDownSubTitle =>
      '${id.toString().padLeft(2, '0')} - $descripcion';

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
