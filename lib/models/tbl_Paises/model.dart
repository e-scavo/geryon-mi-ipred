import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';

class TablePaisModel
    implements CommonModel<TablePaisModel>, CommonParamKeyValueCapable {
  static const String className = "TablePaisModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_Paises";
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
  String descripcion;
  String nameEN;
  String nameFR;
  String iso2;
  String iso3;
  String phoneCode;
  String flag;
  String lockHash; // default value for hash
  String environment;
  String fromType;

  TableEmpresaModel eEmpresa;

  TablePaisModel._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.codPais,
    required this.descripcion,
    required this.nameEN,
    required this.nameFR,
    required this.iso2,
    required this.iso3,
    required this.phoneCode,
    required this.flag,
    required this.lockHash,
    required this.environment,
    required this.fromType,
    required this.eEmpresa,
  });

  /// if we create an object from default
  ///
  factory TablePaisModel.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = -2;
    String descripcion = "SELECCIONE UN PAÍS";
    String nameEN = "SELECCIONE UN PAÍS";
    String nameFR = "SELECCIONE UN PAÍS";
    String iso2 = "";
    String iso3 = "";
    String phoneCode = "";
    String flag = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'Default';
    return TablePaisModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcion: descripcion,
      nameEN: nameEN,
      nameFR: nameFR,
      iso2: iso2,
      iso3: iso3,
      phoneCode: phoneCode,
      flag: flag,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// if we create an object from key (basic)
  ///
  factory TablePaisModel.fromKey({
    required TableEmpresaModel pEmpresa,
    required int pCodPais,
    required String pDescripcion,
    required String pEnvironment,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = pCodPais;
    String descripcion = pDescripcion;
    String nameEN = pDescripcion;
    String nameFR = pDescripcion;
    String iso2 = "";
    String iso3 = "";
    String phoneCode = "";
    String flag = "";
    String lockHash = "";
    String environment = pEnvironment;
    String fromType = 'Key';
    return TablePaisModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcion: descripcion,
      nameEN: nameEN,
      nameFR: nameFR,
      iso2: iso2,
      iso3: iso3,
      phoneCode: phoneCode,
      flag: flag,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we didn't find any records when filtering
  ///
  factory TablePaisModel.noRecordsFound({
    required TableEmpresaModel pEmpresa,
    String filter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = -1;
    String descripcion = "NO HAY REGISTROS s/filtro [$filter]";
    String nameEN = "NO HAY REGISTROS s/filtro [$filter]";
    String nameFR = "NO HAY REGISTROS s/filtro [$filter]";
    String iso2 = "";
    String iso3 = "";
    String phoneCode = "";
    String flag = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'NoRecordsFround';
    return TablePaisModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcion: descripcion,
      nameEN: nameEN,
      nameFR: nameFR,
      iso2: iso2,
      iso3: iso3,
      phoneCode: phoneCode,
      flag: flag,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we create an object from any error
  ///
  factory TablePaisModel.fromError({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codPais = -3;
    String descripcion = "NO HAY REGISTROS p/error [$pFilter]";
    String nameEN = "NO HAY REGISTROS p/error [$pFilter]";
    String nameFR = "NO HAY REGISTROS p/error [$pFilter]";
    String iso2 = "";
    String iso3 = "";
    String phoneCode = "";
    String flag = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'Error';
    return TablePaisModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codPais: codPais,
      descripcion: descripcion,
      nameEN: nameEN,
      nameFR: nameFR,
      iso2: iso2,
      iso3: iso3,
      phoneCode: phoneCode,
      flag: flag,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TablePaisModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    return TablePaisModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
    );
  }

  /// This is the default factory creating object
  ///
  factory TablePaisModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
  }) {
    const String className = "TablePaisModel";
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
      String descripcion = map['Descripcion'].toString();
      String nameEN = map['NameEN'].toString();
      String nameFR = map['NameFR'].toString();
      String iso2 = map['ISO2'].toString();
      String iso3 = map['ISO3'].toString();
      String phoneCode = map['PhoneCode'].toString();
      String flag = map['Flag'].toString();
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
      return TablePaisModel._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        codPais: codPais,
        descripcion: descripcion,
        nameEN: nameEN,
        nameFR: nameFR,
        iso2: iso2,
        iso3: iso3,
        phoneCode: phoneCode,
        flag: flag,
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'CodEmp': codEmp,
      'CodPais': codPais,
      'Descripcion': descripcion,
      'NameEN': nameEN,
      'NameFR': nameFR,
      'ISO2': iso2,
      'ISO3': iso3,
      'PhoneCode': phoneCode,
      'Flag': flag,
      'LockHash': lockHash,
      'Environment': environment,
      'FromType': fromType,
      'EEmpresa': eEmpresa,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'codEmp': codEmp,
      'codPais': codPais,
      'descripcion': descripcion,
      'nameEN': nameEN,
      'nameFR': nameFR,
      'iso2': iso2,
      'iso3': iso3,
      'phoneCode': phoneCode,
      'flag': flag,
      'lockHash': lockHash,
      'environment': environment,
      'fromType': fromType,
      'eEmpresa': eEmpresa,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TablePaisModel) return false;

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
  String get dropDownAvatar => flag;

  @override
  String get dropDownKey => codPais.toString();

  @override
  String get dropDownSubTitle =>
      'Código: ${codPais.toString().padLeft(3, '0')}';

  @override
  String get dropDownTitle => descripcion.toString();

  @override
  String get dropDownValue => nameEN.toString();

  @override
  CommonParamKeyValueCapable fromDefault() {
    return fromDefault();
  }

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => "";

  @override
  Future<List<CommonParamKeyValue<TablePaisModel>>> filterSearchFromDropDown(
      {required String searchText}) async {
    ///
    /// This function is a wrapper to permit search on a DropDownList
    ///
    // Future<List<CommonParamKeyValue<T>>> _filterSearchDropDown({
    //   required String searchText,
    //   required String table,
    // })async {
    //   List<CommonParamKeyValue<TablePaisModel>> r

    // }
    List<CommonParamKeyValue<TablePaisModel>> rSearch = [];
    return rSearch;
  }
}
