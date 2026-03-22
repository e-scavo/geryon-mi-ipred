import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Ciudades/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Paises/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Provincias/model.dart';

class TableDetBarrioCiudadModel
    implements
        CommonModel<TableDetBarrioCiudadModel>,
        CommonParamKeyValueCapable {
  static const String className = "TableDetBarrioCiudadModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_DetBarriosCiudad";
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
      'CodCdad': codCdad,
      'CodigoBarrio': codigoBarrio,
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
  String descripcionCodPcia;
  int codCdad;
  String descripcionCodCdad;
  int codigoBarrio;
  String descripcion;
  String lockHash;
  String environment;
  String fromType;

  TableEmpresaModel eEmpresa;
  TablePaisModel ePais;
  TableProvinciaModel eProvincia;
  TableCiudadModel eCiudad;

  TableDetBarrioCiudadModel._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.codPais,
    required this.descripcionCodPais,
    required this.codPcia,
    required this.descripcionCodPcia,
    required this.codCdad,
    required this.descripcionCodCdad,
    required this.codigoBarrio,
    required this.descripcion,
    required this.lockHash,
    required this.environment,
    required this.fromType,
    required this.eEmpresa,
    required this.ePais,
    required this.eProvincia,
    required this.eCiudad,
  });

  /// If we create an object from default
  ///
  factory TableDetBarrioCiudadModel.fromDefault({
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
    required TableProvinciaModel pProvincia,
    required TableCiudadModel pCiudad,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pPais.codPais;
    String descripcionCodPais = pPais.descripcion;
    int codPcia = pProvincia.codPcia;
    String descripcionCodPcia = pProvincia.descripcion;
    int codCdad = pCiudad.codCdad;
    String descripcionCodCdad = pCiudad.descripcion;
    int codigoBarrio = -2;
    String descripcion = "SELECCIONE UN BARRIO";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromDefault';
    return TableDetBarrioCiudadModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codigoBarrio: codigoBarrio,
      descripcion: descripcion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePais: pPais,
      eProvincia: pProvincia,
      eCiudad: pCiudad,
    );
  }

  /// If we create an object from default
  ///
  factory TableDetBarrioCiudadModel.fromKey({
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
    required TableProvinciaModel pProvincia,
    required TableCiudadModel pCiudad,
    required int pCodigoBarrio,
    required String pDescripcion,
    required String pEnvironment,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pPais.codPais;
    String descripcionCodPais = pPais.descripcion;
    int codPcia = pProvincia.codPcia;
    String descripcionCodPcia = pProvincia.descripcion;
    int codCdad = pCiudad.codCdad;
    String descripcionCodCdad = pCiudad.descripcion;
    int codigoBarrio = pCodigoBarrio;
    String descripcion = pDescripcion;
    String lockHash = "";
    String environment = pEnvironment;
    String fromType = 'fromKey';
    return TableDetBarrioCiudadModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codigoBarrio: codigoBarrio,
      descripcion: descripcion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePais: pPais,
      eProvincia: pProvincia,
      eCiudad: pCiudad,
    );
  }

  /// If we didn't find any records when filtering
  ///
  factory TableDetBarrioCiudadModel.noRecordsFound({
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
    required TableProvinciaModel pProvincia,
    required TableCiudadModel pCiudad,
    String filter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pPais.codPais;
    String descripcionCodPais = pPais.descripcion;
    int codPcia = pProvincia.codPcia;
    String descripcionCodPcia = pProvincia.descripcion;
    int codCdad = pCiudad.codCdad;
    String descripcionCodCdad = pCiudad.descripcion;
    int codigoBarrio = -1;
    String descripcion = "NO HAY REGISTROS s/filtro [$filter]";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromNoRecordsFound';
    return TableDetBarrioCiudadModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codigoBarrio: codigoBarrio,
      descripcion: descripcion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePais: pPais,
      eProvincia: pProvincia,
      eCiudad: pCiudad,
    );
  }

  /// If we create an object from any error
  ///
  factory TableDetBarrioCiudadModel.fromError({
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
    required TableProvinciaModel pProvincia,
    required TableCiudadModel pCiudad,
    String pFilter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pPais.codPais;
    String descripcionCodPais = pPais.descripcion;
    int codPcia = pProvincia.codPcia;
    String descripcionCodPCia = pProvincia.descripcion;
    int codCdad = pCiudad.codCdad;
    String descripcionCodCdad = pCiudad.descripcion;
    int codigoBarrio = -3;
    String descripcion = "NO HAY REGISTROS p/error [$pFilter]";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromError';
    return TableDetBarrioCiudadModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPCia,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codigoBarrio: codigoBarrio,
      descripcion: descripcion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePais: pPais,
      eProvincia: pProvincia,
      eCiudad: pCiudad,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableDetBarrioCiudadModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    TablePaisModel? pPais,
    TableProvinciaModel? pProvincia,
    TableCiudadModel? pCiudad,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    pPais ??= TablePaisModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    pProvincia ??= TableProvinciaModel.fromDefault(
      pEmpresa: pEmpresa,
      pPais: pPais,
    );
    pCiudad ??= TableCiudadModel.fromDefault(
      pEmpresa: pEmpresa,
      pPais: pPais,
      pProvincia: pProvincia,
    );
    return TableDetBarrioCiudadModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
      pPais: pPais,
      pProvincia: pProvincia,
      pCiudad: pCiudad,
    );
  }

  /// This is the default factory creating object
  ///
  factory TableDetBarrioCiudadModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
    required TablePaisModel pPais,
    required TableProvinciaModel pProvincia,
    required TableCiudadModel pCiudad,
  }) {
    const String className = "TableDetBarrioCiudadModel";
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
      String descripcionCodPcia = map['DescripcionCodPcia'].toString();
      int codCdad = -1;
      if (int.tryParse(map["CodCdad"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodCdad',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codCdad = int.parse(map['CodCdad'].toString());
      String descripcionCodCdad = map['DescripcionCodCdad'].toString();

      int codigoBarrio = -1;
      if (int.tryParse(map["Codigo"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodigoBarrio2222',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codigoBarrio = int.parse(map['Codigo'].toString());
      String descripcion = map['Descripcion'].toString();
      String lockHash = map['LockHash'].toString();
      String environment = map['Environment'].toString();

      String fromType = 'fromJson';
      TableEmpresaModel eEmpresa = pEmpresa;

      TablePaisModel ePais = pPais;

      TableProvinciaModel eProvincia = pProvincia;
      TableCiudadModel eCiudad = pCiudad;
      return TableDetBarrioCiudadModel._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        codPais: codPais,
        descripcionCodPais: descripcionCodPais,
        codPcia: codPcia,
        descripcionCodPcia: descripcionCodPcia,
        codCdad: codCdad,
        descripcionCodCdad: descripcionCodCdad,
        codigoBarrio: codigoBarrio,
        descripcion: descripcion,
        lockHash: lockHash,
        environment: environment,
        fromType: fromType,
        eEmpresa: eEmpresa,
        ePais: ePais,
        eProvincia: eProvincia,
        eCiudad: eCiudad,
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
      'DescripcionCodPcia': descripcionCodPcia,
      'CodCdad': codCdad,
      'DescripcionCodCdad': descripcionCodCdad,
      'Codigo': codigoBarrio,
      'CodigoBarrio': codigoBarrio,
      'Descripcion': descripcion,
      'LockHash': lockHash,
      'Environment': environment,
      'FromType': fromType,
      "EEmpresa": eEmpresa,
      "EPais": ePais,
      "EProvincia": eProvincia,
      "ECiudad": eCiudad,
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
      'descripcionCodPcia': descripcionCodPcia,
      'codCdad': codCdad,
      'descripcionCodCdad': descripcionCodCdad,
      'codigo': codigoBarrio,
      'codigoBarrio': codigoBarrio,
      'descripcion': descripcion,
      'lockHash': lockHash,
      'environment': environment,
      'fromType': fromType,
      "eEmpresa": eEmpresa,
      "ePais": ePais,
      "eProvincia": eProvincia,
      "eCiudad": eCiudad,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TableDetBarrioCiudadModel) return false;

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
  String get dropDownSubTitle =>
      'Código: ${codigoBarrio.toString().padLeft(3, '0')}';

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
  Future<List<CommonParamKeyValue<TableDetBarrioCiudadModel>>>
      filterSearchFromDropDown({required String searchText}) async {
    ///
    /// This function is a wrapper to permit search on a DropDownList
    ///
    // Future<List<CommonParamKeyValue<T>>> _filterSearchDropDown({
    //   required String searchText,
    //   required String table,
    // })async {
    //   List<CommonParamKeyValue<TableDetBarrioCiudadModel>> r

    // }
    List<CommonParamKeyValue<TableDetBarrioCiudadModel>> rSearch = [];
    return rSearch;
  }
}
