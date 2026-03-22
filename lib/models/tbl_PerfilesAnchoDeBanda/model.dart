import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';

class TablePerfilAnchoDeBandaModel
    implements
        CommonModel<TablePerfilAnchoDeBandaModel>,
        CommonParamKeyValueCapable {
  static const String className = "TablePerfilAnchoDeBandaModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_PerfilAnchoDeBanda";
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
  String validaModuloDATOS;
  String lockHash;
  String environment;
  String fromType;

  TableEmpresaModel eEmpresa;

  TablePerfilAnchoDeBandaModel._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.codigo,
    required this.descripcion,
    required this.validaModuloDATOS,
    required this.lockHash,
    required this.environment,
    required this.fromType,
    required this.eEmpresa,
  });

  /// If we create an object from default
  ///
  factory TablePerfilAnchoDeBandaModel.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = -2;
    String descripcion = "SELECCIONE UN PERFIL";
    String validaModuloDATOS = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromDefault';
    return TablePerfilAnchoDeBandaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      validaModuloDATOS: validaModuloDATOS,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we create an object from default
  ///
  factory TablePerfilAnchoDeBandaModel.fromKey({
    required TableEmpresaModel pEmpresa,
    required int pCodigo,
    required String pDescripcion,
    required String pEnvironment,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = pCodigo;
    String descripcion = pDescripcion;
    String validaModuloDATOS = "";
    String lockHash = "";
    String environment = pEnvironment;
    String fromType = 'fromKey';
    return TablePerfilAnchoDeBandaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      validaModuloDATOS: validaModuloDATOS,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we didn't find any records when filtering
  ///
  factory TablePerfilAnchoDeBandaModel.noRecordsFound({
    required TableEmpresaModel pEmpresa,
    String filter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = -1;
    String descripcion = "NO HAY REGISTROS s/filtro [$filter]";
    String validaModuloDATOS = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromNoRecordsFound';
    return TablePerfilAnchoDeBandaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      validaModuloDATOS: validaModuloDATOS,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we create an object from any error
  ///
  factory TablePerfilAnchoDeBandaModel.fromError({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = -3;
    String descripcion = "NO HAY REGISTROS p/error [$pFilter]";
    String validaModuloDATOS = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromError';
    return TablePerfilAnchoDeBandaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      validaModuloDATOS: validaModuloDATOS,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TablePerfilAnchoDeBandaModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    return TablePerfilAnchoDeBandaModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
    );
  }

  /// This is the default factory creating object
  ///
  factory TablePerfilAnchoDeBandaModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
  }) {
    const String className = "TablePerfilAnchoDeBandaModel";
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
      String validaModuloDATOS = map['ValidaModuloDATOS'].toString();

      String lockHash = map['LockHash'].toString();
      String environment = map['Environment'].toString();

      String fromType = 'fromJson';
      TableEmpresaModel eEmpresa = pEmpresa;
      if (pEmpresa.codEmp != codEmp) {
        eEmpresa = TableEmpresaModel.fromKey(
            pCodEmp: codEmp,
            pRazonSocial: razonSocialCodEmp,
            pEnvironment: environment);
      }
      return TablePerfilAnchoDeBandaModel._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        codigo: codigo,
        descripcion: descripcion,
        validaModuloDATOS: validaModuloDATOS,
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
  void changeRecord(TablePerfilAnchoDeBandaModel pData) {
    codEmp = pData.codEmp;
    razonSocialCodEmp = pData.razonSocialCodEmp;
    codigo = pData.codigo;
    descripcion = pData.descripcion;
    validaModuloDATOS = pData.validaModuloDATOS;
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
      'ValidaModuloDATOS': validaModuloDATOS,
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
      'validaModuloDATOS': validaModuloDATOS,
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

    if (other is! TablePerfilAnchoDeBandaModel) return false;

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
  Future<List<CommonParamKeyValue<TablePerfilAnchoDeBandaModel>>>
      filterSearchFromDropDown({required String searchText}) async {
    ///
    /// This function is a wrapper to permit search on a DropDownList
    ///
    // Future<List<CommonParamKeyValue<T>>> _filterSearchDropDown({
    //   required String searchText,
    //   required String table,
    // })async {
    //   List<CommonParamKeyValue<TablePerfilAnchoDeBandaModel>> r

    // }
    List<CommonParamKeyValue<TablePerfilAnchoDeBandaModel>> rSearch = [];
    return rSearch;
  }
}
