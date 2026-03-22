import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';

class TableTipoDeComprobanteModel
    implements
        CommonModel<TableTipoDeComprobanteModel>,
        CommonParamKeyValueCapable {
  static const String className = "TableTipoDeComprobanteModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_TiposDeComprobantes";
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
      'CodTpoCpbte': codTpoCpbte,
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
      kValue: "FechaPedidoES",
      vValue: "Fecha Pedido",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "FechaEstInst",
      vValue: "Fecha Est. Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "FechaRealInst",
      vValue: "Fecha Real Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodTpoCpbte",
      vValue: "Tipo Cpbte.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodLetra",
      vValue: "Letra",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroSucursal",
      vValue: "Nº Suc.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Numero",
      vValue: "Número",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ImporteTotalConImpuestos",
      vValue: "Importe T. C.I.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Estado",
      vValue: "Estado",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodClie",
      vValue: "Cód. Clie.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "RazonSocialCodClie",
      vValue: "Razón Social",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CUIT",
      vValue: "C.U.I.T.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroDoc",
      vValue: "Nº Doc.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "EstadoCodClie",
      vValue: "Estado Clie.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroServicio",
      vValue: "Nº Serv.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodCdad",
      vValue: "Cód. Cdad.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodCdad",
      vValue: "Nombre",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodPostalCodCdad",
      vValue: "C.P.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodigoBarrio",
      vValue: "Cód. Barrio",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodigoBarrio",
      vValue: "Nombre",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Domicilio",
      vValue: "Calle",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroPuerta",
      vValue: "Nº",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Piso",
      vValue: "Piso",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Depto",
      vValue: "Depto.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Torre",
      vValue: "Torre",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Sector",
      vValue: "Sector",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodCdadFacturacion",
      vValue: "Cód. Cdad. F.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodCdadFacturacion",
      vValue: "Nombre",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodPostalCodCdadFacturacion",
      vValue: "C.P. F.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DomicilioFacturacion",
      vValue: "Calle F.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroPuertaFacturacion",
      vValue: "Nº F.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "PisoFacturacion",
      vValue: "Piso F.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DeptoFacturacion",
      vValue: "Depto. F.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "TorreFacturacion",
      vValue: "Torre F.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "SectorFacturacion",
      vValue: "Sector F.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodCatIVA",
      vValue: "Cód. Cat. IVA",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodCatIVA",
      vValue: "Descripción",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodCondVta",
      vValue: "Cód. Cond. Vta.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodCondVta",
      vValue: "Descripción",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroCpbteVTProrrateo",
      vValue: "Nº VT. Pro.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ClaseCpbteVTProrrateo",
      vValue: "Clase Cpbte. VT. Pro.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodTpoCpbteProrrateo",
      vValue: "Cód. Cpbte. VT. Pro.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodLetraProrrateo",
      vValue: "Letra",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroSucursalProrrateo",
      vValue: "Nº Suc.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NumeroProrrateo",
      vValue: "Nº",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ImporteTotalProrrateo",
      vValue: "Importe Pro.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "FechaDesdeServFactuProrrateo",
      vValue: "Fecha Desde",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "FechaHastaServFactuProrrateo",
      vValue: "Fecha Hasta",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroCpbteVTFactuInstalacion",
      vValue: "Cód. Cpbte. VT. Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ClaseCpbteVTFactuInstalacion",
      vValue: "Clase Cpbte. VT. Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodTpoCpbteFactuInstalacion",
      vValue: "Nº VT. Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodLetraFactuInstalacion",
      vValue: "Letra",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroSucursalFactuInstalacion",
      vValue: "Nº Suc.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NumeroFactuInstalacion",
      vValue: "Nº",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ImporteTotalFactuInstalacion",
      vValue: "Importe Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroCpbteVTRecInstalacion",
      vValue: "Nº Rec. Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ClaseCpbteVTRecInstalacion",
      vValue: "Clase Cpbte. Rec. Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodTpoCpbteRecInstalacion",
      vValue: "Cód. Cpbte. Rec. Inst.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodLetraRecInstalacion",
      vValue: "Letra",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroSucursalRecInstalacion",
      vValue: "Nº Suc.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NumeroRecInstalacion",
      vValue: "Nº",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ImporteTotalRecInstalacion",
      vValue: "Importe Rec.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "SaldoActual",
      vValue: "Saldo Actual",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "UltFechaActSaldo",
      vValue: "Ult. Fecha ACT. Saldo",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "UltFechaVenta",
      vValue: "Ult. Fecha VTA.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "UltFechaCobro",
      vValue: "Ult. Fecha COB.",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ModuloDATOS",
      vValue: "DATOS",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ModuloVOZ",
      vValue: "VOZ",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ModuloTELEVISION",
      vValue: "TV",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "UsernameIntranet",
      vValue: "Usuario Intranet",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "PasswordIntranet",
      vValue: "Password Intranet",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "AliasBancoRoela",
      vValue: "Alias ROELA",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CBUBancoRoela",
      vValue: "CBU Roela",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodigoPMCnPF",
      vValue: "Cód. PMC/PF",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodigoBarrasPMCnPF",
      vValue: "Código de Barras",
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
  String codTpoCpbte;
  String descripcion;
  String descripcionImpresion;
  String claseCpbte;
  String impresoraFiscal;
  String username;
  int modeloImpresion;
  String leyenda;
  String utilizaVencimientos;
  String utilizaSoloUnCodigoDeLetra;
  String facturacionElectronica;
  int codigoTipoCpbteFE;
  String descripcionCodigoTipoCpbteFE;
  String confirmarProrrateo;
  String confirmarInteres;
  String confirmarPerfilCliente;
  String facturacionPorCuentaYOrden;
  String leyendaFacturacionPorCuentaYOrden;
  String liquidaIVA;
  String lockHash; // default value for lockHash
  String environment;
  String fromType;

  TableEmpresaModel eEmpresa;

  TableTipoDeComprobanteModel._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.codTpoCpbte,
    required this.descripcion,
    required this.descripcionImpresion,
    required this.claseCpbte,
    required this.impresoraFiscal,
    required this.username,
    required this.modeloImpresion,
    required this.leyenda,
    required this.utilizaVencimientos,
    required this.utilizaSoloUnCodigoDeLetra,
    required this.facturacionElectronica,
    required this.codigoTipoCpbteFE,
    required this.descripcionCodigoTipoCpbteFE,
    required this.confirmarProrrateo,
    required this.confirmarInteres,
    required this.confirmarPerfilCliente,
    required this.facturacionPorCuentaYOrden,
    required this.leyendaFacturacionPorCuentaYOrden,
    required this.liquidaIVA,
    required this.lockHash,
    required this.environment,
    required this.fromType,
    required this.eEmpresa,
  });

  /// if we create an object from default
  ///
  factory TableTipoDeComprobanteModel.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    String codTpoCpbte = "default";
    String descripcion = "SELECCIONE UN TIPO DE COMPROBANTE";
    String descripcionImpresion = "SELECCIONE UN TIPO DE COMPROBANTE";
    String claseCpbte = "default";
    String impresoraFiscal = "";
    String username = "";
    int modeloImpresion = 0;
    String leyenda = "";
    String utilizaVencimientos = "";
    String utilizaSoloUnCodigoDeLetra = "";
    String facturacionElectronica = "";
    int codigoTipoCpbteFE = 0;
    String descripcionCodigoTipoCpbteFE = "";
    String confirmarProrrateo = "";
    String confirmarInteres = "";
    String confirmarPerfilCliente = "";
    String facturacionPorCuentaYOrden = "";
    String leyendaFacturacionPorCuentaYOrden = "";
    String liquidaIVA = "";
    String lockHash = ""; // default value for lockHash
    String environment = "default";
    String fromType = 'Default';
    return TableTipoDeComprobanteModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codTpoCpbte: codTpoCpbte,
      descripcion: descripcion,
      descripcionImpresion: descripcionImpresion,
      claseCpbte: claseCpbte,
      impresoraFiscal: impresoraFiscal,
      username: username,
      modeloImpresion: modeloImpresion,
      leyenda: leyenda,
      utilizaVencimientos: utilizaVencimientos,
      utilizaSoloUnCodigoDeLetra: utilizaSoloUnCodigoDeLetra,
      facturacionElectronica: facturacionElectronica,
      codigoTipoCpbteFE: codigoTipoCpbteFE,
      descripcionCodigoTipoCpbteFE: descripcionCodigoTipoCpbteFE,
      confirmarProrrateo: confirmarProrrateo,
      confirmarInteres: confirmarInteres,
      confirmarPerfilCliente: confirmarPerfilCliente,
      facturacionPorCuentaYOrden: facturacionPorCuentaYOrden,
      leyendaFacturacionPorCuentaYOrden: leyendaFacturacionPorCuentaYOrden,
      liquidaIVA: liquidaIVA,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// if we create an object from key (basic)
  ///
  factory TableTipoDeComprobanteModel.fromKey({
    required TableEmpresaModel pEmpresa,
    required String pCodTpoCpbte,
    required String pDescripcion,
    required String pClaseCpbte,
    required String pEnvironment,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    String codTpoCpbte = pCodTpoCpbte;
    String descripcion = pDescripcion;
    String descripcionImpresion = pDescripcion;
    String claseCpbte = pClaseCpbte;
    String impresoraFiscal = "";
    String username = "";
    int modeloImpresion = 0;
    String leyenda = "";
    String utilizaVencimientos = "";
    String utilizaSoloUnCodigoDeLetra = "";
    String facturacionElectronica = "";
    int codigoTipoCpbteFE = 0;
    String descripcionCodigoTipoCpbteFE = "";
    String confirmarProrrateo = "";
    String confirmarInteres = "";
    String confirmarPerfilCliente = "";
    String facturacionPorCuentaYOrden = "";
    String leyendaFacturacionPorCuentaYOrden = "";
    String liquidaIVA = "";
    String lockHash = ""; // default value for lockHash
    String environment = pEnvironment;
    String fromType = 'Key';
    return TableTipoDeComprobanteModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codTpoCpbte: codTpoCpbte,
      descripcion: descripcion,
      descripcionImpresion: descripcionImpresion,
      claseCpbte: claseCpbte,
      impresoraFiscal: impresoraFiscal,
      username: username,
      modeloImpresion: modeloImpresion,
      leyenda: leyenda,
      utilizaVencimientos: utilizaVencimientos,
      utilizaSoloUnCodigoDeLetra: utilizaSoloUnCodigoDeLetra,
      facturacionElectronica: facturacionElectronica,
      codigoTipoCpbteFE: codigoTipoCpbteFE,
      descripcionCodigoTipoCpbteFE: descripcionCodigoTipoCpbteFE,
      confirmarProrrateo: confirmarProrrateo,
      confirmarInteres: confirmarInteres,
      confirmarPerfilCliente: confirmarPerfilCliente,
      facturacionPorCuentaYOrden: facturacionPorCuentaYOrden,
      leyendaFacturacionPorCuentaYOrden: leyendaFacturacionPorCuentaYOrden,
      liquidaIVA: liquidaIVA,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we didn't find any records when filtering
  ///
  factory TableTipoDeComprobanteModel.noRecordsFound({
    required TableEmpresaModel pEmpresa,
    String filter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    String codTpoCpbte = "";
    String descripcion = "NO HAY REGISTROS s/filtro [$filter]";
    String descripcionImpresion = "NO HAY REGISTROS s/filtro [$filter]";
    String claseCpbte = "Unknown";
    String impresoraFiscal = "";
    String username = "";
    int modeloImpresion = 0;
    String leyenda = "";
    String utilizaVencimientos = "";
    String utilizaSoloUnCodigoDeLetra = "";
    String facturacionElectronica = "";
    int codigoTipoCpbteFE = 0;
    String descripcionCodigoTipoCpbteFE = "";
    String confirmarProrrateo = "";
    String confirmarInteres = "";
    String confirmarPerfilCliente = "";
    String facturacionPorCuentaYOrden = "";
    String leyendaFacturacionPorCuentaYOrden = "";
    String liquidaIVA = "";
    String lockHash = ""; // default value for lockHash
    String environment = "default";
    String fromType = 'NoRecordsFround';
    return TableTipoDeComprobanteModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codTpoCpbte: codTpoCpbte,
      descripcion: descripcion,
      descripcionImpresion: descripcionImpresion,
      claseCpbte: claseCpbte,
      impresoraFiscal: impresoraFiscal,
      username: username,
      modeloImpresion: modeloImpresion,
      leyenda: leyenda,
      utilizaVencimientos: utilizaVencimientos,
      utilizaSoloUnCodigoDeLetra: utilizaSoloUnCodigoDeLetra,
      facturacionElectronica: facturacionElectronica,
      codigoTipoCpbteFE: codigoTipoCpbteFE,
      descripcionCodigoTipoCpbteFE: descripcionCodigoTipoCpbteFE,
      confirmarProrrateo: confirmarProrrateo,
      confirmarInteres: confirmarInteres,
      confirmarPerfilCliente: confirmarPerfilCliente,
      facturacionPorCuentaYOrden: facturacionPorCuentaYOrden,
      leyendaFacturacionPorCuentaYOrden: leyendaFacturacionPorCuentaYOrden,
      liquidaIVA: liquidaIVA,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// If we create an object from any error
  ///
  factory TableTipoDeComprobanteModel.fromError({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    String codTpoCpbte = "";
    String descripcion = "NO HAY REGISTROS p/error [$pFilter]";
    String descripcionImpresion = "NO HAY REGISTROS p/error [$pFilter]";
    String claseCpbte = "Unknown";
    String impresoraFiscal = "";
    String username = "";
    int modeloImpresion = 0;
    String leyenda = "";
    String utilizaVencimientos = "";
    String utilizaSoloUnCodigoDeLetra = "";
    String facturacionElectronica = "";
    int codigoTipoCpbteFE = 0;
    String descripcionCodigoTipoCpbteFE = "";
    String confirmarProrrateo = "";
    String confirmarInteres = "";
    String confirmarPerfilCliente = "";
    String facturacionPorCuentaYOrden = "";
    String leyendaFacturacionPorCuentaYOrden = "";
    String liquidaIVA = "";
    String lockHash = ""; // default value for lockHash
    String environment = "default";
    String fromType = 'Error';
    return TableTipoDeComprobanteModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codTpoCpbte: codTpoCpbte,
      descripcion: descripcion,
      descripcionImpresion: descripcionImpresion,
      claseCpbte: claseCpbte,
      impresoraFiscal: impresoraFiscal,
      username: username,
      modeloImpresion: modeloImpresion,
      leyenda: leyenda,
      utilizaVencimientos: utilizaVencimientos,
      utilizaSoloUnCodigoDeLetra: utilizaSoloUnCodigoDeLetra,
      facturacionElectronica: facturacionElectronica,
      codigoTipoCpbteFE: codigoTipoCpbteFE,
      descripcionCodigoTipoCpbteFE: descripcionCodigoTipoCpbteFE,
      confirmarProrrateo: confirmarProrrateo,
      confirmarInteres: confirmarInteres,
      confirmarPerfilCliente: confirmarPerfilCliente,
      facturacionPorCuentaYOrden: facturacionPorCuentaYOrden,
      leyendaFacturacionPorCuentaYOrden: leyendaFacturacionPorCuentaYOrden,
      liquidaIVA: liquidaIVA,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableTipoDeComprobanteModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    return TableTipoDeComprobanteModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
    );
  }

  /// This is the default factory creating object
  ///
  factory TableTipoDeComprobanteModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
  }) {
    const String className = "TableTipoDeComprobanteModel";
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
      String codTpoCpbte = map['CodTpoCpbte'].toString();
      String descripcion = map['Descripcion'].toString();
      String descripcionImpresion = map['DescripcionImpresion'].toString();
      String claseCpbte = map['ClaseCpbte'].toString();
      String impresoraFiscal = map['ImpresoraFiscal'].toString();
      String username = map['Username'].toString();

      int modeloImpresion = -1;
      if (int.tryParse(map["ModeloImpresion"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'ModeloImpresion',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      modeloImpresion = int.parse(map['ModeloImpresion'].toString());

      String leyenda = map['Leyenda'].toString();
      String utilizaVencimientos = map['UtilizaVencimientos'].toString();
      String utilizaSoloUnCodigoDeLetra =
          map['UtilizaSoloUnCodigoDeLetra'].toString();
      String facturacionElectronica = map['FacturacionElectronica'].toString();

      int codigoTipoCpbteFE = -1;
      if (int.tryParse(map["CodigoTipoCpbteFE"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodigoTipoCpbteFE',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codigoTipoCpbteFE = int.parse(map['CodigoTipoCpbteFE'].toString());
      String descripcionCodigoTipoCpbteFE =
          map['DescripcionCodigoTipoCpbteFE'].toString();

      String confirmarProrrateo = map['ConfirmarProrrateo'].toString();
      String confirmarInteres = map['ConfirmarInteres'].toString();
      String confirmarPerfilCliente = map['ConfirmarPerfilCliente'].toString();
      String facturacionPorCuentaYOrden =
          map['FacturacionPorCuentaYOrden'].toString();
      String leyendaFacturacionPorCuentaYOrden =
          map['LeyendaFacturacionPorCuentaYOrden'].toString();
      String liquidaIVA = map['LiquidaIVA'].toString();

      String lockHash = map['LockHash'].toString();
      String environment = map['Environment'].toString();
      String fromType = 'Json';

      TableEmpresaModel eEmpresa = pEmpresa;
      return TableTipoDeComprobanteModel._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        codTpoCpbte: codTpoCpbte,
        descripcion: descripcion,
        descripcionImpresion: descripcionImpresion,
        claseCpbte: claseCpbte,
        impresoraFiscal: impresoraFiscal,
        username: username,
        modeloImpresion: modeloImpresion,
        leyenda: leyenda,
        utilizaVencimientos: utilizaVencimientos,
        utilizaSoloUnCodigoDeLetra: utilizaSoloUnCodigoDeLetra,
        facturacionElectronica: facturacionElectronica,
        codigoTipoCpbteFE: codigoTipoCpbteFE,
        descripcionCodigoTipoCpbteFE: descripcionCodigoTipoCpbteFE,
        confirmarProrrateo: confirmarProrrateo,
        confirmarInteres: confirmarInteres,
        confirmarPerfilCliente: confirmarPerfilCliente,
        facturacionPorCuentaYOrden: facturacionPorCuentaYOrden,
        leyendaFacturacionPorCuentaYOrden: leyendaFacturacionPorCuentaYOrden,
        liquidaIVA: liquidaIVA,
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
      'RazonSocialCodEmp': razonSocialCodEmp,
      'CodTpoCpbte': codTpoCpbte,
      'Descripcion': descripcion,
      'DescripcionImpresion': descripcionImpresion,
      'ClaseCpbte': claseCpbte,
      'ImpresoraFiscal': impresoraFiscal,
      'Username': username,
      'ModeloImpresion': modeloImpresion,
      'Leyenda': leyenda,
      'UtilizaVencimientos': utilizaVencimientos,
      'UtilizaSoloUnCodigoDeLetra': utilizaSoloUnCodigoDeLetra,
      'FacturacionElectronica': facturacionElectronica,
      'CodigoTipoCpbteFE': codigoTipoCpbteFE,
      'DescripcionCodigoTipoCpbteFE': descripcionCodigoTipoCpbteFE,
      'ConfirmarProrrateo': confirmarProrrateo,
      'ConfirmarInteres': confirmarInteres,
      'ConfirmarPerfilCliente': confirmarPerfilCliente,
      'FacturacionPorCuentaYOrden': facturacionPorCuentaYOrden,
      'LeyendaFacturacionPorCuentaYOrden': leyendaFacturacionPorCuentaYOrden,
      'LiquidaIVA': liquidaIVA,
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
      'razonSocialCodEmp': razonSocialCodEmp,
      'codTpoCpbte': codTpoCpbte,
      'descripcion': descripcion,
      'descripcionImpresion': descripcionImpresion,
      'claseCpbte': claseCpbte,
      'impresoraFiscal': impresoraFiscal,
      'username': username,
      'modeloImpresion': modeloImpresion,
      'leyenda': leyenda,
      'utilizaVencimientos': utilizaVencimientos,
      'utilizaSoloUnCodigoDeLetra': utilizaSoloUnCodigoDeLetra,
      'facturacionElectronica': facturacionElectronica,
      'codigoTipoCpbteFE': codigoTipoCpbteFE,
      'descripcionCodigoTipoCpbteFE': descripcionCodigoTipoCpbteFE,
      'confirmarProrrateo': confirmarProrrateo,
      'confirmarInteres': confirmarInteres,
      'confirmarPerfilCliente': confirmarPerfilCliente,
      'facturacionPorCuentaYOrden': facturacionPorCuentaYOrden,
      'leyendaFacturacionPorCuentaYOrden': leyendaFacturacionPorCuentaYOrden,
      'liquidaIVA': liquidaIVA,
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

    if (other is! TableTipoDeComprobanteModel) return false;

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
  String get dropDownItemAsString => '$codTpoCpbte - $descripcion';

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownKey => codTpoCpbte.toString();

  @override
  String get dropDownSubTitle => codTpoCpbte.toString();

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
  Future<List<CommonParamKeyValue<TableTipoDeComprobanteModel>>>
      filterSearchFromDropDown({required String searchText}) async {
    ///
    /// This function is a wrapper to permit search on a DropDownList
    ///
    // Future<List<CommonParamKeyValue<T>>> _filterSearchDropDown({
    //   required String searchText,
    //   required String table,
    // })async {
    //   List<CommonParamKeyValue<TableTipoDeComprobanteModel>> r

    // }

    List<CommonParamKeyValue<TableTipoDeComprobanteModel>> rSearch = [];
    return rSearch;
  }
}
