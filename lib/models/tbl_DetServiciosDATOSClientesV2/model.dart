import 'dart:developer' as developer;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/enums/tipo_instalacion_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonClaseCpbteVT/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonGenericProcedureParams/mode.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/CommonUtils/common_utils.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/child_popup_error_message.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Ciudades/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_ClientesV2/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_DetBarriosCiudades/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_DetServiciosDATOSClientesV2/tipologin_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/onu_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/params_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/pon_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Paises/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Provincias/model.dart';

class TableDetServicioDATOSClienteV2Model
    implements
        CommonModel<TableDetServicioDATOSClienteV2Model>,
        CommonParamKeyValueCapable {
  static const String className = "TableDetServicioDATOSClienteV2Model";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = "tbl_DetServiciosClientesDATOS";
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
      'TipoCliente': tipoCliente,
      'CodClie': codClie,
      'NroServicio': nroServicio,
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

  CommonClasesCpbteVT? claseCpbteVT;
  int codEmp;
  String razonSocialCodEmp;
  String tipoCliente;
  int codClie;
  String razonSocialCodClie;
  int nroServicio;
  int nroUnico;
  String tipoServicio;
  int codPais;
  String descripcionCodPais;
  int codPcia;
  String descripcionCodPcia;
  int codCdad;
  String descripcionCodCdad;
  String codPostal;
  int codigoBarrio;
  String descripcionCodigoBarrio;
  String domicilio;
  String nroPuerta;
  String piso;
  String depto;
  String torre;
  String sector;
  String telefono;
  String email;
  String fechaAlta;
  String fechaBaja;
  String estado;
  String fechaUltCbioEstado;
  String observacion;
  String documentacionOK;
  String latitud;
  String longitud;
  String latitudSEXA;
  String longitudSEXA;
  String tipoLogin;
  String connUsername;
  String connPassword;
  String wiFiSSID;
  String wiFiPassword;
  TipoInstalacionModel tipoInstalacion;
  int oltID;
  int ponID;
  int onuID;
  int equipmentID;
  String equipmentSN;
  int nroCpbtePedidosVT;
  int nroCpbteBajasVT;
  int nroCpbteTicketRemedyBaja;
  int nroCpbteTicketRemedyAltaOperativa;
  int nroCpbteTicketRemedyVisitaTecnica;
  int nroCpbteTicketRemedyCambioDePlan;
  String fromType;
  String lockHash; // Hash for record lock
  String environment;

  /// Objects
  TableEmpresaModel eEmpresa;
  TableClienteV2Model eCliente;
  TablePaisModel ePais;
  TableProvinciaModel eProvincia;
  TableCiudadModel eCiudad;
  TableDetBarrioCiudadModel eBarrioCiudad;
  TableNASModel eNAS;
  PONModel ePON;
  ONUModel eONU;
  late List<CommonParamKeyValue<TableDetServicioDATOSClienteV2Model>>
      pDetServiciosDATOSClientes;
  late CommonParamKeyValue<TableDetServicioDATOSClienteV2Model>
      pDetServicioClienteDATOS;
  late List<CommonParamKeyValue<TableClienteV2Model>> pClientes;
  late CommonParamKeyValue<TableClienteV2Model> pCliente;
  late List<CommonParamKeyValue<TablePaisModel>> pPaises;
  late CommonParamKeyValue<TablePaisModel> pPais;
  late List<CommonParamKeyValue<TableProvinciaModel>> pProvincias;
  late CommonParamKeyValue<TableProvinciaModel> pProvincia;
  late List<CommonParamKeyValue<TableCiudadModel>> pCiudades;
  late CommonParamKeyValue<TableCiudadModel> pCiudad;
  late List<CommonParamKeyValue<TableDetBarrioCiudadModel>> pDetBarriosCiudad;
  late CommonParamKeyValue<TableDetBarrioCiudadModel> pBerrioCiudad;

  late List<CommonParamKeyValue<TipoLoginModel>> pTiposLogin;
  late CommonParamKeyValue<TipoLoginModel> pTipoLogin;
  List<CommonParamKeyValue> pTiposServicios = [
    CommonParamKeyValue.fromStandard(
      key: 'HOGAR',
      value: 'HOGAR',
      title: 'Hogar',
      subTitle: 'Servicio para el hogar',
    ),
    CommonParamKeyValue.fromStandard(
      key: 'EMPRESA',
      value: 'EMPRESA',
      title: 'Empresa',
      subTitle: 'Servicio para empresas',
    ),
  ];

  List<CommonParamKeyValue<TipoInstalacionModel>> pTiposInstalacion =
      TipoInstalacionModel.values
          .map(
            (e) => CommonParamKeyValue.fromType(tObject: e),
          )
          .toList();
  late CommonParamKeyValue<TipoInstalacionModel> pTipoInstalacion;

  List<CommonParamKeyValue<TableNASModel>> pNASes = [];
  late CommonParamKeyValue<TableNASModel> pNAS;
  List<CommonParamKeyValue<PONModel>> pPONes = [];
  late CommonParamKeyValue<PONModel> pPON;
  List<CommonParamKeyValue<ONUModel>> pONUes = [];
  late CommonParamKeyValue<ONUModel> pONU;

  TableDetServicioDATOSClienteV2Model._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.tipoCliente,
    required this.codClie,
    required this.razonSocialCodClie,
    required this.nroServicio,
    required this.nroUnico,
    required this.tipoServicio,
    required this.codPais,
    required this.descripcionCodPais,
    required this.codPcia,
    required this.descripcionCodPcia,
    required this.codCdad,
    required this.descripcionCodCdad,
    required this.codPostal,
    required this.codigoBarrio,
    required this.descripcionCodigoBarrio,
    required this.domicilio,
    required this.nroPuerta,
    required this.piso,
    required this.depto,
    required this.torre,
    required this.sector,
    required this.telefono,
    required this.email,
    required this.fechaAlta,
    required this.fechaBaja,
    required this.estado,
    required this.fechaUltCbioEstado,
    required this.observacion,
    required this.documentacionOK,
    required this.latitud,
    required this.longitud,
    required this.latitudSEXA,
    required this.longitudSEXA,
    required this.tipoLogin,
    required this.connUsername,
    required this.connPassword,
    required this.wiFiSSID,
    required this.wiFiPassword,
    required this.tipoInstalacion,
    required this.oltID,
    required this.ponID,
    required this.onuID,
    required this.equipmentID,
    required this.equipmentSN,
    required this.nroCpbtePedidosVT,
    required this.nroCpbteBajasVT,
    required this.nroCpbteTicketRemedyBaja,
    required this.nroCpbteTicketRemedyAltaOperativa,
    required this.nroCpbteTicketRemedyVisitaTecnica,
    required this.nroCpbteTicketRemedyCambioDePlan,
    required this.fromType,
    required this.lockHash,
    required this.environment,
    required this.eEmpresa,
    required this.eCliente,
    required this.ePais,
    required this.eProvincia,
    required this.eCiudad,
    required this.eBarrioCiudad,
    required this.eNAS,
    required this.ePON,
    required this.eONU,
  }) {
    /// Objects
    pCliente = CommonParamKeyValue.fromType(tObject: eCliente);
    pClientes = [pCliente];

    pDetServicioClienteDATOS = CommonParamKeyValue.fromType(tObject: this);
    pDetServiciosDATOSClientes = [pDetServicioClienteDATOS];
    var cPais = CommonParamKeyValue.fromType(
      tObject: ePais,
    );
    pPaises = [cPais];
    pPais = cPais;

    var cProvincia = CommonParamKeyValue.fromType(
      tObject: eProvincia,
    );
    pProvincias = [cProvincia];
    pProvincia = cProvincia;

    var cCiudad = CommonParamKeyValue.fromType(
      tObject: eCiudad,
    );
    pCiudades = [cCiudad];
    pCiudad = cCiudad;

    var cBarrioCiudad = CommonParamKeyValue.fromType(
      tObject: eBarrioCiudad,
    );
    pDetBarriosCiudad = [cBarrioCiudad];
    pBerrioCiudad = cBarrioCiudad;

    pTiposLogin = TipoLoginModel.values
        .map(
          (e) => CommonParamKeyValue.fromType(tObject: e),
        )
        .toList();
    pTipoLogin = CommonParamKeyValue.fromType(
      tObject: TipoLoginModel.fromKey(tipoLogin),
    );

    pTipoInstalacion = CommonParamKeyValue.fromType(
      tObject: tipoInstalacion,
    );

    pNAS = CommonParamKeyValue.fromType(
      tObject: eNAS,
    );
    pNASes = [pNAS];

    pPON = CommonParamKeyValue.fromType(
      tObject: ePON,
    );
    pPONes = [pPON];

    pONU = CommonParamKeyValue.fromType(
      tObject: eONU,
    );
    pONUes = [pONU];
  }

  /// If we create an object from default
  ///
  factory TableDetServicioDATOSClienteV2Model.fromDefault({
    required TableEmpresaModel pEmpresa,
    required TableClienteV2Model pCliente,
  }) {
    var codEmp = pEmpresa.codEmp;
    var razonSocialCodEmp = pEmpresa.razonSocial;
    var tipoCliente = pCliente.tipoCliente;
    var codClie = pCliente.codClie;
    var razonSocialCodClie = pCliente.razonSocial;
    var nroServicio = -1;
    var nroUnico = -1;
    var tipoServicio = "HOGAR";
    var codPais = 0;
    var descripcionCodPais = "";
    var codPcia = 0;
    var descripcionCodPcia = "";
    var codCdad = 0;
    var descripcionCodCdad = "";
    var codPostal = "";
    var codigoBarrio = 0;
    var descripcionCodigoBarrio = "";
    var domicilio = "";
    var nroPuerta = "";
    var piso = "";
    var depto = "";
    var torre = "";
    var sector = "";
    var telefono = "";
    var email = "";
    var fechaAlta = "";
    var fechaBaja = "";
    var estado = "";
    var fechaUltCbioEstado = "";
    var observacion = "";
    var documentacionOK = "";
    var latitud = "";
    var longitud = "";
    var latitudSEXA = "";
    var longitudSEXA = "";
    var tipoLogin = "";
    var connUsername = "";
    var connPassword = "";
    var wiFiSSID = "";
    var wiFiPassword = "";
    var tipoInstalacion = TipoInstalacionModel.unknown;
    var oltID = 0;
    var ponID = 0;
    var onuID = 0;
    var equipmentID = 0;
    var equipmentSN = "";
    var nroCpbtePedidosVT = 0;
    var nroCpbteBajasVT = 0;
    var nroCpbteTicketRemedyBaja = 0;
    var nroCpbteTicketRemedyAltaOperativa = 0;
    var nroCpbteTicketRemedyVisitaTecnica = 0;
    var nroCpbteTicketRemedyCambioDePlan = 0;
    var fromType = "default";
    var lockHash = "";
    var environment = pEmpresa.environment;
    var eEmpresa = pEmpresa;
    var ePais = TablePaisModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eCliente = pCliente;

    var eProvincia = TableProvinciaModel.fromDefault(
      pEmpresa: pEmpresa,
      pPais: ePais,
    );
    var eCiudad = TableCiudadModel.fromDefault(
      pEmpresa: pEmpresa,
      pPais: ePais,
      pProvincia: eProvincia,
    );
    var eBarrioCiudad = TableDetBarrioCiudadModel.fromDefault(
      pEmpresa: pEmpresa,
      pPais: ePais,
      pProvincia: eProvincia,
      pCiudad: eCiudad,
    );
    var eNAS = TableNASModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var ePON = PONModel.fromDefault(
      pNASId: eNAS,
    );
    var eONU = ONUModel.fromDefault(
      pPONId: ePON,
    );

    return TableDetServicioDATOSClienteV2Model._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocialCodClie: razonSocialCodClie,
      nroServicio: nroServicio,
      nroUnico: nroUnico,
      tipoServicio: tipoServicio,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codPostal: codPostal,
      codigoBarrio: codigoBarrio,
      descripcionCodigoBarrio: descripcionCodigoBarrio,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      torre: torre,
      sector: sector,
      telefono: telefono,
      email: email,
      fechaAlta: fechaAlta,
      fechaBaja: fechaBaja,
      estado: estado,
      fechaUltCbioEstado: fechaUltCbioEstado,
      observacion: observacion,
      documentacionOK: documentacionOK,
      latitud: latitud,
      longitud: longitud,
      latitudSEXA: latitudSEXA,
      longitudSEXA: longitudSEXA,
      tipoLogin: tipoLogin,
      connUsername: connUsername,
      connPassword: connPassword,
      wiFiSSID: wiFiSSID,
      wiFiPassword: wiFiPassword,
      tipoInstalacion: tipoInstalacion,
      oltID: oltID,
      ponID: ponID,
      onuID: onuID,
      equipmentID: equipmentID,
      equipmentSN: equipmentSN,
      nroCpbtePedidosVT: nroCpbtePedidosVT,
      nroCpbteBajasVT: nroCpbteBajasVT,
      nroCpbteTicketRemedyBaja: nroCpbteTicketRemedyBaja,
      nroCpbteTicketRemedyAltaOperativa: nroCpbteTicketRemedyAltaOperativa,
      nroCpbteTicketRemedyVisitaTecnica: nroCpbteTicketRemedyVisitaTecnica,
      nroCpbteTicketRemedyCambioDePlan: nroCpbteTicketRemedyCambioDePlan,
      fromType: fromType,
      lockHash: lockHash,
      environment: environment,
      eEmpresa: eEmpresa,
      eCliente: eCliente,
      ePais: ePais,
      eProvincia: eProvincia,
      eCiudad: eCiudad,
      eBarrioCiudad: eBarrioCiudad,
      eNAS: eNAS,
      ePON: ePON,
      eONU: eONU,
    );
  }

  /// If we create an object from key
  ///
  factory TableDetServicioDATOSClienteV2Model.fromKey({
    required TableEmpresaModel pEmpresa,
    required TableClienteV2Model pCliente,
    required int pNroServicio,
    required String pTipoServicio,
    required int pNroUnico,
  }) {
    var codEmp = pEmpresa.codEmp;
    var razonSocialCodEmp = pEmpresa.razonSocial;
    var tipoCliente = pCliente.tipoCliente;
    var codClie = pCliente.codClie;
    var razonSocialCodClie = pCliente.razonSocial;
    var nroServicio = pNroServicio;
    var nroUnico = pNroServicio;
    var tipoServicio = pTipoServicio;
    var codPais = 0;
    var descripcionCodPais = "";
    var codPcia = 0;
    var descripcionCodPcia = "";
    var codCdad = 0;
    var descripcionCodCdad = "";
    var codPostal = "";
    var codigoBarrio = 0;
    var descripcionCodigoBarrio = "";
    var domicilio = "";
    var nroPuerta = "";
    var piso = "";
    var depto = "";
    var torre = "";
    var sector = "";
    var telefono = "";
    var email = "";
    var fechaAlta = "";
    var fechaBaja = "";
    var estado = "";
    var fechaUltCbioEstado = "";
    var observacion = "";
    var documentacionOK = "";
    var latitud = "";
    var longitud = "";
    var latitudSEXA = "";
    var longitudSEXA = "";
    var tipoLogin = "";
    var connUsername = "";
    var connPassword = "";
    var wiFiSSID = "";
    var wiFiPassword = "";
    var tipoInstalacion = TipoInstalacionModel.unknown;
    var oltID = 0;
    var ponID = 0;
    var onuID = 0;
    var equipmentID = 0;
    var equipmentSN = "";
    var nroCpbtePedidosVT = 0;
    var nroCpbteBajasVT = 0;
    var nroCpbteTicketRemedyBaja = 0;
    var nroCpbteTicketRemedyAltaOperativa = 0;
    var nroCpbteTicketRemedyVisitaTecnica = 0;
    var nroCpbteTicketRemedyCambioDePlan = 0;
    var fromType = "key";
    var lockHash = "";
    var environment = pEmpresa.environment;
    var eEmpresa = pEmpresa;
    var eCliente = TableClienteV2Model.fromDefault(pEmpresa: pEmpresa);
    var ePais = TablePaisModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eProvincia = TableProvinciaModel.fromDefault(
      pEmpresa: pEmpresa,
      pPais: ePais,
    );
    var eCiudad = TableCiudadModel.fromDefault(
      pEmpresa: pEmpresa,
      pPais: ePais,
      pProvincia: eProvincia,
    );
    var eBarrioCiudad = TableDetBarrioCiudadModel.fromDefault(
      pEmpresa: pEmpresa,
      pPais: ePais,
      pProvincia: eProvincia,
      pCiudad: eCiudad,
    );
    var eNAS = TableNASModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var ePON = PONModel.fromDefault(
      pNASId: eNAS,
    );
    var eONU = ONUModel.fromDefault(
      pPONId: ePON,
    );
    return TableDetServicioDATOSClienteV2Model._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocialCodClie: razonSocialCodClie,
      nroServicio: nroServicio,
      nroUnico: nroUnico,
      tipoServicio: tipoServicio,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codPostal: codPostal,
      codigoBarrio: codigoBarrio,
      descripcionCodigoBarrio: descripcionCodigoBarrio,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      torre: torre,
      sector: sector,
      telefono: telefono,
      email: email,
      fechaAlta: fechaAlta,
      fechaBaja: fechaBaja,
      estado: estado,
      fechaUltCbioEstado: fechaUltCbioEstado,
      observacion: observacion,
      documentacionOK: documentacionOK,
      latitud: latitud,
      longitud: longitud,
      latitudSEXA: latitudSEXA,
      longitudSEXA: longitudSEXA,
      tipoLogin: tipoLogin,
      connUsername: connUsername,
      connPassword: connPassword,
      wiFiSSID: wiFiSSID,
      wiFiPassword: wiFiPassword,
      tipoInstalacion: tipoInstalacion,
      oltID: oltID,
      ponID: ponID,
      onuID: onuID,
      equipmentID: equipmentID,
      equipmentSN: equipmentSN,
      nroCpbtePedidosVT: nroCpbtePedidosVT,
      nroCpbteBajasVT: nroCpbteBajasVT,
      nroCpbteTicketRemedyBaja: nroCpbteTicketRemedyBaja,
      nroCpbteTicketRemedyAltaOperativa: nroCpbteTicketRemedyAltaOperativa,
      nroCpbteTicketRemedyVisitaTecnica: nroCpbteTicketRemedyVisitaTecnica,
      nroCpbteTicketRemedyCambioDePlan: nroCpbteTicketRemedyCambioDePlan,
      fromType: fromType,
      lockHash: lockHash,
      environment: environment,
      eEmpresa: eEmpresa,
      eCliente: eCliente,
      ePais: ePais,
      eProvincia: eProvincia,
      eCiudad: eCiudad,
      eBarrioCiudad: eBarrioCiudad,
      eNAS: eNAS,
      ePON: ePON,
      eONU: eONU,
    );
  }

  /// If we create an object when noRecordFound
  ///
  factory TableDetServicioDATOSClienteV2Model.noRecordFound({
    required TableEmpresaModel pEmpresa,
    required TableClienteV2Model pCliente,
    String pFilter = "",
  }) {
    var tServicio = TableDetServicioDATOSClienteV2Model.fromDefault(
      pEmpresa: pEmpresa,
      pCliente: pCliente,
    );
    tServicio.nroServicio = -2;
    tServicio.nroUnico = -2;
    var filter = pFilter.isEmpty ? "" : "[$pFilter]";
    var razonSocialCodClie = "NO HAY REGISTRO(s) s/Filtro $filter";
    tServicio.razonSocialCodClie = razonSocialCodClie;
    tServicio.fromType = 'noRecordFound';
    tServicio.environment = pCliente.environment;
    return tServicio;
  }

  /// If we create an object from error
  ///
  factory TableDetServicioDATOSClienteV2Model.fromError({
    required TableEmpresaModel pEmpresa,
    required TableClienteV2Model pCliente,
    String pFilter = "",
  }) {
    var tServicio = TableDetServicioDATOSClienteV2Model.fromDefault(
      pEmpresa: pEmpresa,
      pCliente: pCliente,
    );
    tServicio.codEmp = pEmpresa.codEmp;
    var filter = pFilter.isEmpty ? "" : "[$pFilter]";
    var razonSocialCodClie = "NO HAY REGISTRO(s) s/error $filter";
    tServicio.razonSocialCodClie = razonSocialCodClie;
    tServicio.nroServicio = -3;
    tServicio.nroUnico = -3;
    tServicio.tipoServicio = "HOGAR";
    tServicio.codPais = pCliente.codPais;
    tServicio.descripcionCodPais = pCliente.descripcionCodPais;
    tServicio.codPcia = pCliente.codPcia;
    tServicio.descripcionCodPcia = pCliente.descripcionCodPcia;
    tServicio.codCdad = pCliente.codCdad;
    tServicio.descripcionCodCdad = pCliente.descripcionCodCdad;
    tServicio.codPostal = pCliente.codPostal;
    tServicio.codigoBarrio = pCliente.codigoBarrio;
    tServicio.descripcionCodigoBarrio = pCliente.descripcionCodigoBarrio;
    tServicio.domicilio = pCliente.domicilio;
    tServicio.nroPuerta = pCliente.nroPuerta;
    tServicio.piso = pCliente.piso;
    tServicio.depto = pCliente.depto;
    tServicio.torre = pCliente.torre;
    tServicio.sector = pCliente.sector;
    tServicio.telefono = pCliente.telefono;
    tServicio.email = pCliente.email;
    tServicio.fechaAlta = "0000-00-00";
    tServicio.fechaBaja = "0000-00-00";
    tServicio.estado = "Pendiente";
    tServicio.fechaUltCbioEstado = "0000-00-00";
    tServicio.observacion = "";
    tServicio.documentacionOK = "NO";
    tServicio.latitud = "";
    tServicio.longitud = "";
    tServicio.latitudSEXA = "";
    tServicio.longitudSEXA = "";

    tServicio.tipoLogin = "PPPoE";
    tServicio.pTipoLogin = CommonParamKeyValue.fromType(
      tObject: TipoLoginModel.fromKey(tServicio.tipoLogin),
    );
    tServicio.connUsername = "";
    tServicio.connPassword = "";
    tServicio.wiFiSSID = "";
    tServicio.wiFiPassword = "";
    tServicio.nroCpbtePedidosVT = 0;
    tServicio.nroCpbteBajasVT = 0;
    tServicio.nroCpbteTicketRemedyBaja = 0;
    tServicio.nroCpbteTicketRemedyAltaOperativa = 0;
    tServicio.nroCpbteTicketRemedyVisitaTecnica = 0;
    tServicio.nroCpbteTicketRemedyCambioDePlan = 0;

    tServicio.fromType = 'error';
    tServicio.environment = pCliente.environment;
    return tServicio;
  }

  /// If we create an object from "SELECCIONE UN SERVICIO"
  ///
  factory TableDetServicioDATOSClienteV2Model.fromSelectNroServicio({
    required TableEmpresaModel pEmpresa,
    required TableClienteV2Model pCliente,
    String pFilter = "",
  }) {
    var tServicio = TableDetServicioDATOSClienteV2Model.fromDefault(
      pEmpresa: pEmpresa,
      pCliente: pCliente,
    );
    tServicio.codEmp = pEmpresa.codEmp;
    tServicio.tipoCliente = pCliente.tipoCliente;
    tServicio.codClie = pCliente.codClie;
    var razonSocialCodClie = "SELECCIONE UN SERVICIO";
    tServicio.razonSocialCodClie = razonSocialCodClie;
    tServicio.nroServicio = 0;
    tServicio.nroUnico = 0;
    tServicio.tipoServicio = "HOGAR";
    tServicio.codPais = pCliente.codPais;
    tServicio.descripcionCodPais = pCliente.descripcionCodPais;
    tServicio.codPcia = pCliente.codPcia;
    tServicio.descripcionCodPcia = pCliente.descripcionCodPcia;
    tServicio.codCdad = pCliente.codCdad;
    tServicio.descripcionCodCdad = pCliente.descripcionCodCdad;
    tServicio.codPostal = pCliente.codPostal;
    tServicio.codigoBarrio = pCliente.codigoBarrio;
    tServicio.descripcionCodigoBarrio = pCliente.descripcionCodigoBarrio;
    tServicio.domicilio = pCliente.domicilio;
    tServicio.nroPuerta = pCliente.nroPuerta;
    tServicio.piso = pCliente.piso;
    tServicio.depto = pCliente.depto;
    tServicio.torre = pCliente.torre;
    tServicio.sector = pCliente.sector;
    tServicio.telefono = pCliente.telefono;
    tServicio.email = pCliente.email;
    tServicio.fechaAlta = CommonDateModel.fromNow().toEN();
    tServicio.fechaBaja = "0000-00-00";
    tServicio.estado = "Pendiente";
    tServicio.fechaUltCbioEstado = CommonDateModel.fromNow().toEN();
    tServicio.observacion = "";
    tServicio.documentacionOK = "SI";
    tServicio.latitud = "";
    tServicio.longitud = "";
    tServicio.latitudSEXA = "";
    tServicio.longitudSEXA = "";

    /// Credentials
    ///
    var userCredencials = generateCredentials(
      pEmpresa: pEmpresa,
      pCliente: pCliente,
      pPais: pCliente.ePais,
      pProvincia: pCliente.eProvincia,
      pCiudad: pCliente.eCiudad,
      pDetBarrioCiudad: pCliente.eBarrioCiudad,
      pNroServicio: 0,
    );
    tServicio.tipoLogin = userCredencials.tipoLogin;
    tServicio.connUsername = userCredencials.username;
    tServicio.connPassword = userCredencials.password;
    tServicio.wiFiSSID = userCredencials.wiFiSSID;
    tServicio.wiFiPassword = userCredencials.wiFiPassword;
    tServicio.nroCpbtePedidosVT = 0;
    tServicio.nroCpbteBajasVT = 0;
    tServicio.nroCpbteTicketRemedyBaja = 0;
    tServicio.nroCpbteTicketRemedyAltaOperativa = 0;
    tServicio.nroCpbteTicketRemedyVisitaTecnica = 0;
    tServicio.nroCpbteTicketRemedyCambioDePlan = 0;

    tServicio.fromType = 'SelectNroServicio';
    tServicio.environment = pCliente.environment;

    return tServicio;
  }

  /// If we create an object from default
  ///
  factory TableDetServicioDATOSClienteV2Model.fromNewNRoServicio({
    required TableEmpresaModel pEmpresa,
    required TableClienteV2Model pCliente,
    String pFilter = "",
    CommonClasesCpbteVT? pClaseCpbteVT,
  }) {
    var tServicio = TableDetServicioDATOSClienteV2Model.fromDefault(
      pEmpresa: pEmpresa,
      pCliente: pCliente,
    );
    tServicio.codEmp = pEmpresa.codEmp;
    tServicio.tipoCliente = pCliente.tipoCliente;
    tServicio.codClie = pCliente.codClie;
    var razonSocialCodClie = "NUEVO SERVICIO";
    tServicio.razonSocialCodClie = razonSocialCodClie;
    tServicio.nroServicio = 0;
    tServicio.nroUnico = 0;
    tServicio.tipoServicio = "HOGAR";
    tServicio.codPais = pCliente.codPais;
    tServicio.descripcionCodPais = pCliente.descripcionCodPais;
    tServicio.codPcia = pCliente.codPcia;
    tServicio.descripcionCodPcia = pCliente.descripcionCodPcia;
    tServicio.codCdad = pCliente.codCdad;
    tServicio.descripcionCodCdad = pCliente.descripcionCodCdad;
    tServicio.codPostal = pCliente.codPostal;
    tServicio.codigoBarrio = pCliente.codigoBarrio;
    tServicio.descripcionCodigoBarrio = pCliente.descripcionCodigoBarrio;
    tServicio.domicilio = pCliente.domicilio;
    tServicio.nroPuerta = pCliente.nroPuerta;
    tServicio.piso = pCliente.piso;
    tServicio.depto = pCliente.depto;
    tServicio.torre = pCliente.torre;
    tServicio.sector = pCliente.sector;
    tServicio.telefono = pCliente.telefono;
    tServicio.email = pCliente.email;
    tServicio.fechaAlta = CommonDateModel.fromNow().toEN();
    tServicio.fechaBaja = "0000-00-00";
    tServicio.estado = "Pendiente";
    tServicio.fechaUltCbioEstado = CommonDateModel.fromNow().toEN();
    tServicio.observacion = "";
    tServicio.documentacionOK = "SI";
    tServicio.latitud = "";
    tServicio.longitud = "";
    tServicio.latitudSEXA = "";
    tServicio.longitudSEXA = "";

    /// Credentials
    ///
    var userCredencials = generateCredentials(
      pEmpresa: pEmpresa,
      pCliente: pCliente,
      pPais: pCliente.ePais,
      pProvincia: pCliente.eProvincia,
      pCiudad: pCliente.eCiudad,
      pDetBarrioCiudad: pCliente.eBarrioCiudad,
      pNroServicio: 0,
    );
    tServicio.tipoLogin = userCredencials.tipoLogin;
    tServicio.pTipoLogin = CommonParamKeyValue.fromType(
      tObject: TipoLoginModel.fromKey(tServicio.tipoLogin),
    );
    tServicio.connUsername = userCredencials.username;
    tServicio.connPassword = userCredencials.password;
    tServicio.wiFiSSID = userCredencials.wiFiSSID;
    tServicio.wiFiPassword = userCredencials.wiFiPassword;
    tServicio.tipoInstalacion = TipoInstalacionModel.ftth;
    tServicio.pTipoInstalacion = CommonParamKeyValue.fromType(
      tObject: tServicio.tipoInstalacion,
    );
    tServicio.nroCpbtePedidosVT = 0;
    tServicio.nroCpbteBajasVT = 0;
    tServicio.nroCpbteTicketRemedyBaja = 0;
    tServicio.nroCpbteTicketRemedyAltaOperativa = 0;
    tServicio.nroCpbteTicketRemedyVisitaTecnica = 0;
    tServicio.nroCpbteTicketRemedyCambioDePlan = 0;

    tServicio.fromType = 'NewNroServicio';
    tServicio.environment = pCliente.environment;
    return tServicio;
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableDetServicioDATOSClienteV2Model fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    TableClienteV2Model? pCliente,
    int pVersion = 2,
  }) {
    pEmpresa ??= TableEmpresaModel.fromDefault();
    pCliente ??= TableClienteV2Model.fromDefault(
      pEmpresa: pEmpresa,
    );
    return TableDetServicioDATOSClienteV2Model.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: pEmpresa,
      pCliente: pCliente,
    );
  }

  /// If we create an object from default
  ///
  factory TableDetServicioDATOSClienteV2Model.fromJsonGral({
    required Map<String, dynamic> map,
    required int errorCode,
    required TableEmpresaModel pEmpresa,
    required TableClienteV2Model pCliente,
  }) {
    String functionName = "fromJson";
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';

    var tServicio = TableDetServicioDATOSClienteV2Model.fromDefault(
      pEmpresa: pEmpresa,
      pCliente: pCliente,
    );
    tServicio.codEmp = -1;
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
    tServicio.codEmp = int.parse(map['CodEmp'].toString());
    tServicio.razonSocialCodEmp = map['RazonSocialCodEmp'].toString();

    tServicio.tipoCliente = map['TipoCliente'].toString();
    tServicio.codClie = -1;
    if (int.tryParse(map['CodClie'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'CodClie',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.codClie = int.parse(map['CodClie'].toString());
    tServicio.razonSocialCodClie = map['RazonSocialCodClie'].toString();

    tServicio.nroServicio = -1;
    if (int.tryParse(map['NroServicio'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'NroServicio',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.nroServicio = int.parse(map['NroServicio'].toString());

    tServicio.nroUnico = -1;
    if (int.tryParse(map['NroUnico'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'NroUnico',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.nroUnico = int.parse(map['NroUnico'].toString());

    tServicio.codPais = -1;
    if (int.tryParse(map['CodPais'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'CodPais',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.codPais = int.parse(map['CodPais'].toString());
    tServicio.descripcionCodPais = map['DescripcionCodPais'].toString();

    tServicio.codPcia = -1;
    if (int.tryParse(map['CodPcia'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'CodPcia',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.codPcia = int.parse(map['CodPcia'].toString());
    tServicio.descripcionCodPcia = map['DescripcionCodPcia'].toString();

    tServicio.codCdad = -1;
    if (int.tryParse(map['CodCdad'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'CodCdad',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.codCdad = int.parse(map['CodCdad'].toString());
    tServicio.descripcionCodCdad = map['DescripcionCodCdad'].toString();
    tServicio.codPostal = map['CodPostal'].toString();

    tServicio.codigoBarrio = -1;
    if (int.tryParse(map['CodigoBarrio'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'CodigoBarrio',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.codigoBarrio = int.parse(map['CodigoBarrio'].toString());
    tServicio.descripcionCodigoBarrio =
        map['DescripcionCodigoBarrio'].toString();

    tServicio.domicilio = map['Domicilio'].toString();
    tServicio.nroPuerta = map['NroPuerta'].toString();
    tServicio.piso = map['Piso'].toString();
    tServicio.depto = map['Depto'].toString();
    tServicio.torre = map['Torre'].toString();
    tServicio.sector = map['Sector'].toString();
    tServicio.telefono = map['Telefono'].toString();
    tServicio.email = map['EMail'].toString();
    tServicio.fechaAlta = map['FechaAltaSQL'].toString();
    tServicio.fechaBaja = map['FechaBajaSQL'].toString();
    tServicio.estado = map['Estado'].toString();
    tServicio.fechaUltCbioEstado = map['FechaUltCbioEstadoSQL'].toString();
    tServicio.observacion = map['Observacion'].toString();
    tServicio.documentacionOK = map['DocumentacionOK'].toString();
    tServicio.latitud = map['Latitud'].toString();
    tServicio.longitud = map['Longitud'].toString();
    tServicio.latitudSEXA = map['LatitudSEXA'].toString();
    tServicio.longitudSEXA = map['LongitudSEXA'].toString();
    tServicio.tipoLogin = map['TipoLogin'].toString();
    tServicio.pTipoLogin = CommonParamKeyValue.fromType(
      tObject: TipoLoginModel.fromKey(tServicio.tipoLogin),
    );
    tServicio.connUsername = map['ConnUsername'].toString();
    tServicio.connPassword = map['ConnPassword'].toString();
    tServicio.wiFiSSID = map['WiFiSSID'].toString();
    tServicio.wiFiPassword = map['WiFiPassword'].toString();
    tServicio.tipoInstalacion = TipoInstalacionModel.fromKey(
      map['TipoInstalacion'].toString(),
    );
    tServicio.oltID = -1;
    if (int.tryParse(map['OLTID'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'OLTID',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.oltID = int.parse(map['OLTID'].toString());
    tServicio.ponID = -1;
    if (int.tryParse(map['PONID'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'PONID',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.ponID = int.parse(map['PONID'].toString());
    tServicio.onuID = -1;
    if (int.tryParse(map['ONUID'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'ONUID',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.onuID = int.parse(map['ONUID'].toString());
    tServicio.equipmentID = -1;
    if (int.tryParse(map['EquipmentID'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'EquipmentID',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.equipmentID = int.parse(map['EquipmentID'].toString());
    tServicio.equipmentSN = map['EquipmentSN'].toString();

    tServicio.nroCpbtePedidosVT = -1;
    if (int.tryParse(map['NroCpbtePedidosVT'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'NroCpbtePedidosVT',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.nroCpbtePedidosVT =
        int.parse(map['NroCpbtePedidosVT'].toString());

    tServicio.nroCpbteBajasVT = -1;
    if (int.tryParse(map['NroCpbteBajasVT'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'NroCpbteBajasVT',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.nroCpbteBajasVT = int.parse(map['NroCpbteBajasVT'].toString());

    tServicio.nroCpbteTicketRemedyBaja = -1;
    if (int.tryParse(map['NroCpbteTicketRemedyBaja'].toString()) == null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'NroCpbteTicketRemedyBaja',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.nroCpbteTicketRemedyBaja =
        int.parse(map['NroCpbteTicketRemedyBaja'].toString());

    tServicio.nroCpbteTicketRemedyAltaOperativa = -1;
    if (int.tryParse(map['NroCpbteTicketRemedyAltaOperativa'].toString()) ==
        null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'NroCpbteTicketRemedyAltaOperativa',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.nroCpbteTicketRemedyAltaOperativa =
        int.parse(map['NroCpbteTicketRemedyAltaOperativa'].toString());

    tServicio.nroCpbteTicketRemedyVisitaTecnica = -1;
    if (int.tryParse(map['NroCpbteTicketRemedyVisitaTecnica'].toString()) ==
        null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'NroCpbteTicketRemedyVisitaTecnica',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.nroCpbteTicketRemedyVisitaTecnica =
        int.parse(map['NroCpbteTicketRemedyVisitaTecnica'].toString());

    tServicio.nroCpbteTicketRemedyCambioDePlan = -1;
    if (int.tryParse(map['NroCpbteTicketRemedyCambioDePlan'].toString()) ==
        null) {
      throw ErrorHandler(
        errorCode: 300100,
        errorDsc: 'Can\'t be empty.$supportMessage',
        propertyName: 'NroCpbteTicketRemedyCambioDePlan',
        propertyValue: null,
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    tServicio.nroCpbteTicketRemedyCambioDePlan =
        int.parse(map['NroCpbteTicketRemedyCambioDePlan'].toString());

    tServicio.fromType = "Json";
    tServicio.environment = map['Environment'].toString();

    /// Objects
    ///
    if (pEmpresa.environment == 'default') {
      pEmpresa.codEmp = tServicio.codEmp;
      pEmpresa.razonSocial = tServicio.razonSocialCodEmp;
      pEmpresa.environment = tServicio.environment;
    }
    var eEmpresa = pEmpresa;
    if (map['Empresa'] != null) {
      eEmpresa = TableEmpresaModel.fromJson(map["Empresa"]);
    } else {
      eEmpresa = TableEmpresaModel.fromKey(
        pCodEmp: tServicio.codEmp,
        pRazonSocial: tServicio.razonSocialCodEmp,
        pEnvironment: tServicio.environment,
      );
    }
    tServicio.eEmpresa = eEmpresa;

    var eCliente = pCliente;
    if (map['Cliente'] != null) {
      eCliente = TableClienteV2Model.fromJson(
        map: map["Cliente"],
        errorCode: errorCode,
        pEmpresa: eEmpresa,
      );
    } else {
      eCliente = TableClienteV2Model.fromKey(
        pEmpresa: eEmpresa,
        pCodClie: tServicio.codClie,
        pTipoCliente: tServicio.tipoCliente,
        pRazonSocial: tServicio.razonSocialCodClie,
      );
    }
    tServicio.eCliente = eCliente;

    var ePais = TablePaisModel.fromKey(
      pEmpresa: pEmpresa,
      pCodPais: tServicio.codPais,
      pDescripcion: tServicio.descripcionCodPais,
      pEnvironment: tServicio.environment,
    );
    if (map['Pais'] != null) {
      ePais = TablePaisModel.fromJson(
        map: map["Pais"],
        errorCode: errorCode,
        pEmpresa: eEmpresa,
      );
    }
    tServicio.ePais = ePais;

    var eProvincia = TableProvinciaModel.fromKey(
      pEmpresa: pEmpresa,
      pPais: ePais,
      pCodPcia: tServicio.codPcia,
      pDescripcion: tServicio.descripcionCodPcia,
      pEnvironment: tServicio.environment,
    );
    if (map['Provincia'] != null) {
      eProvincia = TableProvinciaModel.fromJson(
        map: map["Provincia"],
        errorCode: errorCode,
        pEmpresa: eEmpresa,
        pPais: ePais,
      );
    }
    tServicio.eProvincia = eProvincia;

    var eCiudad = TableCiudadModel.fromKey(
      pEmpresa: pEmpresa,
      pPais: ePais,
      pProvincia: eProvincia,
      pCodCdad: tServicio.codCdad,
      pDescripcion: tServicio.descripcionCodCdad,
      pEnvironment: tServicio.environment,
    );
    if (map['Ciudad'] != null) {
      eCiudad = TableCiudadModel.fromJson(
        map: map["Ciudad"],
        errorCode: errorCode,
        pEmpresa: eEmpresa,
        pPais: ePais,
        pProvincia: eProvincia,
      );
    }
    tServicio.eCiudad = eCiudad;

    var eBarrioCiudad = TableDetBarrioCiudadModel.fromKey(
      pEmpresa: pEmpresa,
      pPais: ePais,
      pProvincia: eProvincia,
      pCiudad: eCiudad,
      pCodigoBarrio: tServicio.codigoBarrio,
      pDescripcion: tServicio.descripcionCodigoBarrio,
      pEnvironment: tServicio.environment,
    );
    if (map['BarrioCiudad'] != null) {
      eBarrioCiudad = TableDetBarrioCiudadModel.fromJson(
        map: map["BarrioCiudad"],
        errorCode: errorCode,
        pEmpresa: eEmpresa,
        pPais: ePais,
        pProvincia: eProvincia,
        pCiudad: eCiudad,
      );
    }
    tServicio.eBarrioCiudad = eBarrioCiudad;

    var eNAS = TableNASModel.fromKey(
      pEmpresa: pEmpresa,
      id: tServicio.oltID,
      nasName: tServicio.oltID.toString(),
      shortName: tServicio.oltID.toString(),
    );
    if (map['NAS'] != null) {
      eNAS = TableNASModel.fromJson(
        map: map["NAS"],
        errorCode: errorCode,
      );
    }
    tServicio.eNAS = eNAS;
    tServicio.pNAS = CommonParamKeyValue.fromType(
      tObject: eNAS,
    );
    tServicio.pNASes = [tServicio.pNAS];

    PONModel ePON;
    if (map['PON'] != null) {
      ePON = PONModel.fromJson(
        map: map["PON"],
      );
    } else if (tServicio.ponID == 0) {
      ePON = PONModel.fromSelectRecord(
        pNASId: eNAS,
      );
    } else if (tServicio.ponID > 0) {
      ePON = PONModel.fromKey(
        pNASId: eNAS,
        slot: 0,
        id: tServicio.ponID,
      );
    } else {
      ePON = PONModel.fromDefault(
        pNASId: eNAS,
      );
    }
    tServicio.ePON = ePON;
    tServicio.pPON = CommonParamKeyValue.fromType(
      tObject: ePON,
    );
    tServicio.pPONes = [tServicio.pPON];

    ONUModel eONU;
    if (map['ONU'] != null) {
      eONU = ONUModel.fromJson(
        map: map["ONU"],
      );
    } else if (tServicio.onuID == 0) {
      eONU = ONUModel.fromSelectRecord(
        pPONId: ePON,
      );
    } else if (tServicio.onuID > 0) {
      eONU = ONUModel.fromKey(
        pPONId: ePON,
        pIndex: tServicio.onuID,
      );
    } else {
      eONU = ONUModel.fromDefault(
        pPONId: ePON,
      );
    }
    tServicio.eONU = eONU;
    tServicio.pONU = CommonParamKeyValue.fromType(
      tObject: eONU,
    );
    tServicio.pONUes = [tServicio.pONU];

    return tServicio;
  }

  /// Object toJson standard
  @override
  Map<String, dynamic> toJson() {
    return {
      'CodEmp': codEmp,
      'TazonSocialCodEmp': razonSocialCodEmp,
      'TipoCliente': tipoCliente,
      'CodClie': codClie,
      'RazonSocialCodClie': razonSocialCodClie,
      'NroServicio': nroServicio,
      'NroUnico': nroUnico,
      'TipoServicio': tipoServicio,
      'CodPais': codPais,
      'DescripcionCodPais': descripcionCodPais,
      'CodPcia': codPcia,
      'DescripcionCodPcia': descripcionCodPcia,
      'CodCdad': codCdad,
      'DescripcionCodCdad': descripcionCodCdad,
      'CodPostal': codPostal,
      'CodigoBarrio': codigoBarrio,
      'DescripcionCodigoBarrio': descripcionCodigoBarrio,
      'Domicilio': domicilio,
      'NroPuerta': nroPuerta,
      'Piso': piso,
      'Depto': depto,
      'Torre': torre,
      'Sector': sector,
      'Telefono': telefono,
      'Email': email,
      'FechaAlta': fechaAlta,
      'FechaBaja': fechaBaja,
      'Estado': estado,
      'FechaUltCbioEstado': fechaUltCbioEstado,
      'Observacion': observacion,
      'DocumentacionOK': documentacionOK,
      'Latitud': latitud,
      'Longitud': longitud,
      'LatitudSEXA': latitudSEXA,
      'LongitudSEXA': longitudSEXA,
      'TipoLogin': tipoLogin,
      'ConnUsername': connUsername,
      'ConnPassword': connPassword,
      'WiFiSSID': wiFiSSID,
      'WiFiPassword': wiFiPassword,
      'TipoInstalacion': tipoInstalacion.key,
      'OLTID': oltID,
      'PONID': ponID,
      'ONUID': onuID,
      'EquipmentID': equipmentID,
      'EquipmentSN': equipmentSN,
      'NroCpbtePedidosVT': nroCpbtePedidosVT,
      'NroCpbteBajasVT': nroCpbteBajasVT,
      'NroCpbteTicketRemedyBaja': nroCpbteTicketRemedyBaja,
      'NroCpbteTicketRemedyAltaOperativa': nroCpbteTicketRemedyAltaOperativa,
      'NroCpbteTicketRemedyVisitaTecnica': nroCpbteTicketRemedyVisitaTecnica,
      'NroCpbteTicketRemedyCambioDePlan': nroCpbteTicketRemedyCambioDePlan,
      'FromType': fromType,
      'LockHash': lockHash,
      'Environment': environment,
      'EEmpresa': eEmpresa,
      'ECliente': eCliente,
      'EPais': ePais,
      'EProvincia': eProvincia,
      'ECiudad': eCiudad,
      'EBarrioCiudad': eBarrioCiudad,
      'ENAS': eNAS,
      'EPON': ePON,
      'EONU': eONU,
    };
  }

  /// Object toMap standard
  @override
  Map<String, dynamic> toMap() {
    return {
      'codEmp': codEmp,
      'razonSocialCodEmp': razonSocialCodEmp,
      'tipoCliente': tipoCliente,
      'codClie': codClie,
      'razonSocialCodClie': razonSocialCodClie,
      'nroServicio': nroServicio,
      'nroUnico': nroUnico,
      'tipoServicio': tipoServicio,
      'codPais': codPais,
      'descripcionCodPais': descripcionCodPais,
      'codPcia': codPcia,
      'descripcionCodPcia': descripcionCodPcia,
      'codCdad': codCdad,
      'descripcionCodCdad': descripcionCodCdad,
      'codPostal': codPostal,
      'codigoBarrio': codigoBarrio,
      'descripcionCodigoBarrio': descripcionCodigoBarrio,
      'domicilio': domicilio,
      'nroPuerta': nroPuerta,
      'piso': piso,
      'depto': depto,
      'torre': torre,
      'sector': sector,
      'telefono': telefono,
      'email': email,
      'fechaAlta': fechaAlta,
      'fechaBaja': fechaBaja,
      'estado': estado,
      'fechaUltCbioEstado': fechaUltCbioEstado,
      'observacion': observacion,
      'documentacionOK': documentacionOK,
      'latitud': latitud,
      'longitud': longitud,
      'latitudSEXA': latitudSEXA,
      'longitudSEXA': longitudSEXA,
      'tipoLogin': tipoLogin,
      'connUsername': connUsername,
      'connPassword': connPassword,
      'wiFiSSID': wiFiSSID,
      'wiFiPassword': wiFiPassword,
      'tipoInstalacion': tipoInstalacion.key,
      'oltID': oltID,
      'ponID': ponID,
      'onuID': onuID,
      'equipmentID': equipmentID,
      'equipmentSN': equipmentSN,
      'nroCpbtePedidosVT': nroCpbtePedidosVT,
      'nroCpbteBajasVT': nroCpbteBajasVT,
      'nroCpbteTicketRemedyBaja': nroCpbteTicketRemedyBaja,
      'nroCpbteTicketRemedyAltaOperativa': nroCpbteTicketRemedyAltaOperativa,
      'nroCpbteTicketRemedyVisitaTecnica': nroCpbteTicketRemedyVisitaTecnica,
      'nroCpbteTicketRemedyCambioDePlan': nroCpbteTicketRemedyCambioDePlan,
      'fromType': fromType,
      'lockHash': lockHash,
      'environment': environment,
      'eEmpresa': eEmpresa,
      'eCliente': eCliente,
      'ePais': ePais,
      'eProvincia': eProvincia,
      'eCiudad': eCiudad,
      'eBarrioCiudad': eBarrioCiudad,
      'eNAS': eNAS,
      'ePON': ePON,
      'eONU': eONU,
    };
  }

  String getDomicilioCompleto() {
    var rDomicilio = "";
    var pCalleNro = '$domicilio Nº $nroPuerta ';
    var pPiso = piso != '' ? 'Piso: $piso ' : '';
    var pDepto = depto != '' ? 'Depto: $depto ' : '';
    var pTorre = torre != '' ? 'Torre: $torre ' : '';
    var pSector = sector != '' ? 'Sector: $sector ' : '';
    rDomicilio = '$pCalleNro$pPiso$pDepto$pTorre$pSector';
    return rDomicilio;
  }

  String getDomicilioHeader() {
    return getDomicilioCompleto();
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TableDetServicioDATOSClienteV2Model) return false;

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
  String get dropDownAvatar => "";

  @override
  String get dropDownItemAsString =>
      '${nroServicio.toString().padLeft(6, '0')} - $razonSocialCodClie';

  @override
  String get dropDownKey => nroServicio.toString();

  /// Este valor es el que se muestra como Title en el DropTextBox
  ///
  @override
  String get dropDownTitle => getDomicilioCompleto();

  /// Este valor es el que se muestra en el TextBox una vez seleccionado
  ///
  @override
  String get dropDownSubTitle {
    switch (fromType) {
      case "NewNroServicio":
        return razonSocialCodClie;
      case "error":
        return "ERROR DE DATOS";
      default:
        var rNroServicio =
            "${nroServicio.toString().padLeft(3, '0')} - ($estado)";
        switch (claseCpbteVT) {
          case CommonClasesCpbteVT.bajasVT:
            if (nroCpbteBajasVT > 0) {
              rNroServicio +=
                  ' Nº Baja ${nroCpbteBajasVT.toString().padLeft(5, '0')}';
            }
            break;
          case CommonClasesCpbteVT.pedidosVT:
            if (nroCpbtePedidosVT > 0) {
              rNroServicio +=
                  ' Nº Ped. ${nroCpbtePedidosVT.toString().padLeft(5, '0')}';
            }
            break;
          case CommonClasesCpbteVT.cambiosPlanVT:
            break;
          default:
            if (nroCpbtePedidosVT > 0) {
              rNroServicio +=
                  ' Nº Ped. ${nroCpbtePedidosVT.toString().padLeft(5, '0')}';
            }
        }
        return rNroServicio;
    }
  }

  /// Este valor es el que se muestra en el TextBox una vez seleccionado
  ///
  @override
  String get dropDownValue {
    switch (fromType) {
      case "NewNroServicio":
        return razonSocialCodClie;
      case "error":
        return razonSocialCodClie;
      case "SelectNroServicio":
        return razonSocialCodClie;
      default:
        String rDropDownValue =
            'Nº ${nroServicio.toString().padLeft(3, '0')} - ($estado)';
        return rDropDownValue;
    }
  }

  @override
  bool get isDisabled {
    switch (claseCpbteVT) {
      case CommonClasesCpbteVT.cambiosPlanVT:
        switch (estado) {
          case "Activo":
          case "Suspendido":
            return false;
          default:
            return true;
        }
      case CommonClasesCpbteVT.bajasVT:
        if (nroCpbteBajasVT > 0) {
          return true;
        }
        break;
      case CommonClasesCpbteVT.pedidosVT:
        if (nroCpbtePedidosVT > 0) {
          return true;
        }
        break;
      default:
    }
    return false;
  }

  @override
  String get textOnDisabled {
    switch (claseCpbteVT) {
      case CommonClasesCpbteVT.cambiosPlanVT:
        return "NO APTO";
      default:
        return "";
    }
  }

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({required String searchText}) {
    throw UnimplementedError();
  }

  @override
  CommonParamKeyValueCapable fromDefault() {
    throw UnimplementedError();
  }

  /// filterSearchFromDropDownByNroServicioDATOS
  ///
  ///
  Future<List<CommonParamKeyValue<TableDetServicioDATOSClienteV2Model>>>
      filterSearchFromDropDownByNroServicioDATOS({
    required String searchText,
    required WidgetRef wRef,
    CommonGenericProcedureParamsModel? pParams,
  }) async {
    String funcionName = "$runtimeType";
    developer.log(
        "DEBUG_7888 DropDownNroServicio eCliente - ${eCliente.tipoCliente} - ${eCliente.codClie} - ${eCliente.razonSocial}");
    developer.log(
        "DEBUG_7888 DropDownNroServicio eDetServicioDATOSClientes - $tipoCliente - $codClie - $razonSocialCodClie - $nroServicio - $nroUnico");
    // var eCliente = TableClienteV2Model.fromKey(
    //   pEmpresa: eEmpresa,
    //   pTipoCliente: tipoCliente,
    //   pCodClie: codClie,
    //   pRazonSocial: razonSocialCodClie,
    // );
    TableDetServicioDATOSClienteV2Model fEnteSelected = this;

    /// Obtengo los datos del servicio del back-end
    ///
    GenericDataModel<TableDetServicioDATOSClienteV2Model>
        pDataEnteServiciosClientesDATOS;
    String dThreadHashID = generateRandomUniqueHash();
    await wRef.read(notifierServiceProvider).mapThreadsToDataModels.set(
          key: dThreadHashID,
          value: GenericDataModel<TableDetServicioDATOSClienteV2Model>(
            wRef: wRef,
            debug: wRef.read(notifierServiceProvider).debug,
          ),
        );
    pDataEnteServiciosClientesDATOS = wRef
        .read(notifierServiceProvider)
        .mapThreadsToDataModels
        .get(dThreadHashID);
    pDataEnteServiciosClientesDATOS.threadID = dThreadHashID;
    pDataEnteServiciosClientesDATOS.pGlobalRequest = ConstRequests.viewRequest;
    pDataEnteServiciosClientesDATOS.pLocalRequest = ConstRequests.viewRequest;
    pDataEnteServiciosClientesDATOS.cEmpresa = eEmpresa;
    pDataEnteServiciosClientesDATOS.cEncRecord = this;
    pDataEnteServiciosClientesDATOS.fromJsonFunction =
        TableDetServicioDATOSClienteV2Model.fromJson;

    pDataEnteServiciosClientesDATOS.threadParams = {
      'SelectBy': 'KeyCliente',
      'CodEmp': eCliente.codEmp,
      'TipoCliente': eCliente.tipoCliente,
      'CodClie': eCliente.codClie,
      'IsEmpresaAggregated': true,
    };

    Map<String, dynamic> pLocalParams = {
      'SelectBy': 'KeyCliente',
      'CodEmp': eCliente.codEmp,
      'TipoCliente': eCliente.tipoCliente,
      'CodClie': eCliente.codClie,
      'IsEmpresaAggregated': true,
      'ActionRequest': "ViewRecord",
      'DBVersion': 2,
      'Search': searchText,
      'ClaseCpbte': claseCpbteVT,
    };
    // TableEmpresaModel eEmpresa = pEnteSelected.eEmpresa;
    var pGenericParams = GenericModel.fromDefault();
    pGenericParams.pTable = iDefaultTable();
    pGenericParams.pLocalParamsRequest = pLocalParams;

    ErrorHandler rFilteredRecords =
        await pDataEnteServiciosClientesDATOS.filterSearchFromDropDown(
      pParams: pGenericParams,
      pEnte: fEnteSelected,
    );
    if (rFilteredRecords.errorCode != 0) {
      /// Si hay error, entonces lo muestro
      /// y retorno el error
      rFilteredRecords.errorDsc =
          '''Error al obtener los datos de los servicios del cliente.
          Código de empresa: ${eEmpresa.codEmp}
          Tipo de cliente: ${eCliente.tipoCliente}
          Código de cliente: ${eCliente.codClie}
          ${rFilteredRecords.errorDsc}
          ''';
      rFilteredRecords.stacktrace ??= StackTrace.current;
      var eEnteFiltered = TableDetServicioDATOSClienteV2Model.fromError(
        pEmpresa: eEmpresa,
        pCliente: eCliente,
        pFilter: searchText,
      );
      var rSetSelectedNroServicioDATOS = await setSelectedNroServicioDATOS(
        pFrom: "NroServicio",
        pEnteSelected: eEnteFiltered,
        pCascade: true,
        wRef: wRef,
      );
      if (rSetSelectedNroServicioDATOS.errorCode != 0) {
        /// Si hay error al establecer el servicio "por defecto", entonces lo muestro
        if (navigatorKey.currentContext != null) {
          await Navigator.of(navigatorKey.currentContext!).push(
            ModelGeneralPoPUpErrorMessageDialog(
              error: rSetSelectedNroServicioDATOS,
            ),
          );
        }
      }

      /// Si hay error, entonces lo muestro
      if (navigatorKey.currentContext != null) {
        await Navigator.of(navigatorKey.currentContext!).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: rFilteredRecords,
          ),
        );
      }
      return pDetServiciosDATOSClientes;
    }

    /// Si no hay error, entonces verifico que la data sea del tipo esperado
    if (rFilteredRecords.data is! List<TableDetServicioDATOSClienteV2Model>) {
      /// Si la data no es del tipo esperado, entonces retorno el error
      var rError = ErrorHandler(
        errorCode: 777,
        errorDsc: '''Error al obtener los datos del país seleccionado.
                  Esperábamos recibir List<TableDetServicioDATOSClienteV2Model>> y recibimos ${rFilteredRecords.data.runtimeType}
                  ''',
        propertyName: 'Data',
        propertyValue: rFilteredRecords.data,
        functionName: funcionName,
        className: className,
        stacktrace: StackTrace.current,
      );
      var eEnteFiltered = TableDetServicioDATOSClienteV2Model.fromError(
        pEmpresa: eEmpresa,
        pCliente: eCliente,
        pFilter: searchText,
      );
      var rSetSelectedNroServicioDATOS = await setSelectedNroServicioDATOS(
        pFrom: "NroServicio",
        pEnteSelected: eEnteFiltered,
        pCascade: true,
        wRef: wRef,
      );
      if (rSetSelectedNroServicioDATOS.errorCode != 0) {
        /// Si hay error al establecer el servicio "por defecto", entonces lo muestro
        if (navigatorKey.currentContext != null) {
          await Navigator.of(navigatorKey.currentContext!).push(
            ModelGeneralPoPUpErrorMessageDialog(
              error: rSetSelectedNroServicioDATOS,
            ),
          );
        }
      }

      /// Si hay error, entonces lo muestro
      if (navigatorKey.currentContext != null) {
        await Navigator.of(navigatorKey.currentContext!).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: rError,
          ),
        );
      }
      return pDetServiciosDATOSClientes;
    }
    //List<TableDetServicioDATOSClienteV2Model> data = [];
    CommonClasesCpbteVT lClaseCpbteVT =
        pParams?.claseCpbte ?? CommonClasesCpbteVT.unknown;

    /// Si no hay error, entonces verifico que la data sea del tipo esperado
    /// y que contenga al menos un registro
    var tData =
        rFilteredRecords.data as List<TableDetServicioDATOSClienteV2Model>;

    List<CommonParamKeyValue<TableDetServicioDATOSClienteV2Model>> rResults =
        [];
    if (pParams != null) {
      switch (pParams.claseCpbte) {
        case CommonClasesCpbteVT.ticketsRemedyVT:
          lClaseCpbteVT = CommonClasesCpbteVT.ticketsRemedyVT;
          break;
        case null:
          lClaseCpbteVT = CommonClasesCpbteVT.unknown;
          break;
        default:
          lClaseCpbteVT = pParams.claseCpbte!;

          /// ELEMENTO: NUEVO SERVICIO
          var eNewService =
              TableDetServicioDATOSClienteV2Model.fromNewNRoServicio(
                  pEmpresa: eEmpresa,
                  pCliente: eCliente,
                  pClaseCpbteVT: claseCpbteVT);
          var kNewService = CommonParamKeyValue.fromType(
            tObject: eNewService,
          );
          rResults.add(kNewService);
          break;
      }
    }
    for (var element in tData) {
      element.claseCpbteVT = lClaseCpbteVT;
      rResults.add(
        CommonParamKeyValue.fromType(
          tObject: element,
        ),
      );
    }
    pDetServiciosDATOSClientes = rResults;
    return pDetServiciosDATOSClientes;
  }

  /// Set the selected número de servicios de DATOS based on the cliente
  /// Implica: =>
  ///
  Future<ErrorHandler> setSelectedNroServicioDATOS({
    required String pFrom,
    bool pCascade = false,
    required TableDetServicioDATOSClienteV2Model pEnteSelected,
    required WidgetRef wRef,
  }) async {
    String functionName = "$runtimeType";
    switch (pFrom) {
      case "NroServicio":
        TableDetServicioDATOSClienteV2Model fEnteSelected = pEnteSelected;

        if (pEnteSelected.environment == "default") {
          return ErrorHandler(
            errorCode: 99,
            errorDsc:
                '''Error al establecer el servicio seleccionado del cliente.
                El entorno de desarrollo ${pEnteSelected.environment} es incorrecto o inválido.
                No se encuentra programado.
                ''',
            propertyName: 'NroServicio',
            propertyValue: pEnteSelected.nroServicio.toString(),
            className: className,
            functionName: functionName,
          );
        }

        /// Verifico si la entidad fue obtenida del servidor o bien es "inferido"
        ///
        // if (pEnteSelected.fromType.toLowerCase() != 'json') {
        //   /// Obtengo los datos del servicio del back-end
        //   ///
        //   GenericDataModel<TableDetServicioDATOSClienteV2Model>
        //       pDataEnteDetServicioDATOSCliente;
        //   String dThreadHashID = generateRandomUniqueHash();
        //   await wRef.read(notifierServiceProvider).mapThreadsToDataModels.set(
        //         key: dThreadHashID,
        //         value: GenericDataModel<TableDetServicioDATOSClienteV2Model>(
        //           wRef: wRef,
        //           debug: wRef.read(notifierServiceProvider).debug,
        //         ),
        //       );
        //   pDataEnteDetServicioDATOSCliente = wRef
        //       .read(notifierServiceProvider)
        //       .mapThreadsToDataModels
        //       .get(dThreadHashID);
        //   pDataEnteDetServicioDATOSCliente.pGlobalRequest =
        //       ConstRequests.viewRequest;
        //   pDataEnteDetServicioDATOSCliente.pLocalRequest =
        //       ConstRequests.viewRequest;
        //   pDataEnteDetServicioDATOSCliente.cEmpresa = pEnteSelected.eEmpresa;
        //   pDataEnteDetServicioDATOSCliente.cEncRecord =
        //       TableDetServicioDATOSClienteV2Model.fromDefault(
        //     pEmpresa: pDataEnteDetServicioDATOSCliente.cEmpresa,
        //     pCliente: eCliente,
        //   );
        //   pDataEnteDetServicioDATOSCliente.fromJsonFunction =
        //       TableDetServicioDATOSClienteV2Model.fromJson;

        //   String selectBy = "NroServicio";
        //   if (pEnteSelected.nroServicio == 0) {
        //     selectBy = "CodClie";
        //   }
        //   pDataEnteDetServicioDATOSCliente.threadParams = {
        //     'SelectBy': selectBy,
        //     'CodEmp': pEnteSelected.codEmp,
        //     'TipoCliente': pEnteSelected.tipoCliente,
        //     'CodClie': pEnteSelected.codClie,
        //     'NroServicio': pEnteSelected.nroServicio,
        //     'TipoServicio': pEnteSelected.tipoServicio,
        //     'IsEmpresaAggregated': true,
        //   };

        //   Map<String, dynamic> pLocalParams = {
        //     'SelectBy': selectBy,
        //     'CodEmp': pEnteSelected.codEmp,
        //     'TipoCliente': pEnteSelected.tipoCliente,
        //     'CodClie': pEnteSelected.codClie,
        //     'NroServicio': pEnteSelected.nroServicio,
        //     'TipoServicio': pEnteSelected.tipoServicio,
        //     'IsEmpresaAggregated': true,
        //     'ActionRequest': "ViewRecord",
        //     'DBVersion': 2,
        //     'Search': "",
        //     'ClaseCpbte': claseCpbte,
        //   };
        //   // TableEmpresaModel eEmpresa = pEnteSelected.eEmpresa;
        //   var pGenericParams = GenericModel.fromDefault();
        //   pGenericParams.pTable =
        //       TableDetServicioDATOSClienteV2Model.sDefaultTable();
        //   pGenericParams.pLocalParamsRequest = pLocalParams;

        //   ErrorHandler rFilteredRecords =
        //       await pDataEnteDetServicioDATOSCliente.filterSearchFromDropDown(
        //     pParams: pGenericParams,
        //     pEnte: pEnteSelected,
        //   );
        //   if (rFilteredRecords.errorCode != 0) {
        //     /// Si hay error, entonces lo muestro
        //     /// y retorno el error
        //     rFilteredRecords.errorDsc =
        //         '''Error al obtener los datos del número de servicio seleccionado para el cliente.
        //         ${rFilteredRecords.errorDsc}
        //         ''';
        //     rFilteredRecords.stacktrace ??= StackTrace.current;
        //     return rFilteredRecords;
        //   }

        //   /// Si no hay error, entonces verifico que la data sea del tipo esperado
        //   if (rFilteredRecords.data
        //       is! List<TableDetServicioDATOSClienteV2Model>) {
        //     /// Si la data no es del tipo esperado, entonces retorno el error
        //     return ErrorHandler(
        //       errorCode: 777,
        //       errorDsc:
        //           '''Error al obtener los datos del número de servicio seleccionado para el cliente.
        //           Esperábamos recibir List<TableDetServicioDATOSClienteV2Model>> y recibimos ${rFilteredRecords.data.runtimeType}
        //           ''',
        //       propertyName: 'Data',
        //       propertyValue: rFilteredRecords.data,
        //       functionName: functionName,
        //       className: className,
        //       stacktrace: StackTrace.current,
        //     );
        //   }
        //   List<TableDetServicioDATOSClienteV2Model> data = [];

        //   /// Si no hay error, entonces verifico que la data sea del tipo esperado
        //   /// y que contenga al menos un registro
        //   var tData = rFilteredRecords.data
        //       as List<TableDetServicioDATOSClienteV2Model>;

        //   /// Verifico que la data no esté vacía
        //   /// y que contenga un solo registro
        //   if (tData.isEmpty) {
        //     return ErrorHandler(
        //       errorCode: 778,
        //       errorDsc:
        //           '''Error al obtener los datos del número de servicio seleccionado para el cliente.
        //           No encontramos la información del número de servicio para los parámetros enviados
        //           ''',
        //       propertyName: 'Data',
        //       propertyValue: rFilteredRecords.data.toString(),
        //       functionName: functionName,
        //       className: className,
        //       stacktrace: StackTrace.current,
        //     );
        //   } else {
        //     data = rFilteredRecords.data;

        //     /// Verifico que la data contenga un solo registro
        //     /// y que no haya duplicidad de datos
        //     if (data.length != 1) {
        //       return ErrorHandler(
        //         errorCode: 779,
        //         errorDsc:
        //             '''Error al obtener los datos del número de servicio seleccionado para el cliente.
        //             Error de duplicidad de datos. Esperábamos encontrar [1] registro y encontramos ${data.length}
        //             ''',
        //         propertyName: 'Data',
        //         propertyValue: rFilteredRecords.data,
        //         functionName: functionName,
        //         className: className,
        //         stacktrace: StackTrace.current,
        //       );
        //     } else {
        //       fEnteSelected = data.first;
        //     }
        //   }
        // } // if (pEnteSelected.fromType.toLowerCase() != 'json')
        var cEnteSelected = CommonParamKeyValue.fromType(
          tObject: fEnteSelected,
        );

        /// Busco si el ente seleccionado se encuentra en la lista
        /// Si existe, dejo todo como está.
        /// Si NO existe, entonces elimino todo y doy de alta solo esa entidad
        ///
        var checkEnte = pDetServiciosDATOSClientes
            .firstWhereOrNull((element) => element == cEnteSelected);
        if (checkEnte == null) {
          pDetServiciosDATOSClientes = [cEnteSelected];
        }
        pDetServicioClienteDATOS = cEnteSelected;
        nroServicio = fEnteSelected.nroServicio;
        tipoServicio = fEnteSelected.tipoServicio;

        /// fromType == "NewNroServicio" significa que quiero generar un nuevo
        /// servicio para el cliente por lo cual completo los datos
        ///
        bool replace = false;
        if (pEnteSelected.fromType == "NewNroServicio") {
          replace = true;
        } else {
          if (domicilio.trim() == "") {
            replace = true;
          }
        }
        replace = true;
        if (replace) {
          domicilio = fEnteSelected.domicilio;
          nroPuerta = fEnteSelected.nroPuerta;
          piso = fEnteSelected.piso;
          depto = fEnteSelected.depto;
          torre = fEnteSelected.torre;
          sector = fEnteSelected.sector;
          codPais = fEnteSelected.codPais;
          descripcionCodPais = fEnteSelected.descripcionCodPais;

          /// Valido la entidad Pais
          ///
          var nEntePais = TablePaisModel.fromKey(
            pEmpresa: eEmpresa,
            pCodPais: fEnteSelected.codPais,
            pDescripcion: fEnteSelected.descripcionCodPais,
            pEnvironment: fEnteSelected.environment,
          );
          var rSelectCountry = await setSelectedCountry(
            pFrom: 'NroServicio',
            pCascade: true,
            pEnteSelected: nEntePais,
            wRef: wRef,
          );

          /// Si hubo error, lo devuelvo
          /// y no sigo procesando
          if (rSelectCountry.errorCode != 0) {
            return rSelectCountry;
          }

          codPcia = pEnteSelected.codPcia;
          descripcionCodPcia = pEnteSelected.descripcionCodPcia;

          /// Valido la entidad Provincia
          ///
          var nEnteProvincia = TableProvinciaModel.fromKey(
            pEmpresa: eEmpresa,
            pPais: ePais,
            pCodPcia: pEnteSelected.codPcia,
            pDescripcion: pEnteSelected.descripcionCodPcia,
            pEnvironment: pEnteSelected.environment,
          );
          var rSelectedProvincia = await setSelectedProvincia(
            pFrom: 'NroServicio',
            pEnteSelected: nEnteProvincia,
            wRef: wRef,
          );

          /// Si hubo error, lo devuelvo
          /// y no sigo procesando
          if (rSelectedProvincia.errorCode != 0) {
            return rSelectedProvincia;
          }

          codCdad = pEnteSelected.codCdad;
          descripcionCodCdad = pEnteSelected.descripcionCodCdad;

          /// Valido la entidad Ciudad
          ///
          var nEnteCiudad = TableCiudadModel.fromKey(
            pEmpresa: eEmpresa,
            pPais: ePais,
            pProvincia: eProvincia,
            pCodCdad: pEnteSelected.codCdad,
            pDescripcion: pEnteSelected.descripcionCodCdad,
            pEnvironment: pEnteSelected.environment,
          );
          var rSetSelectedCiudad = await setSelectedCiudad(
            pFrom: 'NroServicio',
            pEnteSelected: nEnteCiudad,
            wRef: wRef,
          );

          /// Si hubo error, lo devuelvo
          /// y no sigo procesando
          if (rSetSelectedCiudad.errorCode != 0) {
            return rSetSelectedCiudad;
          }

          codigoBarrio = pEnteSelected.codigoBarrio;
          descripcionCodigoBarrio = pEnteSelected.descripcionCodigoBarrio;

          /// Valido la entidad BarrioCiudad
          ///
          var nBarrioCiudad = TableDetBarrioCiudadModel.fromKey(
            pEmpresa: eEmpresa,
            pPais: ePais,
            pProvincia: eProvincia,
            pCiudad: eCiudad,
            pCodigoBarrio: pEnteSelected.codigoBarrio,
            pDescripcion: pEnteSelected.descripcionCodigoBarrio,
            pEnvironment: pEnteSelected.environment,
          );
          var rSetSelectedBarrio = await setSelectedBarrio(
            pFrom: 'NroServicio',
            pCascade: true,
            pEnteSelected: nBarrioCiudad,
          );

          /// Si hubo error, lo devuelvo
          /// y no sigo procesando
          if (rSetSelectedBarrio.errorCode != 0) {
            return rSetSelectedBarrio;
          }
          pTipoLogin = CommonParamKeyValue.fromType(
            tObject: TipoLoginModel.fromKey(pEnteSelected.tipoLogin),
          );
          connUsername = pEnteSelected.connUsername;
          connPassword = pEnteSelected.connPassword;
          var tEnteNewServicio =
              TableDetServicioDATOSClienteV2Model.fromNewNRoServicio(
            pEmpresa: eEmpresa,
            pCliente: eCliente,
          );
          if (pEnteSelected.wiFiSSID.isEmpty) {
            wiFiSSID = tEnteNewServicio.wiFiSSID;
          } else {
            wiFiSSID = pEnteSelected.wiFiSSID;
          }
          if (pEnteSelected.wiFiPassword.isEmpty) {
            wiFiPassword = tEnteNewServicio.wiFiPassword;
          } else {
            wiFiPassword = pEnteSelected.wiFiPassword;
          }
          //wiFiSSID = pEnteSelected.wiFiSSID;
          //wiFiPassword = pEnteSelected.wiFiPassword;
          developer.log(
            "DEBUG_17888 DropDownNroServicio DATOS - wiFiSSID: $wiFiSSID - wiFiPassword: $wiFiPassword",
          );
          // Valido la entidad NAS
          var rSetSelectedOLT = await setSelectedOLT(
            pFrom: 'NroServicio',
            pCascade: true,
            pEnteSelected: pEnteSelected.eNAS,
            wRef: wRef,
          );
        }

        if (pCascade) {
          /// Obtengo los datos del talonario (CodLetra, NroSucursal, Numero)
          /// para el TipoDeComprobante y CodClie [válido => >0]
          ///
          /// Si el cliente no es válido, no hago nada
          if (codClie == 0) {
            return ErrorHandler(
              errorCode: 0,
              errorDsc:
                  "No se procesó la parte del talonario ya que los datos del cliente no son válidos",
            );
          }

          /// Valido TipoDeComprobante (en cascada)
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "Se estableció los datos del servicio en base al cliente.",
          );
        } else {
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "Se estableció los datos del servicio en base al cliente.",
          );
        }
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener el número de servicio.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: functionName,
        );
    }
  }

  /// Set the selected country
  ///
  Future<ErrorHandler> setSelectedCountry({
    required String pFrom,
    bool pCascade = false,
    required TablePaisModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    String funcionName = "$runtimeType";
    switch (pFrom) {
      case "NroServicio":
        TablePaisModel fEnteSelected = pEnteSelected;

        /// Verifico si la entidad fue obtenida del servidor o bien es "inferido"
        ///
        if (pEnteSelected.fromType.toLowerCase() != 'json') {
          /// Obtengo los datos del servicio del back-end
          ///
          GenericDataModel<TablePaisModel> pDataEntePais;
          String dThreadHashID = generateRandomUniqueHash();
          await wRef.read(notifierServiceProvider).mapThreadsToDataModels.set(
                key: dThreadHashID,
                value: GenericDataModel<TablePaisModel>(
                  wRef: wRef,
                  debug: wRef.read(notifierServiceProvider).debug,
                ),
              );
          pDataEntePais = wRef
              .read(notifierServiceProvider)
              .mapThreadsToDataModels
              .get(dThreadHashID);
          pDataEntePais.threadID = dThreadHashID;
          pDataEntePais.pGlobalRequest = ConstRequests.viewRequest;
          pDataEntePais.pLocalRequest = ConstRequests.viewRequest;
          pDataEntePais.cEmpresa = eEmpresa;
          pDataEntePais.cEncRecord =
              TablePaisModel.fromDefault(pEmpresa: eEmpresa);
          pDataEntePais.fromJsonFunction = TablePaisModel.fromJson;

          pDataEntePais.threadParams = {
            'SelectBy': 'CodPais',
            'CodEmp': fEnteSelected.codEmp,
            'CodPais': fEnteSelected.codPais,
            'IsEmpresaAggregated': true,
          };

          Map<String, dynamic> pLocalParams = {
            'SelectBy': 'CodPais',
            'CodEmp': fEnteSelected.codEmp,
            'CodPais': fEnteSelected.codPais,
            'IsEmpresaAggregated': true,
            'ActionRequest': "ViewRecord",
            'DBVersion': 2,
            'Search': "",
            'ClaseCpbte': claseCpbteVT,
          };
          // TableEmpresaModel eEmpresa = pEnteSelected.eEmpresa;
          var pGenericParams = GenericModel.fromDefault();
          pGenericParams.pTable = TablePaisModel.sDefaultTable();
          pGenericParams.pLocalParamsRequest = pLocalParams;

          ErrorHandler rFilteredRecords =
              await pDataEntePais.filterSearchFromDropDown(
            pParams: pGenericParams,
            pEnte: fEnteSelected,
          );
          if (rFilteredRecords.errorCode != 0) {
            /// Si hay error, entonces lo muestro
            /// y retorno el error
            rFilteredRecords.errorDsc =
                '''Error al obtener los datos del país seleccionado.
                ${rFilteredRecords.errorDsc}
                ''';
            rFilteredRecords.stacktrace ??= StackTrace.current;
            return rFilteredRecords;
          }

          /// Si no hay error, entonces verifico que la data sea del tipo esperado
          if (rFilteredRecords.data is! List<TablePaisModel>) {
            /// Si la data no es del tipo esperado, entonces retorno el error
            return ErrorHandler(
              errorCode: 777,
              errorDsc: '''Error al obtener los datos del país seleccionado.
                  Esperábamos recibir List<TablePaisModel>> y recibimos ${rFilteredRecords.data.runtimeType}
                  ''',
              propertyName: 'Data',
              propertyValue: rFilteredRecords.data,
              functionName: funcionName,
              className: className,
              stacktrace: StackTrace.current,
            );
          }
          List<TablePaisModel> data = [];

          /// Si no hay error, entonces verifico que la data sea del tipo esperado
          /// y que contenga al menos un registro
          var tData = rFilteredRecords.data as List<TablePaisModel>;

          /// Verifico que la data no esté vacía
          /// y que contenga un solo registro
          if (tData.isEmpty) {
            return ErrorHandler(
              errorCode: 778,
              errorDsc: '''Error al obtener los datos del país seleccionado.
                  No encontramos la información del país para los parámetros enviados
                  ''',
              propertyName: 'Data',
              propertyValue: rFilteredRecords.data.toString(),
              functionName: funcionName,
              className: className,
              stacktrace: StackTrace.current,
            );
          } else {
            data = rFilteredRecords.data;

            /// Verifico que la data contenga un solo registro
            /// y que no haya duplicidad de datos
            if (data.length != 1) {
              return ErrorHandler(
                errorCode: 779,
                errorDsc: '''Error al obtener los datos del país seleccionado.
                    Error de duplicidad de datos. Esperábamos encontrar [1] registro y encontramos ${data.length}
                    ''',
                propertyName: 'Data',
                propertyValue: rFilteredRecords.data,
                functionName: funcionName,
                className: className,
                stacktrace: StackTrace.current,
              );
            } else {
              fEnteSelected = data.first;
            }
          }
        } // if (pEnteSelected.fromType.toLowerCase() != 'json')
        var cEnteSelected = CommonParamKeyValue.fromType(
          tObject: fEnteSelected,
        );

        /// Busco si el ente seleccionado se encuentra en la lista
        /// Si existe, dejo todo como está.
        /// Si NO existe, entonces elimino todo y doy de alta solo esa entidad
        ///
        var checkEnte =
            pPaises.firstWhereOrNull((element) => element == cEnteSelected);
        if (checkEnte == null) {
          pPaises = [cEnteSelected];
        } else {
          /// Si existe, entonces elimino el elemento de la lista
          /// y lo vuelvo a agregar para que quede al final de la lista
          ///
          developer.log(
            "6PREMIER - Eliminando el elemento de la lista: ${cEnteSelected.toString()}",
            name: 'setSelectedCountry',
          );

          /// Elimino el elemento de la lista
          pPaises.removeWhere((element) => element == cEnteSelected);
          pPaises.add(cEnteSelected);
        }
        pPais = cEnteSelected;
        ePais = fEnteSelected;
        codPais = fEnteSelected.codPais;
        descripcionCodPais = fEnteSelected.descripcion;

        if (pCascade) {
          /// Evaluo si la provincia actual pertenece al país seleccionado.
          ///
          if (!isProvinciaIncludedInCountry(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            var rSetDefaultProvinciaForCountry =
                await setDefaultProvinciaForCountry(
              pFrom: pFrom,
              pCascade: pCascade,
              wRef: wRef,
            );
            if (rSetDefaultProvinciaForCountry.errorCode != 0) {
              return rSetDefaultProvinciaForCountry;
            }
          }

          /// Evaluo si la ciudad actual pertenece a la provincia seleccionada.
          ///
          if (!isCiudadIncludedInProvincia(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            var rSetDefaultCiudadForProvincia =
                await setDefaultCiudadForProvincia(
              pFrom: pFrom,
              pCascade: pCascade,
              wRef: wRef,
            );
            if (rSetDefaultCiudadForProvincia.errorCode != 0) {
              return rSetDefaultCiudadForProvincia;
            }
          }

          /// Evaluo si el barrio actual pertenece a la ciudad seleccionada.
          ///
          if (!isBarrioIncludedInCiudad(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            var rSetDefaultBarrioForCiudad = await setDefaultBarrioForCiudad(
              pFrom: pFrom,
              pCascade: pCascade,
            );
            if (rSetDefaultBarrioForCiudad.errorCode != 0) {
              return rSetDefaultBarrioForCiudad;
            }
          }
          return ErrorHandler(
            errorCode: 0,
            errorDsc: "Se estableció el país seleccionado",
            propertyName: 'CodPais',
            propertyValue: codPais.toString(),
            functionName: funcionName,
            className: className,
          );
        } else {
          return ErrorHandler(
            errorCode: 0,
            errorDsc: "Se estableció el país seleccionado",
            propertyName: 'CodPais',
            propertyValue: codPais.toString(),
            functionName: funcionName,
            className: className,
          );
        }
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener el país.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: funcionName,
        );
    }
  }

  /// Checks weather the current provincia exists/belongs to the country already selected
  ///
  bool isProvinciaIncludedInCountry({
    required String pFrom,
    bool pCascade = false,
  }) {
    switch (pFrom) {
      case "NroServicio":
        var existProvincia = pProvincias.firstWhereOrNull((element) {
          var enteProvincia = element.typeObject!;
          developer.log(
              '6PREMIER - ${enteProvincia.codEmp} - ${enteProvincia.codPais} - ${enteProvincia.codPcia} - ${enteProvincia.environment}',
              name: 'isProvinciaIncludedInCountry');
          developer.log(
              '6PREMIER - ${ePais.codEmp} - ${ePais.codPais} - ${eProvincia.codPcia} - ${ePais.environment} - ${eProvincia.environment}',
              name: 'isProvinciaIncludedInCountry');
          return enteProvincia.codEmp == ePais.codEmp &&
              enteProvincia.codPais == ePais.codPais &&
              enteProvincia.codPcia == eProvincia.codPcia &&
              enteProvincia.environment == ePais.environment;
        });
        if (existProvincia == null) return false;
        return true;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'isProvinciaIncludedInCountry',
        );
    }
  }

  /// Sets the default province by the country already selected
  ///
  Future<ErrorHandler> setDefaultProvinciaForCountry({
    required String pFrom,
    bool pCascade = false,
    required WidgetRef wRef,
  }) async {
    String functionName = "$runtimeType";
    switch (pFrom) {
      case "NroServicio":

        /// Elimino todas las provincias existentes
        /// y establezco una por defecto
        ///
        var enteProvincia = TableProvinciaModel.fromDefault(
          pEmpresa: eEmpresa,
          pPais: ePais,
        );
        var defaultProvincia = CommonParamKeyValue.fromType(
          tObject: enteProvincia,
        );
        pProvincias = [defaultProvincia];
        pProvincia = defaultProvincia;
        eProvincia = enteProvincia;
        codPcia = enteProvincia.codPcia;
        descripcionCodPcia = enteProvincia.descripcion;
        return ErrorHandler(
          errorCode: 0,
          errorDsc: "Se estableció la provincia por defecto",
          propertyName: 'CodPcia',
          propertyValue: codPcia.toString(),
          functionName: functionName,
          className: className,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener la provincia.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: functionName,
        );
    }
  }

  /// Set the selected provincia for for the current pais
  ///
  Future<ErrorHandler> setSelectedProvincia({
    required String pFrom,
    bool pCascade = false,
    required WidgetRef wRef,
    required TableProvinciaModel pEnteSelected,
  }) async {
    String functionName = "$runtimeType";
    switch (pFrom) {
      case "NroServicio":
        var selectedProvincia =
            CommonParamKeyValue.fromType(tObject: pEnteSelected);
        pProvincia = selectedProvincia;
        codPcia = pEnteSelected.codPcia;
        descripcionCodPcia = pEnteSelected.descripcion;
        eProvincia = pEnteSelected;

        if (pCascade) {
          /// Evaluo si la ciudad actual pertenece a la provincia seleccionada.
          ///
          if (!isCiudadIncludedInProvincia(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            var rSetDefaultCiudadForProvincia =
                await setDefaultCiudadForProvincia(
              pFrom: pFrom,
              pCascade: pCascade,
              wRef: wRef,
            );
            if (rSetDefaultCiudadForProvincia.errorCode != 0) {
              return rSetDefaultCiudadForProvincia;
            }
          }

          /// Evaluo si el barrio actual pertenece a la ciudad seleccionada.
          ///
          if (!isBarrioIncludedInCiudad(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            var rSetDefaultBarrioForCiudad = await setDefaultBarrioForCiudad(
              pFrom: pFrom,
              pCascade: pCascade,
            );
            if (rSetDefaultBarrioForCiudad.errorCode != 0) {
              return rSetDefaultBarrioForCiudad;
            }
          }
        }
        return ErrorHandler(
          errorCode: 0,
          errorDsc: "Se estableció la provincia seleccionada",
          propertyName: 'CodPcia',
          propertyValue: codPcia.toString(),
          functionName: functionName,
          className: className,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener la provincia.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: functionName,
        );
    }
  }

  /// Checks if the current provincia exists/belongs to the country already selected
  ///
  bool isCiudadIncludedInProvincia({
    required String pFrom,
    bool pCascade = false,
  }) {
    switch (pFrom) {
      case "NroServicio":
        var existCiudad = pCiudades.firstWhereOrNull((element) {
          var enteCiudad = element.typeObject!;
          return enteCiudad.codEmp == eProvincia.codEmp &&
              enteCiudad.codPais == eProvincia.codPais &&
              enteCiudad.codPcia == eProvincia.codPcia &&
              enteCiudad.codCdad == eCiudad.codCdad &&
              enteCiudad.environment == eProvincia.environment;
        });
        if (existCiudad == null) return false;
        return true;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'isCiudadIncludedInProvincia',
        );
    }
  }

  /// Sets the default province by the country already selected
  ///
  Future<ErrorHandler> setDefaultCiudadForProvincia({
    required String pFrom,
    bool pCascade = false,
    required WidgetRef wRef,
  }) async {
    String $functionName = "$runtimeType";
    switch (pFrom) {
      case "NroServicio":

        /// Elimino todas las ciuadades existentes
        /// y establezco una por defecto
        ///
        var enteCiudad = TableCiudadModel.fromDefault(
          pEmpresa: eEmpresa,
          pPais: ePais,
          pProvincia: eProvincia,
        );
        var defaultCiudad = CommonParamKeyValue.fromType(
          tObject: enteCiudad,
        );
        pCiudades = [defaultCiudad];
        pCiudad = defaultCiudad;
        eCiudad = enteCiudad;
        codCdad = enteCiudad.codCdad;
        descripcionCodCdad = enteCiudad.descripcion;
        return ErrorHandler(
          errorCode: 0,
          errorDsc: "Se estableció la ciudad por defecto",
          propertyName: 'CodCdad',
          propertyValue: codCdad.toString(),
          functionName: $functionName,
          className: className,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener la ciudad.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: $functionName,
        );
    }
  }

  /// Set the selected ciudad for for the current pais
  ///
  Future<ErrorHandler> setSelectedCiudad({
    required String pFrom,
    bool pCascade = false,
    required WidgetRef wRef,
    required TableCiudadModel pEnteSelected,
  }) async {
    String functionName = "$runtimeType";
    switch (pFrom) {
      case "NroServicio":
        var selectedCiudad =
            CommonParamKeyValue.fromType(tObject: pEnteSelected);
        pCiudad = selectedCiudad;
        codCdad = pEnteSelected.codCdad;
        descripcionCodCdad = pEnteSelected.descripcion;
        eCiudad = pEnteSelected;

        if (pCascade) {
          /// Evaluo si el barrio actual pertenece a la ciudad seleccionada.
          ///
          if (!isBarrioIncludedInCiudad(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            var rSetDefaultBarrioForCiudad = await setDefaultBarrioForCiudad(
              pFrom: pFrom,
              pCascade: pCascade,
            );
            if (rSetDefaultBarrioForCiudad.errorCode != 0) {
              return rSetDefaultBarrioForCiudad;
            }
          }
        }
        return ErrorHandler(
          errorCode: 0,
          errorDsc: "Se estableció la ciudad seleccionada",
          propertyName: 'CodCdad',
          propertyValue: codCdad.toString(),
          functionName: functionName,
          className: className,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener la ciudad.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: functionName,
        );
    }
  }

  /// Checks if the current provincia exists/belongs to the country already selected
  ///
  bool isBarrioIncludedInCiudad({
    required String pFrom,
    bool pCascade = false,
  }) {
    switch (pFrom) {
      case "NroServicio":
        var existBarriosCiudad = pDetBarriosCiudad.firstWhereOrNull((element) {
          var enteBarrioCiudad = element.typeObject!;
          return enteBarrioCiudad.codEmp == eCiudad.codEmp &&
              enteBarrioCiudad.codPais == eCiudad.codPais &&
              enteBarrioCiudad.codPcia == eCiudad.codPcia &&
              enteBarrioCiudad.codCdad == eCiudad.codCdad &&
              enteBarrioCiudad.codigoBarrio == eBarrioCiudad.codigoBarrio &&
              enteBarrioCiudad.environment == eCiudad.environment;
        });
        if (existBarriosCiudad == null) return false;
        return true;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'isBarrioIncludedInCiudad',
        );
    }
  }

  /// Sets the default province by the country already selected
  ///
  Future<ErrorHandler> setDefaultBarrioForCiudad({
    required String pFrom,
    bool pCascade = false,
  }) async {
    String functionName = "$runtimeType";
    switch (pFrom) {
      case "NroServicio":

        /// Elimino todos barrios de la ciuadad existentes
        /// y establezco una por defecto
        ///
        var enteBarrio = TableDetBarrioCiudadModel.fromDefault(
          pEmpresa: eEmpresa,
          pPais: ePais,
          pProvincia: eProvincia,
          pCiudad: eCiudad,
        );
        var defaultBarrioCiudad = CommonParamKeyValue.fromType(
          tObject: enteBarrio,
        );
        pDetBarriosCiudad = [defaultBarrioCiudad];
        pBerrioCiudad = defaultBarrioCiudad;
        eBarrioCiudad = enteBarrio;
        codigoBarrio = enteBarrio.codigoBarrio;
        descripcionCodigoBarrio = enteBarrio.descripcion;
        return ErrorHandler(
          errorCode: 0,
          errorDsc: "Se estableció el barrio por defecto",
          propertyName: 'CodBarrio',
          propertyValue: codigoBarrio.toString(),
          functionName: functionName,
          className: className,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener el barrio.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: functionName,
        );
    }
  }

  /// Set the selected barrio for for the current ciudad
  ///
  Future<ErrorHandler> setSelectedBarrio({
    required String pFrom,
    bool pCascade = false,
    required TableDetBarrioCiudadModel pEnteSelected,
  }) async {
    String functionName = "$runtimeType";
    switch (pFrom) {
      case "NroServicio":
        var selectedBarrio =
            CommonParamKeyValue.fromType(tObject: pEnteSelected);
        pBerrioCiudad = selectedBarrio;
        codigoBarrio = pEnteSelected.codigoBarrio;
        descripcionCodigoBarrio = pEnteSelected.descripcion;
        eBarrioCiudad = pEnteSelected;
        return ErrorHandler(
          errorCode: 0,
          errorDsc: "Se estableció el barrio seleccionado",
          propertyName: 'CodBarrio',
          propertyValue: codigoBarrio.toString(),
          functionName: functionName,
          className: className,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener el barrio.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: functionName,
        );
    }
  }

  /// Set the selected OLT for the current service
  Future<ErrorHandler> setSelectedOLT({
    required String pFrom,
    bool pCascade = false,
    required TableNASModel pEnteSelected,
    required WidgetRef wRef,
    bool force = false,
  }) async {
    String functionName = "setSelectedOLT";
    developer.log(
      "DEBUG_7888 - setSelectedOLT - pEnteSelected: ${pEnteSelected.toJson()}",
      name: '$logClassName $functionName',
    );

    /// Si el cliente no es válido, no hago nada
    if (codClie <= 0) {
      return ErrorHandler(
        errorCode: 0,
        errorDsc:
            "No se procesó la parte del OLT ya que los datos del cliente no son válidos",
        propertyName: 'CodClie',
        propertyValue: codClie.toString(),
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }

    /// Si el servicio no es válido, no hago nada
    if (nroServicio <= 0) {
      return ErrorHandler(
        errorCode: 0,
        errorDsc:
            "No se procesó la parte del OLT ya que los datos del servicio no son válidos",
        propertyName: 'NroServicio',
        propertyValue: nroServicio.toString(),
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    }
    if (pEnteSelected.id == 0) {
      var cNewEnteSelected = CommonParamKeyValue.fromType(
        tObject: pEnteSelected,
      );
      pNASes = [cNewEnteSelected];
      pNAS = cNewEnteSelected;
      eNAS = pEnteSelected;
      oltID = pEnteSelected.id;
      ponID = 0;
      onuID = 0;
      equipmentID = 0;
      equipmentSN = "";
      wRef
          .read(notifierServiceProvider)
          .updateListeners(calledFrom: functionName);
      if (pCascade) {
        var rSetPON = await setSelectedPON(
          pFrom: pFrom,
          pCascade: pCascade,
          pEnteSelected: PONModel.fromSelectRecord(
            pNASId: pEnteSelected,
          ),
          wRef: wRef,
        );
        if (rSetPON.errorCode != 0) {
          return rSetPON;
        }
      }
      return ErrorHandler(
        errorCode: 0,
        errorDsc: '''Se estableció el OLT seleccionado.
                El entorno de desarrollo ${pEnteSelected.environment} es correcto.
                ''',
        propertyName: 'OLT',
        propertyValue: pEnteSelected.id.toString(),
        className: className,
        functionName: functionName,
        stacktrace: StackTrace.current,
      );
    } else if (pEnteSelected.id < 0) {
      wRef
          .read(notifierServiceProvider)
          .updateListeners(calledFrom: functionName);

      /// Si el ID es negativo, entonces no se puede procesar
      return ErrorHandler(
        errorCode: 34,
        errorDsc: '''Error al obtener el OLT.
        El ID del OLT es inválido.
        ''',
        propertyName: 'pEnteSelected.id',
        propertyValue: pEnteSelected.id.toString(),
        stacktrace: StackTrace.current,
        className: className,
        functionName: functionName,
      );
    }
    var cEnteSelected = CommonParamKeyValue.fromType(
      tObject: pEnteSelected,
    );
    var checkEnte =
        pNASes.firstWhereOrNull((element) => element == cEnteSelected);
    if (checkEnte != null) {
      /// Si el OLT ya existe, no hago nada
      pNASes = [cEnteSelected];
      pNAS = cEnteSelected;
      eNAS = pEnteSelected;
      oltID = pEnteSelected.id;
    } else {
      /// Si el OLT no existe, lo agrego
      /// debo buscar el registro en el backend
      var procedureParams = ProcedureParamsModel();
      procedureParams.searchBy = 'KeyID';
      procedureParams.tipoNAS = pEnteSelected.tipoNAS;
      var rSearch = await pEnteSelected.filterSearchFromDropDownBy(
        searchText: "",
        wRef: wRef,
        procedureParams: procedureParams,
      );
      if (rSearch.isEmpty) {
        return ErrorHandler(
          errorCode: 99,
          errorDsc: '''Error al establecer el OLT seleccionado.
                Esperábamos encontrar al menos [1] registro y encontramos [0].
                ''',
          propertyName: 'OLT',
          propertyValue: pEnteSelected.id.toString(),
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      pNASes = [rSearch.first];
      pNAS = rSearch.first;
      eNAS = rSearch.first.typeObject!;
      oltID = eNAS.id;
    }
    ponID = 0;
    onuID = 0;
    equipmentID = 0;
    equipmentSN = "";
    developer.log(
      "DEBUG_7888 Se estableció el OLT seleccionado: ${pEnteSelected.id} - ${pEnteSelected.nasName} ",
      name: '$logClassName $functionName',
    );
    wRef
        .read(notifierServiceProvider)
        .updateListeners(calledFrom: functionName);
    if (pCascade) {
      var rSetPON = await setSelectedPON(
        pFrom: pFrom,
        pCascade: pCascade,
        pEnteSelected: PONModel.fromKey(
          pNASId: pEnteSelected,
          slot: 0,
          id: 0,
          description: 'GPON ${pEnteSelected.id}/0',
        ),
        wRef: wRef,
      );
      if (rSetPON.errorCode != 0) {
        return rSetPON;
      }
    }
    return ErrorHandler(
      errorCode: 0,
      errorDsc: '''Se estableció el OLT seleccionado.
                ''',
      propertyName: 'OLT',
      propertyValue: pEnteSelected.id.toString(),
      className: className,
      functionName: functionName,
      stacktrace: StackTrace.current,
    );
  }

  /// Set the selected PON based on the OLT selected
  ///
  ///
  Future<ErrorHandler> setSelectedPON({
    required String pFrom,
    bool pCascade = false,
    required PONModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    String functionName = "setSelectedPON";
    switch (pFrom) {
      case "NroServicio":
        developer.log(
          "DEBUG_7888 - setSelectedPON - pEnteSelected: ${pEnteSelected.toString()}",
          name: '$logClassName $functionName',
        );

        /// Si el cliente no es válido, no hago nada
        if (codClie <= 0) {
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "No se procesó la parte del PON ya que los datos del cliente no son válidos",
            propertyName: 'CodClie',
            propertyValue: codClie.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }

        /// Si el servicio no es válido, no hago nada
        if (nroServicio <= 0) {
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "No se procesó la parte del PON ya que los datos del servicio no son válidos",
            propertyName: 'NroServicio',
            propertyValue: nroServicio.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }

        /// Si el OLT no es válido, no hago nada
        if (oltID < 0) {
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "No se procesó la parte del PON ya que los datos del OLT no son válidos",
            propertyName: 'OLT',
            propertyValue: oltID.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }
        if (pEnteSelected.id == 0) {
          var cNewEnteSelected = CommonParamKeyValue.fromType(
            tObject: pEnteSelected,
          );
          pPONes = [cNewEnteSelected];
          pPON = cNewEnteSelected;
          ePON = pEnteSelected;
          ponID = pEnteSelected.id;
          onuID = 0;
          equipmentID = 0;
          equipmentSN = "";
          wRef
              .read(notifierServiceProvider)
              .updateListeners(calledFrom: functionName);
          if (pCascade) {
            var rSetONU = await setSelectedONU(
              pFrom: pFrom,
              pCascade: pCascade,
              pEnteSelected: ONUModel.fromSelectRecord(
                pPONId: pEnteSelected,
              ),
              wRef: wRef,
            );
            if (rSetONU.errorCode != 0) {
              return rSetONU;
            }
          }
          return ErrorHandler(
            errorCode: 0,
            errorDsc: '''Se estableció el PON seleccionado.
                ''',
            propertyName: 'PON',
            propertyValue: pEnteSelected.id.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        } else if (pEnteSelected.id < 0) {
          wRef
              .read(notifierServiceProvider)
              .updateListeners(calledFrom: functionName);
          return ErrorHandler(
            errorCode: 99,
            errorDsc: '''Error al establecer el PON seleccionado.
                No se encuentra programado.
                ''',
            propertyName: 'PON',
            propertyValue: pEnteSelected.id.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }
        var cEnteSelected = CommonParamKeyValue.fromType(
          tObject: pEnteSelected,
        );
        var checkEnte =
            pPONes.firstWhereOrNull((element) => element == cEnteSelected);
        if (checkEnte != null) {
          /// Si el PON ya existe, no hago nada
          pPONes = [cEnteSelected];
          pPON = cEnteSelected;
          ePON = pEnteSelected;
          ponID = pEnteSelected.id;
        } else {
          /// Si el PON no existe, lo agrego
          /// debo buscar el registro en el backend
          var procedureParams = ProcedureParamsModel();
          procedureParams.searchBy = 'KeyID';
          // var rSearch = await pEnteSelected.filterSearchFromDropDownBy(
          //   searchText: "",
          //   wRef: wRef,
          //   procedureParams: procedureParams,
          // );
          // if (rSearch.isEmpty) {
          //   return ErrorHandler(
          //     errorCode: 99,
          //     errorDsc: '''Error al establecer el PON seleccionado.
          //       Esperábamos encontrar al menos [1] registro y encontramos [0].
          //       ''',
          //     propertyName: 'PON',
          //     propertyValue: pEnteSelected.id.toString(),
          //     className: className,
          //     functionName: functionName,
          //     stacktrace: StackTrace.current,
          //   );
          // }
          // pNewPONIDes = [rSearch.first];
          // pNewPONID = rSearch.first;
          // eNewPONID = rSearch.first.typeObject!;
          // newPONID = eNewPONID.id;
        }
        onuID = 0;
        equipmentID = 0;
        equipmentSN = "";
        developer.log(
          "DEBUG_7888 Se estableció el PON seleccionado: ${pEnteSelected.id} - ${pEnteSelected.description} ",
          name: '$logClassName $functionName',
        );
        wRef
            .read(notifierServiceProvider)
            .updateListeners(calledFrom: functionName);
        return ErrorHandler(
          errorCode: 0,
          errorDsc: '''Se estableció el PON seleccionado.
                ''',
          propertyName: 'PON',
          propertyValue: pEnteSelected.id.toString(),
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener el número de servicio.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: functionName,
        );
    }
  }

  /// Set the selected ONU for the current PON
  ///
  ///
  Future<ErrorHandler> setSelectedONU({
    required String pFrom,
    bool pCascade = false,
    required ONUModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    String functionName = "setSelectedONU";
    switch (pFrom) {
      case "NroServicio":
        developer.log(
          "DEBUG_7888 - setSelectedONU - pEnteSelected: ${pEnteSelected.toString()}",
          name: '$logClassName $functionName',
        );

        /// Si el cliente no es válido, no hago nada
        if (codClie <= 0) {
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "No se procesó la parte del PON ya que los datos del cliente no son válidos",
            propertyName: 'CodClie',
            propertyValue: codClie.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }

        /// Si el servicio no es válido, no hago nada
        if (nroServicio <= 0) {
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "No se procesó la parte del PON ya que los datos del servicio no son válidos",
            propertyName: 'NroServicio',
            propertyValue: nroServicio.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }

        /// Si el OLT no es válido, no hago nada
        if (oltID < 0) {
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "No se procesó la parte del PON ya que los datos del OLT no son válidos",
            propertyName: 'OLT',
            propertyValue: oltID.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }

        /// Si el PON no es válido, no hago nada
        if (ponID < 0) {
          return ErrorHandler(
            errorCode: 0,
            errorDsc:
                "No se procesó la parte del PON ya que los datos del PON no son válidos",
            propertyName: 'PON',
            propertyValue: ponID.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }
        if (pEnteSelected.index == 0) {
          var cNewEnteSelected = CommonParamKeyValue.fromType(
            tObject: pEnteSelected,
          );
          pONUes = [cNewEnteSelected];
          pONU = cNewEnteSelected;
          eONU = pEnteSelected;
          onuID = pEnteSelected.index;
          equipmentID = 0;
          equipmentSN = "";
          wRef
              .read(notifierServiceProvider)
              .updateListeners(calledFrom: functionName);
          return ErrorHandler(
            errorCode: 0,
            errorDsc: '''Se estableció el ONU seleccionado.
                ''',
            propertyName: 'ONU',
            propertyValue: pEnteSelected.index.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        } else if (pEnteSelected.index < 0) {
          wRef
              .read(notifierServiceProvider)
              .updateListeners(calledFrom: functionName);
          return ErrorHandler(
            errorCode: 99,
            errorDsc: '''Error al establecer el ONU seleccionado.
                No se encuentra programado.
                ''',
            propertyName: 'PON',
            propertyValue: pEnteSelected.index.toString(),
            className: className,
            functionName: functionName,
            stacktrace: StackTrace.current,
          );
        }
        var cEnteSelected = CommonParamKeyValue.fromType(
          tObject: pEnteSelected,
        );
        var checkEnte =
            pONUes.firstWhereOrNull((element) => element == cEnteSelected);
        if (checkEnte != null) {
          /// Si el ONU ya existe, no hago nada
          pONUes = [cEnteSelected];
          pONU = cEnteSelected;
          eONU = pEnteSelected;
          onuID = pEnteSelected.index;
        } else {
          /// Si el PON no existe, lo agrego
          /// debo buscar el registro en el backend
          var procedureParams = ProcedureParamsModel();
          procedureParams.searchBy = 'KeyID';
          // var rSearch = await pEnteSelected.filterSearchFromDropDownBy(
          //   searchText: "",
          //   wRef: wRef,
          //   procedureParams: procedureParams,
          // );
          // if (rSearch.isEmpty) {
          //   return ErrorHandler(
          //     errorCode: 99,
          //     errorDsc: '''Error al establecer el PON seleccionado.
          //       Esperábamos encontrar al menos [1] registro y encontramos [0].
          //       ''',
          //     propertyName: 'PON',
          //     propertyValue: pEnteSelected.id.toString(),
          //     className: className,
          //     functionName: functionName,
          //     stacktrace: StackTrace.current,
          //   );
          // }
          // pNewPONIDes = [rSearch.first];
          // pNewPONID = rSearch.first;
          // eNewPONID = rSearch.first.typeObject!;
          // newPONID = eNewPONID.id;
        }
        equipmentID = -1;
        equipmentSN = eONU.serialNumber;
        developer.log(
          "DEBUG_7888 Se estableció el ONU seleccionado: ${pEnteSelected.index} - ${pEnteSelected.serialNumber} ",
          name: '$logClassName $functionName',
        );
        wRef
            .read(notifierServiceProvider)
            .updateListeners(calledFrom: functionName);
        return ErrorHandler(
          errorCode: 0,
          errorDsc: '''Se estableció el ONU seleccionado.
                ''',
          propertyName: 'ONU',
          propertyValue: pEnteSelected.index.toString(),
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener el número de servicio.
          El parámetro es inválido.
          ''',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: functionName,
        );
    }
  }
}
