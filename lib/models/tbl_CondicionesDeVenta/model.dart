import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';

class TableCondicionDeVentaModel
    implements
        CommonModel<TableCondicionDeVentaModel>,
        CommonParamKeyValueCapable {
  static const String className = "TableCondicionDeVentaModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_CondicionesDeVenta";
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
      'CodCondVta': codCondVta,
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
  int codCondVta;
  String descripcion;
  String leyenda;
  String actualizaCuentaCorriente;
  String pedirEntrega;
  String aplicarVencimientosMultiples;
  String aplicarSobreCpbte;
  String discriminarIntereses;
  String discriminarBonificaciones;
  String editarVencimientos;
  String imprimeVencimientos;
  String imprimeCodCondVta;
  String notas;
  String lockHash; // Hash for record lock
  String environment;
  String fromType;

  TableEmpresaModel eEmpresa;

  TableCondicionDeVentaModel._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.codCondVta,
    required this.descripcion,
    required this.leyenda,
    required this.actualizaCuentaCorriente,
    required this.pedirEntrega,
    required this.aplicarVencimientosMultiples,
    required this.aplicarSobreCpbte,
    required this.discriminarIntereses,
    required this.discriminarBonificaciones,
    required this.editarVencimientos,
    required this.imprimeVencimientos,
    required this.imprimeCodCondVta,
    required this.notas,
    required this.lockHash,
    required this.environment,
    required this.fromType,
    required this.eEmpresa,
  });

  /// If we create an object from default
  ///
  factory TableCondicionDeVentaModel.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codCondVta = -2;
    String descripcion = "SELECCIONE";
    String leyenda = "";
    String actualizaCuentaCorriente = "";
    String pedirEntrega = "";
    String aplicarVencimientosMultiples = "";
    String aplicarSobreCpbte = "";
    String discriminarIntereses = "";
    String discriminarBonificaciones = "";
    String editarVencimientos = "";
    String imprimeVencimientos = "";
    String imprimeCodCondVta = "";
    String notas = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromDefault';
    return TableCondicionDeVentaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codCondVta: codCondVta,
      descripcion: descripcion,
      leyenda: leyenda,
      actualizaCuentaCorriente: actualizaCuentaCorriente,
      pedirEntrega: pedirEntrega,
      aplicarVencimientosMultiples: aplicarVencimientosMultiples,
      aplicarSobreCpbte: aplicarSobreCpbte,
      discriminarIntereses: discriminarIntereses,
      discriminarBonificaciones: discriminarBonificaciones,
      editarVencimientos: editarVencimientos,
      imprimeVencimientos: imprimeVencimientos,
      imprimeCodCondVta: imprimeCodCondVta,
      notas: notas,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we create an object from default
  ///
  factory TableCondicionDeVentaModel.fromKey({
    required TableEmpresaModel pEmpresa,
    required int pCodigo,
    required String pDescripcion,
    required String pEnvironment,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codCondVta = pCodigo;
    String descripcion = pDescripcion;
    String leyenda = "";
    String actualizaCuentaCorriente = "";
    String pedirEntrega = "";
    String aplicarVencimientosMultiples = "";
    String aplicarSobreCpbte = "";
    String discriminarIntereses = "";
    String discriminarBonificaciones = "";
    String editarVencimientos = "";
    String imprimeVencimientos = "";
    String imprimeCodCondVta = "";
    String notas = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromKey';
    return TableCondicionDeVentaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codCondVta: codCondVta,
      descripcion: descripcion,
      leyenda: leyenda,
      actualizaCuentaCorriente: actualizaCuentaCorriente,
      pedirEntrega: pedirEntrega,
      aplicarVencimientosMultiples: aplicarVencimientosMultiples,
      aplicarSobreCpbte: aplicarSobreCpbte,
      discriminarIntereses: discriminarIntereses,
      discriminarBonificaciones: discriminarBonificaciones,
      editarVencimientos: editarVencimientos,
      imprimeVencimientos: imprimeVencimientos,
      imprimeCodCondVta: imprimeCodCondVta,
      notas: notas,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we didn't find any records when filtering
  ///
  factory TableCondicionDeVentaModel.noRecordsFound({
    required TableEmpresaModel pEmpresa,
    String filter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codCondVta = -1;
    String descripcion = "NO HAY REGISTROS s/filtro [$filter]";
    String leyenda = "";
    String actualizaCuentaCorriente = "";
    String pedirEntrega = "";
    String aplicarVencimientosMultiples = "";
    String aplicarSobreCpbte = "";
    String discriminarIntereses = "";
    String discriminarBonificaciones = "";
    String editarVencimientos = "";
    String imprimeVencimientos = "";
    String imprimeCodCondVta = "";
    String notas = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromNoRecordsFound';
    return TableCondicionDeVentaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codCondVta: codCondVta,
      descripcion: descripcion,
      leyenda: leyenda,
      actualizaCuentaCorriente: actualizaCuentaCorriente,
      pedirEntrega: pedirEntrega,
      aplicarVencimientosMultiples: aplicarVencimientosMultiples,
      aplicarSobreCpbte: aplicarSobreCpbte,
      discriminarIntereses: discriminarIntereses,
      discriminarBonificaciones: discriminarBonificaciones,
      editarVencimientos: editarVencimientos,
      imprimeVencimientos: imprimeVencimientos,
      imprimeCodCondVta: imprimeCodCondVta,
      notas: notas,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we create an object from any error
  ///
  factory TableCondicionDeVentaModel.fromError({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codCondVta = -3;
    String descripcion = "NO HAY REGISTROS p/error [$pFilter]";
    String leyenda = "";
    String actualizaCuentaCorriente = "";
    String pedirEntrega = "";
    String aplicarVencimientosMultiples = "";
    String aplicarSobreCpbte = "";
    String discriminarIntereses = "";
    String discriminarBonificaciones = "";
    String editarVencimientos = "";
    String imprimeVencimientos = "";
    String imprimeCodCondVta = "";
    String notas = "";
    String lockHash = "";
    String environment = "default";
    String fromType = 'fromError';
    return TableCondicionDeVentaModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codCondVta: codCondVta,
      descripcion: descripcion,
      leyenda: leyenda,
      actualizaCuentaCorriente: actualizaCuentaCorriente,
      pedirEntrega: pedirEntrega,
      aplicarVencimientosMultiples: aplicarVencimientosMultiples,
      aplicarSobreCpbte: aplicarSobreCpbte,
      discriminarIntereses: discriminarIntereses,
      discriminarBonificaciones: discriminarBonificaciones,
      editarVencimientos: editarVencimientos,
      imprimeVencimientos: imprimeVencimientos,
      imprimeCodCondVta: imprimeCodCondVta,
      notas: notas,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableCondicionDeVentaModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    return TableCondicionDeVentaModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
    );
  }

  /// This is the default factory creating object
  ///
  factory TableCondicionDeVentaModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
  }) {
    const String className = "TableCondicionDeVentaModel";
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
      int codCondVta = -1;
      if (int.tryParse(map["CodCondVta"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodCondVta',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codCondVta = int.parse(map['CodCondVta'].toString());
      String descripcion = map['Descripcion'].toString();

      String leyenda = map['Leyenda'].toString();
      String actualizaCuentaCorriente =
          map['ActualizaCuentaCorriente'].toString();
      String pedirEntrega = map['PedirEntrega'].toString();
      String aplicarVencimientosMultiples =
          map['AplicarVencimientosMultiples'].toString();
      String aplicarSobreCpbte = map['AplicarSobreCpbte'].toString();
      String discriminarIntereses = map['DiscriminarIntereses'].toString();
      String discriminarBonificaciones =
          map['DiscriminarBonificaciones'].toString();
      String editarVencimientos = map['EditarVencimientos'].toString();
      String imprimeVencimientos = map['ImprimeVencimientos'].toString();
      String imprimeCodCondVta = map['ImprimeCodCondVta'].toString();
      String notas = map['Notas'].toString();

      String lockHash = map['LockHash'].toString();
      String environment = map['Environment'].toString();

      String fromType = 'fromJson';
      TableEmpresaModel eEmpresa = pEmpresa;
      if (pEmpresa.codEmp != codEmp) {
        eEmpresa = TableEmpresaModel.fromKey(
          pCodEmp: codEmp,
          pRazonSocial: razonSocialCodEmp,
          pEnvironment: environment,
        );
      }
      return TableCondicionDeVentaModel._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        codCondVta: codCondVta,
        descripcion: descripcion,
        leyenda: leyenda,
        actualizaCuentaCorriente: actualizaCuentaCorriente,
        pedirEntrega: pedirEntrega,
        aplicarVencimientosMultiples: aplicarVencimientosMultiples,
        aplicarSobreCpbte: aplicarSobreCpbte,
        discriminarIntereses: discriminarIntereses,
        discriminarBonificaciones: discriminarBonificaciones,
        editarVencimientos: editarVencimientos,
        imprimeVencimientos: imprimeVencimientos,
        imprimeCodCondVta: imprimeCodCondVta,
        notas: notas,
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
      "RazonSocialCodEmp": razonSocialCodEmp,
      "CodCondVta": codCondVta,
      "Descripcion": descripcion,
      "Leyenda": leyenda,
      "ActualizaCuentaCorriente": actualizaCuentaCorriente,
      "PedirEntrega": pedirEntrega,
      "AplicarVencimientosMultiples": aplicarVencimientosMultiples,
      "AplicarSobreCpbte": aplicarSobreCpbte,
      "DiscriminarIntereses": discriminarIntereses,
      "DiscriminarBonificaciones": discriminarBonificaciones,
      "EditarVencimientos": editarVencimientos,
      "ImprimeVencimientos": imprimeVencimientos,
      "ImprimeCodCondVta": imprimeCodCondVta,
      "Notas": notas,
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
      "codCondVta": codCondVta,
      "descripcion": descripcion,
      "leyenda": leyenda,
      "actualizaCuentaCorriente": actualizaCuentaCorriente,
      "pedirEntrega": pedirEntrega,
      "aplicarVencimientosMultiples": aplicarVencimientosMultiples,
      "aplicarSobreCpbte": aplicarSobreCpbte,
      "discriminarIntereses": discriminarIntereses,
      "discriminarBonificaciones": discriminarBonificaciones,
      "editarVencimientos": editarVencimientos,
      "imprimeVencimientos": imprimeVencimientos,
      "imprimeCodCondVta": imprimeCodCondVta,
      "notas": notas,
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

    if (other is! TableCondicionDeVentaModel) return false;

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
      '${codCondVta.toString().padLeft(4, '0')} - $descripcion';

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownKey => codCondVta.toString();

  @override
  String get dropDownSubTitle => codCondVta.toString();

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
  Future<List<CommonParamKeyValue<TableCondicionDeVentaModel>>>
      filterSearchFromDropDown({required String searchText}) async {
    ///
    /// This function is a wrapper to permit search on a DropDownList
    ///
    // Future<List<CommonParamKeyValue<T>>> _filterSearchDropDown({
    //   required String searchText,
    //   required String table,
    // })async {
    //   List<CommonParamKeyValue<TableCondicionDeVentaModel>> r

    // }
    List<CommonParamKeyValue<TableCondicionDeVentaModel>> rSearch = [];
    return rSearch;
  }
}
