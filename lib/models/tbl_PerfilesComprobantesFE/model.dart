import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';

class TablePerfilComprobanteFEModel
    implements
        CommonModel<TablePerfilComprobanteFEModel>,
        CommonParamKeyValueCapable {
  static const String className = "TablePerfilComprobanteFEModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_PerfilComprobantesFE";
  bool forceEdit = false;
  bool canEdit = false;
  bool isCombinationControlShiftF9Pressed = false;

  @override
  String iDefaultTable() {
    return _defaultTable;
  }

  static String sDefaultTable() {
    return _defaultTable;
  }

  @override
  Map<String, dynamic> getKeyEntity() {
    return {
      'CodEmp': codEmp,
      'Codigo': codigo,
      'LockHash': lockHash,
      'Environment': environment,
    };
  }

  @override
  CommonFieldNames getView({required String pViewName}) {
    switch (pViewName) {
      case "default":
        return _defaultView();
      default:
        return _defaultView();
    }
  }

  CommonFieldNames _defaultView() {
    CommonFieldNames fieldNames = CommonFieldNames();
    fieldNames.add(
      kValue: "Codigo",
      vValue: "Código",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Descripcion",
      vValue: "Descripción",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodEmp",
      vValue: "Cód. Emp.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "RazonSocialCodEmp",
      vValue: "Razón Social",
      vFunction: null,
    );
    return fieldNames;
  }

  int codEmp;
  String razonSocialCodEmp;
  int codigo;
  String descripcion;
  int duracion;
  String subtotalSinImpuestos;
  String subtotalIVA;
  String subtotalConImpuestos;
  String subtotalBonificacionSinImpuestos;
  String subtotalBonificacionIVA;
  String subtotalBonificacionConImpuestos;
  String lockHash; // This is the hash of the record
  String environment;
  String fromType;

  TableEmpresaModel eEmpresa;

  TablePerfilComprobanteFEModel._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.codigo,
    required this.descripcion,
    required this.duracion,
    required this.subtotalSinImpuestos,
    required this.subtotalIVA,
    required this.subtotalConImpuestos,
    required this.subtotalBonificacionSinImpuestos,
    required this.subtotalBonificacionIVA,
    required this.subtotalBonificacionConImpuestos,
    required this.lockHash,
    required this.environment,
    required this.fromType,
    required this.eEmpresa,
  });

  /// If we create an object from default
  ///
  factory TablePerfilComprobanteFEModel.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = -2;
    String descripcion = "SELECCIONE UN PERFIL";
    int duracion = 0;
    String subtotalSinImpuestos = "0";
    String subtotalIVA = "0";
    String subtotalConImpuestos = "0";
    String subtotalBonificacionSinImpuestos = "0";
    String subtotalBonificacionIVA = "0";
    String subtotalBonificacionConImpuestos = "0";
    String lockHash = "0"; // This is the hash of the record
    String environment = "default";
    String fromType = 'fromDefault';
    return TablePerfilComprobanteFEModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      duracion: duracion,
      subtotalSinImpuestos: subtotalSinImpuestos,
      subtotalIVA: subtotalIVA,
      subtotalConImpuestos: subtotalConImpuestos,
      subtotalBonificacionSinImpuestos: subtotalBonificacionSinImpuestos,
      subtotalBonificacionIVA: subtotalBonificacionIVA,
      subtotalBonificacionConImpuestos: subtotalBonificacionConImpuestos,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we create an object from default
  ///
  factory TablePerfilComprobanteFEModel.fromKey({
    required TableEmpresaModel pEmpresa,
    required int pCodigo,
    required String pDescripcion,
    required String pEnvironment,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = pCodigo;
    String descripcion = pDescripcion;
    int duracion = 0;
    String subtotalSinImpuestos = "0";
    String subtotalIVA = "0";
    String subtotalConImpuestos = "0";
    String subtotalBonificacionSinImpuestos = "0";
    String subtotalBonificacionIVA = "0";
    String subtotalBonificacionConImpuestos = "0";
    String lockHash = "0"; // This is the hash of the record
    String environment = "default";
    String fromType = 'fromKey';
    return TablePerfilComprobanteFEModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      duracion: duracion,
      subtotalSinImpuestos: subtotalSinImpuestos,
      subtotalIVA: subtotalIVA,
      subtotalConImpuestos: subtotalConImpuestos,
      subtotalBonificacionSinImpuestos: subtotalBonificacionSinImpuestos,
      subtotalBonificacionIVA: subtotalBonificacionIVA,
      subtotalBonificacionConImpuestos: subtotalBonificacionConImpuestos,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we didn't find any records when filtering
  ///
  factory TablePerfilComprobanteFEModel.noRecordsFound({
    required TableEmpresaModel pEmpresa,
    String filter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = -1;
    String descripcion = "NO HAY REGISTROS s/filtro [$filter]";
    int duracion = 0;
    String subtotalSinImpuestos = "0";
    String subtotalIVA = "0";
    String subtotalConImpuestos = "0";
    String subtotalBonificacionSinImpuestos = "0";
    String subtotalBonificacionIVA = "0";
    String subtotalBonificacionConImpuestos = "0";
    String lockHash = "0"; // This is the hash of the record
    String environment = "default";
    String fromType = 'fromNoRecordFound';
    return TablePerfilComprobanteFEModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      duracion: duracion,
      subtotalSinImpuestos: subtotalSinImpuestos,
      subtotalIVA: subtotalIVA,
      subtotalConImpuestos: subtotalConImpuestos,
      subtotalBonificacionSinImpuestos: subtotalBonificacionSinImpuestos,
      subtotalBonificacionIVA: subtotalBonificacionIVA,
      subtotalBonificacionConImpuestos: subtotalBonificacionConImpuestos,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we create an object from any error
  ///
  factory TablePerfilComprobanteFEModel.fromError({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = -3;
    String descripcion = "NO HAY REGISTROS p/error [$pFilter]";
    int duracion = 0;
    String subtotalSinImpuestos = "0";
    String subtotalIVA = "0";
    String subtotalConImpuestos = "0";
    String subtotalBonificacionSinImpuestos = "0";
    String subtotalBonificacionIVA = "0";
    String subtotalBonificacionConImpuestos = "0";
    String lockHash = "0"; // This is the hash of the record
    String environment = "default";
    String fromType = 'fromError';
    return TablePerfilComprobanteFEModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      duracion: duracion,
      subtotalSinImpuestos: subtotalSinImpuestos,
      subtotalIVA: subtotalIVA,
      subtotalConImpuestos: subtotalConImpuestos,
      subtotalBonificacionSinImpuestos: subtotalBonificacionSinImpuestos,
      subtotalBonificacionIVA: subtotalBonificacionIVA,
      subtotalBonificacionConImpuestos: subtotalBonificacionConImpuestos,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TablePerfilComprobanteFEModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    return TablePerfilComprobanteFEModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
    );
  }

  /// This is the default factory creating object
  ///
  factory TablePerfilComprobanteFEModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
  }) {
    const String className = "TablePerfilComprobanteFEModel";
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';

    try {
      int codEmp = -1;
      if (int.tryParse(map["CodEmp"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodEmp',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codEmp = int.parse(map['CodEmp'].toString());
      String razonSocialCodEmp = map['RazonSocialCodEmp'].toString();
      int codigo = -1;
      if (int.tryParse(map["Codigo"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'Codigo',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codigo = int.parse(map['Codigo'].toString());
      String descripcion = map['Descripcion'].toString();
      int duracion = -1;
      if (int.tryParse(map["Duracion"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'Duracion',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      duracion = int.parse(map['Duracion'].toString());
      String subtotalSinImpuestos = map['SubtotalSinImpuestos'].toString();
      String subtotalIVA = map['SubtotalIVA'].toString();
      String subtotalConImpuestos = map['SubtotalConImpuestos'].toString();
      String subtotalBonificacionSinImpuestos =
          map['SubtotalBonificacionSinImpuestos'].toString();
      String subtotalBonificacionIVA =
          map['SubtotalBonificacionIVA'].toString();
      String subtotalBonificacionConImpuestos =
          map['SubtotalBonificacionConImpuestos'].toString();

      String lockHash = map['LockHash'].toString();
      String environment = map['Environment'].toString();

      String fromType = 'fromJson';
      TableEmpresaModel eEmpresa = pEmpresa;
      if (eEmpresa.codEmp != codEmp) {
        eEmpresa = TableEmpresaModel.fromKey(
          pCodEmp: codEmp,
          pRazonSocial: razonSocialCodEmp,
          pEnvironment: environment,
        );
      }
      return TablePerfilComprobanteFEModel._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        codigo: codigo,
        descripcion: descripcion,
        duracion: duracion,
        subtotalSinImpuestos: subtotalSinImpuestos,
        subtotalIVA: subtotalIVA,
        subtotalConImpuestos: subtotalConImpuestos,
        subtotalBonificacionSinImpuestos: subtotalBonificacionSinImpuestos,
        subtotalBonificacionIVA: subtotalBonificacionIVA,
        subtotalBonificacionConImpuestos: subtotalBonificacionConImpuestos,
        lockHash: lockHash,
        environment: environment,
        fromType: fromType,
        eEmpresa: eEmpresa,
      );
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 879797,
          errorDsc: e.toString(),
          stacktrace: stacktrace,
        );
      }
    }
  }

  /// El método replace permite actualizar el registro actual (en la misma referencia)
  ///
  void changeRecord(TablePerfilComprobanteFEModel pData) {
    codEmp = pData.codEmp;
    razonSocialCodEmp = pData.razonSocialCodEmp;
    codigo = pData.codigo;
    descripcion = pData.descripcion;
    duracion = pData.duracion;
    subtotalSinImpuestos = pData.subtotalSinImpuestos;
    subtotalIVA = pData.subtotalIVA;
    subtotalConImpuestos = pData.subtotalConImpuestos;
    subtotalBonificacionSinImpuestos = pData.subtotalBonificacionSinImpuestos;
    subtotalBonificacionIVA = pData.subtotalBonificacionIVA;
    subtotalBonificacionConImpuestos = pData.subtotalBonificacionConImpuestos;
    environment = pData.environment;
    fromType = pData.fromType;
    eEmpresa = pData.eEmpresa;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'CodEmp': codEmp,
      "RazonSocialCodEmp": razonSocialCodEmp,
      'Codigo': codigo,
      'Descripcion': descripcion,
      'Duracion': duracion,
      'SubtotalSinImpuestos': subtotalSinImpuestos,
      'SubtotalIVA': subtotalIVA,
      'SubtotalConImpuestos': subtotalConImpuestos,
      'SubtotalBonificacionSinImpuestos': subtotalBonificacionSinImpuestos,
      'SubtotalBonificacionIVA': subtotalBonificacionIVA,
      'SubtotalBonificacionConImpuestos': subtotalBonificacionConImpuestos,
      'LockHash': lockHash,
      'Environment': environment,
      'FromType': fromType,
      "EEmpresa": eEmpresa,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'codEmp': codEmp,
      "razonSocialCodEmp": razonSocialCodEmp,
      'codigo': codigo,
      'descripcion': descripcion,
      'duracion': duracion,
      'subtotalSinImpuestos': subtotalSinImpuestos,
      'subtotalIVA': subtotalIVA,
      'subtotalConImpuestos': subtotalConImpuestos,
      'subtotalBonificacionSinImpuestos': subtotalBonificacionSinImpuestos,
      'subtotalBonificacionIVA': subtotalBonificacionIVA,
      'subtotalBonificacionConImpuestos': subtotalBonificacionConImpuestos,
      'lockHash': lockHash,
      'environment': environment,
      'fromType': fromType,
      "eEmpresa": eEmpresa,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TablePerfilComprobanteFEModel) return false;

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
  String get dropDownItemAsString =>
      '${codigo.toString().padLeft(4, '0')} - $descripcion';

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownKey => codigo.toString();

  @override
  String get dropDownSubTitle => descripcion.toString();

  @override
  String get dropDownTitle => descripcion.toString();

  @override
  String get dropDownValue => descripcion.toString();

  @override
  CommonParamKeyValueCapable fromDefault() {
    return fromDefault();
  }

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => "";

  @override
  Future<List<CommonParamKeyValue<TablePerfilComprobanteFEModel>>>
      filterSearchFromDropDown({required String searchText}) async {
    ///
    /// This function is a wrapper to permit search on a DropDownList
    ///
    // Future<List<CommonParamKeyValue<T>>> _filterSearchDropDown({
    //   required String searchText,
    //   required String table,
    // })async {
    //   List<CommonParamKeyValue<TablePerfilComprobanteFEModel>> r

    // }
    List<CommonParamKeyValue<TablePerfilComprobanteFEModel>> rSearch = [];
    return rSearch;
  }
}
