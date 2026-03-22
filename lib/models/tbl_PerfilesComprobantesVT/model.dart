import 'package:geryon_web_app_ws_v2/models/CommonBooleanModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_PerfilesAnchoDeBanda/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_PerfilesComprobantesFE/model.dart';

class TablePerfilComprobanteVTModel
    implements
        CommonModel<TablePerfilComprobanteVTModel>,
        CommonParamKeyValueCapable {
  static const String className = "TablePerfilComprobanteVTModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_PerfilComprobantesVT";
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
  int codigo;
  String descripcion;
  String status;
  String dateCreated;
  String dateSuspended;
  String claseCpbte;
  String codTpoCpbte;
  String descripcionCodTpoCpbte;
  String tipoInstalacion;
  int codCondVta;
  String descripcionCodCondVta;
  int fechaEstInst;
  String importeTotalSinImpuestos;
  String importeTotalIVA;
  String importeTotalConImpuestos;
  String totalBonificacionSinImpuestos;
  String totalBonificacionIVA;
  String totalBonificacionConImpuestos;
  int codigoPerfilCpbteFE;
  String descripcionCodigoPerfilCpbteFE;
  int codigoPerfilAnchoDeBanda;
  String descripcioncodigoPerfilAnchoDeBanda;
  bool permitirEdicion;
  String lockHash; // This is the hash for the lock on the record
  String environment;
  String fromType;

  TableEmpresaModel eEmpresa;
  TablePerfilComprobanteFEModel ePerfilComprobanteFE;
  TablePerfilAnchoDeBandaModel ePerfilAnchoDeBanda;

  TablePerfilComprobanteVTModel._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.codigo,
    required this.descripcion,
    required this.status,
    required this.dateCreated,
    required this.dateSuspended,
    required this.claseCpbte,
    required this.codTpoCpbte,
    required this.descripcionCodTpoCpbte,
    required this.tipoInstalacion,
    required this.codCondVta,
    required this.descripcionCodCondVta,
    required this.fechaEstInst,
    required this.importeTotalSinImpuestos,
    required this.importeTotalIVA,
    required this.importeTotalConImpuestos,
    required this.totalBonificacionSinImpuestos,
    required this.totalBonificacionIVA,
    required this.totalBonificacionConImpuestos,
    required this.codigoPerfilCpbteFE,
    required this.descripcionCodigoPerfilCpbteFE,
    required this.codigoPerfilAnchoDeBanda,
    required this.descripcioncodigoPerfilAnchoDeBanda,
    required this.permitirEdicion,
    required this.lockHash,
    required this.environment,
    required this.fromType,
    required this.eEmpresa,
    required this.ePerfilComprobanteFE,
    required this.ePerfilAnchoDeBanda,
  });

  /// If we create an object from default
  ///
  factory TablePerfilComprobanteVTModel.fromDefault({
    required TableEmpresaModel pEmpresa,
    required TablePerfilComprobanteFEModel pPerfilComprobanteFE,
    required TablePerfilAnchoDeBandaModel pPerfilAnchoDeBanda,
  }) {
    int codEmp = pEmpresa.codEmp;
    String razonSocialCodEmp = pEmpresa.razonSocial;
    int codigo = -2;
    String descripcion = "SELECCIONE UN PERFIL";
    String status = "default";
    String dateCreated = "0000-00-00";
    String dateSuspended = "0000-00-00";
    String claseCpbte = "default";
    String codTpoCpbte = "";
    String descripcionCodTpoCpbte = "";
    String tipoInstalacion = "default";
    int codCondVta = 0;
    String descripcionCodCondVta = "";
    int fechaEstInst = 0;
    String importeTotalSinImpuestos = "0";
    String importeTotalIVA = "0";
    String importeTotalConImpuestos = "0";
    String totalBonificacionSinImpuestos = "0";
    String totalBonificacionIVA = "0";
    String totalBonificacionConImpuestos = "0";
    int codigoPerfilCpbteFE = pPerfilComprobanteFE.codigo;
    String descripcionCodigoPerfilCpbteFE = pPerfilComprobanteFE.descripcion;
    int codigoPerfilAnchoDeBanda = pPerfilAnchoDeBanda.codigo;
    String descripcioncodigoPerfilAnchoDeBanda =
        pPerfilAnchoDeBanda.descripcion;
    bool permitirEdicion = false;
    String lockHash = ""; // This is the hash for the lock on the record
    String environment = "default";
    String fromType = 'fromDefault';
    return TablePerfilComprobanteVTModel._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      codigo: codigo,
      descripcion: descripcion,
      status: status,
      dateCreated: dateCreated,
      dateSuspended: dateSuspended,
      claseCpbte: claseCpbte,
      codTpoCpbte: codTpoCpbte,
      descripcionCodTpoCpbte: descripcionCodTpoCpbte,
      tipoInstalacion: tipoInstalacion,
      codCondVta: codCondVta,
      descripcionCodCondVta: descripcionCodCondVta,
      fechaEstInst: fechaEstInst,
      importeTotalSinImpuestos: importeTotalSinImpuestos,
      importeTotalIVA: importeTotalIVA,
      importeTotalConImpuestos: importeTotalConImpuestos,
      totalBonificacionSinImpuestos: totalBonificacionSinImpuestos,
      totalBonificacionIVA: totalBonificacionIVA,
      totalBonificacionConImpuestos: totalBonificacionConImpuestos,
      codigoPerfilCpbteFE: codigoPerfilCpbteFE,
      descripcionCodigoPerfilCpbteFE: descripcionCodigoPerfilCpbteFE,
      codigoPerfilAnchoDeBanda: codigoPerfilAnchoDeBanda,
      descripcioncodigoPerfilAnchoDeBanda: descripcioncodigoPerfilAnchoDeBanda,
      permitirEdicion: permitirEdicion,
      lockHash: lockHash,
      environment: environment,
      fromType: fromType,
      eEmpresa: pEmpresa,
      ePerfilComprobanteFE: pPerfilComprobanteFE,
      ePerfilAnchoDeBanda: pPerfilAnchoDeBanda,
    );
  }

  /// If we create an object from default
  ///
  factory TablePerfilComprobanteVTModel.fromKey({
    required TableEmpresaModel pEmpresa,
    required TablePerfilComprobanteFEModel pPerfilComprobanteFE,
    required TablePerfilAnchoDeBandaModel pPerfilAnchoDeBanda,
    required int pCodigo,
    required String pDescripcion,
    required String pEnvironment,
  }) {
    var dPerfil = TablePerfilComprobanteVTModel.fromDefault(
        pEmpresa: pEmpresa,
        pPerfilComprobanteFE: pPerfilComprobanteFE,
        pPerfilAnchoDeBanda: pPerfilAnchoDeBanda);
    dPerfil.codEmp = pEmpresa.codEmp;
    dPerfil.razonSocialCodEmp = pEmpresa.razonSocial;
    dPerfil.codigo = pCodigo;
    dPerfil.descripcion = pDescripcion;
    dPerfil.environment = pEnvironment;
    dPerfil.ePerfilComprobanteFE = pPerfilComprobanteFE;
    dPerfil.ePerfilAnchoDeBanda = pPerfilAnchoDeBanda;
    dPerfil.fromType = 'fromKey';
    return dPerfil;
  }

  /// If we didn't find any records when filtering
  ///
  factory TablePerfilComprobanteVTModel.noRecordsFound({
    required TableEmpresaModel pEmpresa,
    String filter = "",
  }) {
    TablePerfilComprobanteFEModel pPerfilComprobanteFE =
        TablePerfilComprobanteFEModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    TablePerfilAnchoDeBandaModel pPerfilAnchoDeBanda =
        TablePerfilAnchoDeBandaModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var dPerfil = TablePerfilComprobanteVTModel.fromDefault(
        pEmpresa: pEmpresa,
        pPerfilComprobanteFE: pPerfilComprobanteFE,
        pPerfilAnchoDeBanda: pPerfilAnchoDeBanda);
    dPerfil.codEmp = pEmpresa.codEmp;
    dPerfil.razonSocialCodEmp = pEmpresa.razonSocial;
    dPerfil.codigo = -1;
    dPerfil.descripcion = "NO HAY REGISTROS s/filtro [$filter]";
    dPerfil.environment = "default";
    dPerfil.ePerfilComprobanteFE = pPerfilComprobanteFE;
    dPerfil.ePerfilAnchoDeBanda = pPerfilAnchoDeBanda;
    dPerfil.fromType = 'fromNoRecordsFound';
    return dPerfil;
  }

  /// If we create an object from any error
  ///
  factory TablePerfilComprobanteVTModel.fromError({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    TablePerfilComprobanteFEModel pPerfilComprobanteFE =
        TablePerfilComprobanteFEModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    TablePerfilAnchoDeBandaModel pPerfilAnchoDeBanda =
        TablePerfilAnchoDeBandaModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var dPerfil = TablePerfilComprobanteVTModel.fromDefault(
        pEmpresa: pEmpresa,
        pPerfilComprobanteFE: pPerfilComprobanteFE,
        pPerfilAnchoDeBanda: pPerfilAnchoDeBanda);
    dPerfil.codEmp = pEmpresa.codEmp;
    dPerfil.razonSocialCodEmp = pEmpresa.razonSocial;
    dPerfil.codigo = -1;
    dPerfil.descripcion = "NO HAY REGISTROS p/error [$pFilter]";
    dPerfil.environment = "default";
    dPerfil.ePerfilComprobanteFE = pPerfilComprobanteFE;
    dPerfil.ePerfilAnchoDeBanda = pPerfilAnchoDeBanda;
    dPerfil.fromType = 'fromError';
    return dPerfil;
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TablePerfilComprobanteVTModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    return TablePerfilComprobanteVTModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
    );
  }

  /// This is the default factory creating object
  ///

  factory TablePerfilComprobanteVTModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
  }) {
    const String className = "TablePerfilComprobanteVTModel";
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
      String status = map['Status'].toString();
      String dateCreated = map['DateCreated'].toString();
      String dateSuspended = map['DateSuspended'].toString();
      String claseCpbte = map['ClaseCpbte'].toString();
      String codTpoCpbte = map['CodTpoCpbte'].toString();
      String descripcionCodTpoCpbte = map['DescripcionCodTpoCpbte'].toString();
      String tipoInstalacion = map['TipoInstalacion'].toString();

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
      String descripcionCodCondVta = map['DescripcionCodCondVta'].toString();

      int fechaEstInst = -1;
      if (int.tryParse(map["FechaEstInst"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'FechaEstInst',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      fechaEstInst = int.parse(map['FechaEstInst'].toString());
      String importeTotalSinImpuestos =
          map['ImporteTotalSinImpuestos'].toString();
      String importeTotalIVA = map['ImporteTotalIVA'].toString();
      String importeTotalConImpuestos =
          map['ImporteTotalConImpuestos'].toString();
      String totalBonificacionSinImpuestos =
          map['TotalBonificacionSinImpuestos'].toString();
      String totalBonificacionIVA = map['TotalBonificacionIVA'].toString();
      String totalBonificacionConImpuestos =
          map['TotalBonificacionConImpuestos'].toString();

      int codigoPerfilCpbteFE = -1;
      if (int.tryParse(map["CodigoPerfilCpbteFE"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodigoPerfilCpbteFE',
          propertyValue: map["CodigoPerfilCpbteFE"].toString(),
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codigoPerfilCpbteFE = int.parse(map['CodigoPerfilCpbteFE'].toString());
      String descripcionCodigoPerfilCpbteFE =
          map['DescripcionCodigoPerfilCpbteFE'].toString();

      int codigoPerfilAnchoDeBanda = -1;
      if (int.tryParse(map["CodigoPerfilAnchoDeBanda"].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodigoPerfilAnchoDeBanda',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      codigoPerfilAnchoDeBanda =
          int.parse(map['CodigoPerfilAnchoDeBanda'].toString());
      String descripcioncodigoPerfilAnchoDeBanda =
          map['DescripcionCodigoPerfilAnchoDeBanda'].toString();

      var rPermitirEdicion = CommonBooleanModel.parse(map['PermitirEdicion']);
      if (rPermitirEdicion.errorCode != 0) {
        throw ErrorHandler(
          errorCode: rPermitirEdicion.errorCode,
          errorDsc: rPermitirEdicion.errorDsc,
          propertyName: 'PermitirEdicion',
          className: className,
          stacktrace: StackTrace.current,
        );
      }
      bool permitirEdicion = rPermitirEdicion.data.value;

      String lockHash = map['LockHash'].toString();

      String environment = map['Environment'].toString();

      String fromType = 'Json';
      TableEmpresaModel eEmpresa = pEmpresa;
      if (map['Empresa'] != null) {
        eEmpresa = TableEmpresaModel.fromJson(map['Empresa']);
      }

      TablePerfilComprobanteFEModel ePerfilComprobanteFE =
          TablePerfilComprobanteFEModel.fromKey(
        pEmpresa: pEmpresa,
        pCodigo: codigoPerfilCpbteFE,
        pDescripcion: descripcionCodigoPerfilCpbteFE,
        pEnvironment: environment,
      );
      if (map['PerfilComprobanteFE'] != null) {
        ePerfilComprobanteFE = TablePerfilComprobanteFEModel.fromJson(
          map: map['PerfilComprobanteFE'],
          errorCode: errorCode,
          pEmpresa: pEmpresa,
        );
      }

      TablePerfilAnchoDeBandaModel ePerfilAnchoDeBanda =
          TablePerfilAnchoDeBandaModel.fromKey(
        pEmpresa: pEmpresa,
        pCodigo: codigoPerfilAnchoDeBanda,
        pDescripcion: descripcioncodigoPerfilAnchoDeBanda,
        pEnvironment: environment,
      );
      if (map['PerfilAnchoDeBanda'] != null) {
        ePerfilAnchoDeBanda = TablePerfilAnchoDeBandaModel.fromJson(
          map: map['PerfilAnchoDeBanda'],
          errorCode: errorCode,
          pEmpresa: pEmpresa,
        );
      }

      return TablePerfilComprobanteVTModel._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        codigo: codigo,
        descripcion: descripcion,
        status: status,
        dateCreated: dateCreated,
        dateSuspended: dateSuspended,
        claseCpbte: claseCpbte,
        codTpoCpbte: codTpoCpbte,
        descripcionCodTpoCpbte: descripcionCodTpoCpbte,
        tipoInstalacion: tipoInstalacion,
        codCondVta: codCondVta,
        descripcionCodCondVta: descripcionCodCondVta,
        fechaEstInst: fechaEstInst,
        importeTotalSinImpuestos: importeTotalSinImpuestos,
        importeTotalIVA: importeTotalIVA,
        importeTotalConImpuestos: importeTotalConImpuestos,
        totalBonificacionSinImpuestos: totalBonificacionSinImpuestos,
        totalBonificacionIVA: totalBonificacionIVA,
        totalBonificacionConImpuestos: totalBonificacionConImpuestos,
        codigoPerfilCpbteFE: codigoPerfilCpbteFE,
        descripcionCodigoPerfilCpbteFE: descripcionCodigoPerfilCpbteFE,
        codigoPerfilAnchoDeBanda: codigoPerfilAnchoDeBanda,
        descripcioncodigoPerfilAnchoDeBanda:
            descripcioncodigoPerfilAnchoDeBanda,
        permitirEdicion: permitirEdicion,
        lockHash: lockHash,
        environment: environment,
        fromType: fromType,
        eEmpresa: eEmpresa,
        ePerfilComprobanteFE: ePerfilComprobanteFE,
        ePerfilAnchoDeBanda: ePerfilAnchoDeBanda,
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
      'Codigo': codigo,
      'Descripcion': descripcion,
      'Status': status,
      'DateCreated': dateCreated,
      'DateSuspended': dateSuspended,
      'ClaseCpbte': claseCpbte,
      'CodTpoCpbte': codTpoCpbte,
      'TipoInstalacion': tipoInstalacion,
      'CodCondVta': codCondVta,
      'FechaEstInst': fechaEstInst,
      'ImporteTotalSinImpuestos': importeTotalSinImpuestos,
      'ImporteTotalIVA': importeTotalIVA,
      'ImporteTotalConImpuestos': importeTotalConImpuestos,
      'TotalBonificacionSinImpuestos': totalBonificacionSinImpuestos,
      'TotalBonificacionIVA': totalBonificacionIVA,
      'TotalBonificacionConImpuestos': totalBonificacionConImpuestos,
      'CodigoPerfilCpbteFE': codigoPerfilCpbteFE,
      'DescripcionCodigoPerfilCpbteFE': descripcionCodigoPerfilCpbteFE,
      'CodigoPerfilAnchoDeBanda': codigoPerfilAnchoDeBanda,
      'DescripcionCodigoPerfilAnchoDeBanda':
          descripcioncodigoPerfilAnchoDeBanda,
      'PermitirEdicion': permitirEdicion,
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
      'status': status,
      'dateCreated': dateCreated,
      'dateSuspended': dateSuspended,
      'claseCpbte': claseCpbte,
      'codTpoCpbte': codTpoCpbte,
      'tipoInstalacion': tipoInstalacion,
      'codCondVta': codCondVta,
      'fechaEstInst': fechaEstInst,
      'importeTotalSinImpuestos': importeTotalSinImpuestos,
      'importeTotalIVA': importeTotalIVA,
      'importeTotalConImpuestos': importeTotalConImpuestos,
      'totalBonificacionSinImpuestos': totalBonificacionSinImpuestos,
      'totalBonificacionIVA': totalBonificacionIVA,
      'totalBonificacionConImpuestos': totalBonificacionConImpuestos,
      'codigoPerfilCpbteFE': codigoPerfilCpbteFE,
      'descripcionCodigoPerfilCpbteFE': descripcionCodigoPerfilCpbteFE,
      'codigoPerfilAnchoDeBanda': codigoPerfilAnchoDeBanda,
      'descripcionCodigoPerfilAnchoDeBanda':
          descripcioncodigoPerfilAnchoDeBanda,
      'permitirEdicion': permitirEdicion,
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

    if (other is! TablePerfilComprobanteVTModel) return false;

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

  /// Este valos es el que se muestra como Subtitle en el DropTextBox
  ///
  @override
  String get dropDownSubTitle =>
      'Código: ${codigo.toString().padLeft(3, "0")} | Clase: ${claseCpbte.toString()}';

  /// Este valor es el que se muestra como Title en el DropTextBox
  ///
  @override
  String get dropDownTitle => descripcion.toString();

  /// Este valor es el que se muestra en el TextBox una vez seleccionado
  ///
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
  Future<List<CommonParamKeyValue<TablePerfilComprobanteVTModel>>>
      filterSearchFromDropDown({required String searchText}) async {
    ///
    /// This function is a wrapper to permit search on a DropDownList
    ///
    // Future<List<CommonParamKeyValue<T>>> _filterSearchDropDown({
    //   required String searchText,
    //   required String table,
    // })async {
    //   List<CommonParamKeyValue<TablePerfilComprobanteVTModel>> r

    // }
    List<CommonParamKeyValue<TablePerfilComprobanteVTModel>> rSearch = [];
    return rSearch;
  }
}
