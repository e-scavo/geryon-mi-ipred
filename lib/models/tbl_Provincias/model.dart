import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Paises/model.dart';

class TableProvinciaModel
    implements CommonModel<TableProvinciaModel>, CommonParamKeyValueCapable {
  static const String className = "TableProvinciaModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_Provincias";
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
      'CodPais': codPais,
      'CodPcia': codPcia,
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
  int codPais;
  String descripcionCodPais;
  int codPcia;
  String descripcion;
  String lockHash;
  String environment;
  String fromType;

  TableEmpresaModel eEmpresa;
  TablePaisModel ePais;

  TableProvinciaModel._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.codPais,
    required this.descripcionCodPais,
    required this.codPcia,
    required this.descripcion,
    required this.lockHash,
    required this.environment,
    required this.fromType,
    required this.eEmpresa,
    required this.ePais,
  });

  /// If we create an object from default
  ///
  factory TableProvinciaModel.fromDefault({
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pPais.codPais;
    String descripcionCodPais = pPais.descripcion;
    int codPcia = -2;
    String descripcion = "SELECCIONE UNA PROVINCIA";
    String lockHash = ""; // CommonUtils.generateRandomUniqueHash();
    String environment = "default";
    String fromType = 'Default';
    return TableProvinciaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcion: descripcion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePais: pPais,
    );
  }

  /// If we create an object from default
  ///
  factory TableProvinciaModel.fromKey({
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
    required int pCodPcia,
    required String pDescripcion,
    required String pEnvironment,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pPais.codPais;
    String descripcionCodPais = pPais.descripcion;
    int codPcia = pCodPcia;
    String descripcion = pDescripcion;
    String lockHash = ""; // CommonUtils.generateRandomUniqueHash();
    String environment = pEnvironment;
    String fromType = 'Key';
    return TableProvinciaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcion: descripcion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePais: pPais,
    );
  }

  /// If we didn't find any records when filtering
  ///
  factory TableProvinciaModel.noRecordsFound({
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
    String filter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pPais.codPais;
    String descripcionCodPais = pPais.descripcion;
    int codPcia = -1;
    String descripcion = "NO HAY REGISTROS s/filtro [$filter]";
    String lockHash = ""; // CommonUtils.generateRandomUniqueHash();
    String environment = "default";
    String fromType = 'NoRecordsFound';
    return TableProvinciaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcion: descripcion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePais: pPais,
    );
  }

  /// If we create an object from any error
  ///
  factory TableProvinciaModel.fromError({
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
    String pFilter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pPais.codPais;
    String descripcionCodPais = pPais.descripcion;
    int codPcia = -3;
    String descripcion = "NO HAY REGISTROS p/error [$pFilter]";
    String lockHash = ""; // CommonUtils.generateRandomUniqueHash();
    String environment = "default";
    String fromType = 'Error';
    return TableProvinciaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcion: descripcion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePais: pPais,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableProvinciaModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    TablePaisModel? pPais,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    pPais ??= TablePaisModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    return TableProvinciaModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
      pPais: pPais,
    );
  }

  /// This is the default factory creating object
  ///
  factory TableProvinciaModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
  }) {
    const String className = "TableProvinciaModel";
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
      int codPais = -1;
      if (int.tryParse(map["CodPais"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodPais',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codPais = int.parse(map['CodPais'].toString());
      String descripcionCodPais = map['DescripcionCodPais'].toString();
      int codPcia = -1;
      if (int.tryParse(map["CodPcia"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodPcia',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codPcia = int.parse(map['CodPcia'].toString());
      String descripcion = map['Descripcion'].toString();
      String lockHash = map['LockHash'].toString();
      String environment = map['Environment'].toString();

      String fromType = 'Json';
      TableEmpresaModel eEmpresa = pEmpresa;
      if (pEmpresa.codEmp != codEmp) {
        eEmpresa = TableEmpresaModel.fromKey(
          pCodEmp: codEmp,
          pRazonSocial: razonSocialCodEmp,
          pEnvironment: environment,
        );
      }
      TablePaisModel ePais = pPais;
      if (pPais.codPais != codPais) {
        ePais = TablePaisModel.fromKey(
          pEmpresa: eEmpresa,
          pCodPais: codPais,
          pDescripcion: descripcionCodPais,
          pEnvironment: environment,
        );
      }

      return TableProvinciaModel._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        codPais: codPais,
        descripcionCodPais: descripcionCodPais,
        descripcion: descripcion,
        codPcia: codPcia,
        lockHash: lockHash,
        environment: environment,
        fromType: fromType,
        eEmpresa: eEmpresa,
        ePais: ePais,
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'CodEmp': codEmp,
      "RazonSocialCodEmp": razonSocialCodEmp,
      'CodPais': codPais,
      'DescripcionCodPais': descripcionCodPais,
      'CodPcia': codPcia,
      'Descripcion': descripcion,
      'LockHash': lockHash,
      'Environment': environment,
      'FromType': fromType,
      "EEmpresa": eEmpresa,
      "EPais": ePais,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'codEmp': codEmp,
      "razonSocialCodEmp": razonSocialCodEmp,
      'codPais': codPais,
      'descripcionCodPais': descripcionCodPais,
      'codPcia': codPcia,
      'descripcion': descripcion,
      'lockHash': lockHash,
      'environment': environment,
      'fromType': fromType,
      "eEmpresa": eEmpresa,
      "ePais": ePais,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TableProvinciaModel) return false;

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
      '${codPais.toString().padLeft(4, '0')} - $descripcion';

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownKey => codPcia.toString();

  @override
  String get dropDownSubTitle => descripcion.toString();

  @override
  String get dropDownTitle => 'Código: ${codPcia.toString().padLeft(3, '0')}';

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
  Future<List<CommonParamKeyValue<TableProvinciaModel>>>
      filterSearchFromDropDown({required String searchText}) async {
    ///
    /// This function is a wrapper to permit search on a DropDownList
    ///
// Future<List<CommonParamKeyValue<T>>> _filterSearchDropDown({
//   required String searchText,
//   required String table,
// })async {
//   List<CommonParamKeyValue<TableProvinciaModel>> r

// }
    List<CommonParamKeyValue<TableProvinciaModel>> rSearch = [];
    return rSearch;
  }
}
