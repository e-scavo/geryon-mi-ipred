import 'dart:developer' as developer;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonBooleanModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateTimeModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonNumbersModel/number_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Ciudades/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_ClientesV2/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_CondicionesDeVenta/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_DetBarriosCiudades/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_DetServiciosDATOSClientesV2/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Paises/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_PerfilesAnchoDeBanda/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_PerfilesComprobantesFE/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_PerfilesComprobantesVT/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Provincias/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_TiposDeComprobantes/model.dart';

class TableComprobantesVTModel
    implements
        CommonModel<TableComprobantesVTModel>,
        CommonParamKeyValueCapable {
  static const String className = "TableComprobantesVTModel";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = 'tbl_ComprobantesVT';

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
      'NroCpbte': nroCpbte,
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

  CommonFieldNames<TableComprobantesVTModel> _defaultView() {
    CommonFieldNames<TableComprobantesVTModel> fieldNames =
        CommonFieldNames<TableComprobantesVTModel>();
    fieldNames.add(
      kValue: "NroCpbte",
      vValue: "NroCpbte",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ClaseCpbte",
      vValue: "ClaseCpbte",
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
    fieldNames.add(
      kValue: "Environment",
      vValue: "Environment",
      vFunction: null,
    );
    return fieldNames;
  }

  /// Fields definition
  int nroCpbte;
  String claseCpbte;
  String codTpoCpbte;
  String descripcionCodTpoCpbte;
  int codTal;
  String descripcionCodTal;
  int numero;
  CommonDateModel fechaCpbte;
  int codClie;
  String razonSocialCodClie;
  String numeroDeCuentaCodClie;
  String estadoCodClie;
  String codLetra;
  int nroSucursal;
  CommonNumbersModel importeTotalIVA;
  CommonNumbersModel importeTotalSinImpuestos;
  CommonNumbersModel importeTotalConImpuestos;
  CommonNumbersModel totalBonificacionSinImpuestos;
  CommonNumbersModel totalBonificacionIVA;
  CommonNumbersModel totalBonificacionConImpuestos;
  String estado;
  int codCondVta;
  String descripcionCodCondVta;
  CommonDateModel fecha1stVenc;
  CommonNumbersModel importeTotal1stVenc;
  CommonDateModel fecha2ndVenc;
  CommonNumbersModel importeTotal2ndVenc;
  CommonDateModel fecha3rdVenc;
  CommonNumbersModel importeTotal3rdVenc;
  CommonBooleanModel impresoraFiscal;
  int modeloImpresion;
  String leyenda;
  CommonBooleanModel utilizaVencimientos;
  CommonBooleanModel utilizaSoloUnCodigoDeLetra;
  CommonBooleanModel facturacionElectronica;
  int codigoTipoCpbteFE;
  String descripcionCodigoTipoCpbteFE;
  String cuit;
  String nroDoc;
  String cicloFacturacion;
  CommonDateModel ultPeriodoFacturacion;
  CommonDateModel fechaUltPeriodoFacturacion;
  int codigoTpoDocFE;
  String descripcionCodigoTpoDocFE;
  CommonBooleanModel moduloDATOS;
  int codigoPerfilCpbteFE;
  String descripcionCodigoPerfilCpbteFE;
  String caei;
  CommonDateModel fechaVencAutorizacion;
  CommonDateModel fechaANULCpbte;
  CommonNumbersModel importeTotalImputado;
  CommonNumbersModel importeTotalACuenta;
  CommonNumbersModel importeTotalRestaImputar;
  CommonDateModel fechaCANCpbte;
  int nroCpbteRefCAN;
  int nroCpbteRefFE;
  CommonNumbersModel importeTotalImpuestos;
  CommonDateModel fechaDesdeServFactu;
  CommonDateModel fechaHastaServFactu;
  CommonDateModel fechaDesdeServFactuProrrateo;
  CommonDateModel fechaHastaServFactuProrrateo;
  CommonNumbersModel importeTotalProrrateo;
  CommonBooleanModel confirmarProrrateo;
  CommonBooleanModel confirmarInteres;
  CommonBooleanModel confirmarPerfilCliente;
  CommonBooleanModel aplicaProrrateo;
  CommonBooleanModel aplicaInteres;
  CommonBooleanModel aplicaPerfilCliente;
  CommonNumbersModel importeTotalInteres;
  CommonNumbersModel importeTotalEfectivoFP;
  CommonNumbersModel importeTotalDiferidoFP;
  CommonBooleanModel facturacionPorCtaYOrden;
  String leyendaFacturacionPorCtaYOrden;
  CommonBooleanModel liquidaIVA;
  int codClieAGE;
  String domicilio;
  String nroPuerta;
  String piso;
  String depto;
  String torre;
  String sector;
  int codPais;
  String descripcionCodPais;
  int codPcia;
  String descripcionCodPcia;
  int codCdad;
  String descripcionCodCdad;
  int codigoBarrio;
  String descripcionCodigoBarrio;
  String telefono;
  String eMail;
  CommonDateModel fechaNacIniAct;
  String codCatIVA;
  String descripcionCodCatIVA;
  CommonNumbersModel saldoActual;
  CommonDateModel ultFechaActSaldo;
  CommonDateModel ultFechaVenta;
  CommonDateModel ultFechaCobro;
  CommonBooleanModel moduloVOZ;
  int codEmp;
  String razonSocialCodEmp;
  String hash;
  String lockHash;
  String lockUsername;
  CommonDateTimeModel lockDateTime;
  CommonDateTimeModel lockLastAccessDatetime;
  CommonDateTimeModel createdDateTime;
  String createdUsername;
  String createdTerminal;
  CommonDateTimeModel lastModifiedDateTime;
  String lastModifiedUsername;
  String lastModifiedTerminal;
  String tipoFacturacion;
  String tipoRegistracion;
  int codigoPerfilCpbteVT;
  String descripcionCodigoPerfilCpbteVT;
  int nroServicio;
  String tipoServicio;
  CommonBooleanModel moduloTELEVISION;
  String tipoCliente;
  int nroCpbteVT;
  String estadoNroCpbteVT;
  CommonDateModel periodoFacturacion;
  String environment;

  /// Control variables
  ///
  late ConstRequests cRequest;

  /// Entities to retrieve specifics key values
  ///
  TableEmpresaModel eEmpresa;
  TableClienteV2Model eCliente;
  TableDetServicioDATOSClienteV2Model eDetServicioDATOSCliente;
  TableTipoDeComprobanteModel eTipoDeComprobante;
  TablePaisModel ePais;
  TableProvinciaModel eProvincia;
  TableCiudadModel eCiudad;
  TableDetBarrioCiudadModel eBarrioCiudad;
  // TablePerfilAnchoDeBandaModel ePerfilAnchoDeBanda;
  TablePerfilComprobanteFEModel ePerfilComprobanteFE;
  // TablePerfilComprobanteVTModel ePerfilComprobanteVT;
  TableCondicionDeVentaModel eCondicionDeVenta;

  late List<CommonParamKeyValue<TableEmpresaModel>> pEmpresas;
  late CommonParamKeyValue<TableEmpresaModel> pEmpresa;
  late List<CommonParamKeyValue<TableTipoDeComprobanteModel>>
      pTiposDeComprobantes;
  late CommonParamKeyValue<TableTipoDeComprobanteModel> pTipoDeComprobante;

  late List<CommonParamKeyValue<TableClienteV2Model>> pClientes;
  late CommonParamKeyValue<TableClienteV2Model> pCliente;
  late List<CommonParamKeyValue<TableDetServicioDATOSClienteV2Model>>
      pDetServiciosDATOSClientes;
  late CommonParamKeyValue<TableDetServicioDATOSClienteV2Model>
      pDetServicioClienteDATOS;

  late List<CommonParamKeyValue<TablePaisModel>> pPaises;
  late CommonParamKeyValue<TablePaisModel> pPais;
  late List<CommonParamKeyValue<TableProvinciaModel>> pProvincias;
  late CommonParamKeyValue<TableProvinciaModel> pProvincia;
  late List<CommonParamKeyValue<TableCiudadModel>> pCiudades;
  late CommonParamKeyValue<TableCiudadModel> pCiudad;
  late List<CommonParamKeyValue<TableDetBarrioCiudadModel>> pDetBarriosCiudad;
  late CommonParamKeyValue<TableDetBarrioCiudadModel> pBerrioCiudad;
  late List<CommonParamKeyValue<TablePerfilAnchoDeBandaModel>>
      pPerfilesAnchoDeBanda;
  late CommonParamKeyValue<TablePerfilAnchoDeBandaModel> pPerfilAnchoDeBanda;
  late List<CommonParamKeyValue<TablePerfilComprobanteFEModel>>
      pPerfilesComprobantesFE;
  late CommonParamKeyValue<TablePerfilComprobanteFEModel> pPerfilComprobanteFE;
  late List<CommonParamKeyValue<TablePerfilComprobanteVTModel>>
      pPerfilesComprobantesVT;
  late CommonParamKeyValue<TablePerfilComprobanteVTModel> pPerfilComprobanteVT;
  late List<CommonParamKeyValue<TableCondicionDeVentaModel>>
      pCondicionesDeVenta;
  late CommonParamKeyValue<TableCondicionDeVentaModel> pCondicionDeVenta;

  ///

  /// Method to create a new object and returns it as it is
  TableComprobantesVTModel._internal({
    required this.nroCpbte,
    required this.claseCpbte,
    required this.codTpoCpbte,
    required this.descripcionCodTpoCpbte,
    required this.codTal,
    required this.descripcionCodTal,
    required this.numero,
    required this.fechaCpbte,
    required this.codClie,
    required this.razonSocialCodClie,
    required this.numeroDeCuentaCodClie,
    required this.estadoCodClie,
    required this.codLetra,
    required this.nroSucursal,
    required this.importeTotalIVA,
    required this.importeTotalSinImpuestos,
    required this.importeTotalConImpuestos,
    required this.totalBonificacionSinImpuestos,
    required this.totalBonificacionIVA,
    required this.totalBonificacionConImpuestos,
    required this.estado,
    required this.codCondVta,
    required this.descripcionCodCondVta,
    required this.fecha1stVenc,
    required this.importeTotal1stVenc,
    required this.fecha2ndVenc,
    required this.importeTotal2ndVenc,
    required this.fecha3rdVenc,
    required this.importeTotal3rdVenc,
    required this.impresoraFiscal,
    required this.modeloImpresion,
    required this.leyenda,
    required this.utilizaVencimientos,
    required this.utilizaSoloUnCodigoDeLetra,
    required this.facturacionElectronica,
    required this.codigoTipoCpbteFE,
    required this.descripcionCodigoTipoCpbteFE,
    required this.cuit,
    required this.nroDoc,
    required this.cicloFacturacion,
    required this.ultPeriodoFacturacion,
    required this.fechaUltPeriodoFacturacion,
    required this.codigoTpoDocFE,
    required this.descripcionCodigoTpoDocFE,
    required this.moduloDATOS,
    required this.codigoPerfilCpbteFE,
    required this.descripcionCodigoPerfilCpbteFE,
    required this.caei,
    required this.fechaVencAutorizacion,
    required this.fechaANULCpbte,
    required this.importeTotalImputado,
    required this.importeTotalACuenta,
    required this.importeTotalRestaImputar,
    required this.fechaCANCpbte,
    required this.nroCpbteRefCAN,
    required this.nroCpbteRefFE,
    required this.importeTotalImpuestos,
    required this.fechaDesdeServFactu,
    required this.fechaHastaServFactu,
    required this.fechaDesdeServFactuProrrateo,
    required this.fechaHastaServFactuProrrateo,
    required this.importeTotalProrrateo,
    required this.confirmarProrrateo,
    required this.confirmarInteres,
    required this.confirmarPerfilCliente,
    required this.aplicaProrrateo,
    required this.aplicaInteres,
    required this.aplicaPerfilCliente,
    required this.importeTotalInteres,
    required this.importeTotalEfectivoFP,
    required this.importeTotalDiferidoFP,
    required this.facturacionPorCtaYOrden,
    required this.leyendaFacturacionPorCtaYOrden,
    required this.liquidaIVA,
    required this.codClieAGE,
    required this.domicilio,
    required this.nroPuerta,
    required this.piso,
    required this.depto,
    required this.torre,
    required this.sector,
    required this.codPais,
    required this.descripcionCodPais,
    required this.codPcia,
    required this.descripcionCodPcia,
    required this.codCdad,
    required this.descripcionCodCdad,
    required this.codigoBarrio,
    required this.descripcionCodigoBarrio,
    required this.telefono,
    required this.eMail,
    required this.fechaNacIniAct,
    required this.codCatIVA,
    required this.descripcionCodCatIVA,
    required this.saldoActual,
    required this.ultFechaActSaldo,
    required this.ultFechaVenta,
    required this.ultFechaCobro,
    required this.moduloVOZ,
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.hash,
    required this.lockHash,
    required this.lockUsername,
    required this.lockDateTime,
    required this.lockLastAccessDatetime,
    required this.createdDateTime,
    required this.createdUsername,
    required this.createdTerminal,
    required this.lastModifiedDateTime,
    required this.lastModifiedUsername,
    required this.lastModifiedTerminal,
    required this.tipoFacturacion,
    required this.tipoRegistracion,
    required this.codigoPerfilCpbteVT,
    required this.descripcionCodigoPerfilCpbteVT,
    required this.nroServicio,
    required this.tipoServicio,
    required this.moduloTELEVISION,
    required this.tipoCliente,
    required this.nroCpbteVT,
    required this.estadoNroCpbteVT,
    required this.periodoFacturacion,
    required this.environment,
    required this.eEmpresa,
    required this.eTipoDeComprobante,
    required this.eCliente,
    required this.eDetServicioDATOSCliente,
    required this.ePais,
    required this.eProvincia,
    required this.eCiudad,
    required this.eBarrioCiudad,
    required this.ePerfilComprobanteFE,
    required this.eCondicionDeVenta,
  }) {
    cRequest = ConstRequests.noneRequest;

    var cEmpresa = CommonParamKeyValue.fromType(
      tObject: eEmpresa,
    );
    pEmpresas = [cEmpresa];
    pEmpresa = cEmpresa;

    var cTipoDeComprobante = CommonParamKeyValue.fromType(
      tObject: eTipoDeComprobante,
    );
    pTiposDeComprobantes = [cTipoDeComprobante];
    pTipoDeComprobante = cTipoDeComprobante;

    var cCliente = CommonParamKeyValue.fromType(
      tObject: eCliente,
    );
    pClientes = [cCliente];
    pCliente = cCliente;

    var cDetServicioDATOSCliente = CommonParamKeyValue.fromType(
      tObject: eDetServicioDATOSCliente,
    );
    pDetServiciosDATOSClientes = [cDetServicioDATOSCliente];
    pDetServicioClienteDATOS = cDetServicioDATOSCliente;

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

    var cPerfilComprobanteFE = CommonParamKeyValue.fromType(
      tObject: ePerfilComprobanteFE,
    );
    pPerfilesComprobantesFE = [cPerfilComprobanteFE];
    pPerfilComprobanteFE = cPerfilComprobanteFE;

    var cCondicionDeVenta = CommonParamKeyValue.fromType(
      tObject: eCondicionDeVenta,
    );
    pCondicionesDeVenta = [cCondicionDeVenta];
    pCondicionDeVenta = cCondicionDeVenta;
  }

  /// Set the selected tipo de comprobante
  ///
  Future<void> setSelectedTipoDeComprobante({
    required String pFrom,
    bool pCascade = false,
    required TableTipoDeComprobanteModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    return;
  }

  /// Set the selected talonario based on the Tipo de Comprobantes and Cliente,
  /// IN THAT ORDER
  ///
  Future<ErrorHandler> setSelectedTalonarioFromTipoDeComprobante({
    required String pFrom,
    bool pCascade = false,
    required WidgetRef wRef,
  }) async {
    return ErrorHandler(
      errorCode: 666,
      errorDsc: 'Not implemented yet.',
      propertyName: 'pFrom',
      propertyValue: pFrom,
      className: className,
      functionName: 'setSelectedTalonarioFromTipoDeComprobante',
    );
  }

  /// Set the selected cliente
  ///
  Future<ErrorHandler> setSelectedCliente({
    required String pFrom,
    bool pCascade = false,
    required TableClienteV2Model pEnteSelected,
    required WidgetRef wRef,
  }) async {
    return ErrorHandler(
      errorCode: 666,
      errorDsc: 'Not implemented yet.',
      propertyName: 'pFrom',
      propertyValue: pFrom,
      className: className,
      functionName: 'setSelectedCliente',
    );
  }

  /// Set the selected tipo de comprobante
  ///
  Future<ErrorHandler> setSelectedNroServicioDATOS({
    required String pFrom,
    bool pCascade = false,
    required TableDetServicioDATOSClienteV2Model pEnteSelected,
    required WidgetRef wRef,
  }) async {
    return ErrorHandler(
      errorCode: 666,
      errorDsc: 'Not implemented yet.',
      propertyName: 'pFrom',
      propertyValue: pFrom,
      className: className,
      functionName: 'setSelectedNroServicioDATOS',
    );
  }

  /// Set the selected country
  ///
  void setSelectedCountry({
    required String pFrom,
    bool pCascade = false,
    required TablePaisModel pSelectedPais,
  }) {
    return;
  }

  /// Checks if the current provincia exists/belongs to the country already selected
  ///
  bool isProvinciaIncludedInCountry({
    required String pFrom,
    bool pCascade = false,
  }) {
    switch (pFrom) {
      case "NroServicio":
        var existProvincia = pProvincias.firstWhereOrNull((element) {
          var enteProvincia = element.typeObject!;
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
  void setDefaultProvinciaForCountry({
    required String pFrom,
    bool pCascade = false,
  }) {
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
        // descripcionCodPcia = enteProvincia.descripcion;
        break;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'setDefaultProvinciaForCountry',
        );
    }
  }

  /// Set the selected provincia for for the current pais
  ///
  void setSelectedProvincia({
    required String pFrom,
    bool pCascade = false,
    required TableProvinciaModel pSelectedProvincia,
  }) {
    switch (pFrom) {
      case "NroServicio":
        var selectedProvincia =
            CommonParamKeyValue.fromType(tObject: pSelectedProvincia);
        pProvincia = selectedProvincia;
        codPcia = pSelectedProvincia.codPcia;
        // descripcionCodPcia = pSelectedProvincia.descripcion;
        eProvincia = pSelectedProvincia;

        if (pCascade) {
          /// Evaluo si la ciudad actual pertenece a la provincia seleccionada.
          ///
          if (!isCiudadIncludedInProvincia(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            setDefaultCiudadForProvincia(
              pFrom: pFrom,
              pCascade: pCascade,
            );
          }

          /// Evaluo si el barrio actual pertenece a la ciudad seleccionada.
          ///
          if (!isBarrioIncludedInCiudad(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            setDefaultBarrioForCiudad(
              pFrom: pFrom,
              pCascade: pCascade,
            );
          }
        }

        break;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'setSelectedProvincia',
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
  void setDefaultCiudadForProvincia({
    required String pFrom,
    bool pCascade = false,
  }) {
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
        // descripcionCodCdad = enteCiudad.descripcion;
        break;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'setDefaultCiudadForProvincia',
        );
    }
  }

  /// Set the selected ciudad for for the current pais
  ///
  void setSelectedCiudad({
    required String pFrom,
    bool pCascade = false,
    required TableCiudadModel pSelectedCiudad,
  }) {
    switch (pFrom) {
      case "NroServicio":
        var selectedCiudad =
            CommonParamKeyValue.fromType(tObject: pSelectedCiudad);
        pCiudad = selectedCiudad;
        codCdad = pSelectedCiudad.codCdad;
        // descripcionCodCdad = pSelectedCiudad.descripcion;
        eCiudad = pSelectedCiudad;

        if (pCascade) {
          /// Evaluo si el barrio actual pertenece a la ciudad seleccionada.
          ///
          if (!isBarrioIncludedInCiudad(
            pFrom: pFrom,
            pCascade: pCascade,
          )) {
            setDefaultBarrioForCiudad(
              pFrom: pFrom,
              pCascade: pCascade,
            );
          }
        }

        break;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'setSelectedCiudad',
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
  void setDefaultBarrioForCiudad({
    required String pFrom,
    bool pCascade = false,
  }) {
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
        // descripcionCodigoBarrio = enteBarrio.descripcion;
        break;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'setDefaultBarrioForCiudad',
        );
    }
  }

  /// Set the selected barrio for for the current ciudad
  ///
  void setSelectedBarrio({
    required String pFrom,
    bool pCascade = false,
    required TableDetBarrioCiudadModel pSelectedBarrio,
  }) {
    switch (pFrom) {
      case "NroServicio":
        var selectedBarrio =
            CommonParamKeyValue.fromType(tObject: pSelectedBarrio);
        pBerrioCiudad = selectedBarrio;
        codigoBarrio = pSelectedBarrio.codigoBarrio;
        // descripcionCodigoBarrio = pSelectedBarrio.descripcion;
        eBarrioCiudad = pSelectedBarrio;
        break;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'setSelectedBarrio',
        );
    }
  }

  /// Set the selected perfil de ancho de banda
  ///
  Future<void> setSelectedPerfilAnchoDeBanda({
    required String pFrom,
    bool pCascade = false,
    required TablePerfilAnchoDeBandaModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    // switch (pFrom) {
    //   case "NroServicio":
    //     var selectedEnte = CommonParamKeyValue.fromType(tObject: pEnteSelected);
    //     pPerfilAnchoDeBanda = selectedEnte;
    //     // codPerfilAnchoBanda = pEnteSelected.codigo;
    //     // descripcionCodPerfilAnchoBanda = pEnteSelected.descripcion;
    //     ePerfilAnchoDeBanda = pEnteSelected;
    //     break;
    //   default:
    //     throw ErrorHandler(
    //       errorCode: 33,
    //       errorDsc: 'El parámetro es inválido.',
    //       propertyName: 'pFrom',
    //       propertyValue: pFrom,
    //       stacktrace: StackTrace.current,
    //       className: className,
    //       functionName: 'setSelectedPerfilAnchoDeBanda',
    //     );
    // }
  }

  /// Set the selected perfil de comprobante FE
  ///
  Future<void> setSelectedPerfilComprobanteFE({
    required String pFrom,
    bool pCascade = false,
    required TablePerfilComprobanteFEModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    switch (pFrom) {
      case "NroServicio":
        var selectedEnte = CommonParamKeyValue.fromType(tObject: pEnteSelected);
        pPerfilComprobanteFE = selectedEnte;
        codigoPerfilCpbteFE = pEnteSelected.codigo;
        // descripcionCodigoPerfilCpbteFE = pEnteSelected.descripcion;
        ePerfilComprobanteFE = pEnteSelected;
        break;
      default:
        throw ErrorHandler(
          errorCode: 33,
          errorDsc: 'El parámetro es inválido.',
          propertyName: 'pFrom',
          propertyValue: pFrom,
          stacktrace: StackTrace.current,
          className: className,
          functionName: 'setSelectedPerfilComprobanteFE',
        );
    }
  }

  /// Set the selected perfil de comprobante FE
  ///
  Future<ErrorHandler> setSelectedPerfilComprobanteVT({
    required String pFrom,
    bool pCascade = false,
    required TablePerfilComprobanteVTModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    return ErrorHandler(
      errorCode: 666,
      errorDsc: 'Not implemented yet.',
      propertyName: 'pFrom',
      propertyValue: pFrom,
      className: className,
      functionName: 'setSelectedPerfilComprobanteVT',
    );
  }

  /// Generate the detail of billing based on the ComprobantePerfilVT selected
  ///
  Future<ErrorHandler> setDetComprobantesVTFromComprobantePerfilVT({
    required String pFrom,
    bool pCascade = false,
    required TablePerfilComprobanteVTModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    return ErrorHandler(
      errorCode: 666,
      errorDsc: 'Not implemented yet.',
      propertyName: 'pFrom',
      propertyValue: pFrom,
      className: className,
      functionName: 'setDetComprobantesVTFromComprobantePerfilVT',
    );
  }

  /// Set the selected condición de venta
  ///
  Future<void> setSelectedCondicionDeVenta({
    required String pFrom,
    bool pCascade = false,
    required TableCondicionDeVentaModel pEnteSelected,
    required WidgetRef wRef,
  }) async {
    return;
  }

  /// Set the selected cliente
  ///
  Future<void> setSelectedTipoInstalacion({
    required String pFrom,
    bool pCascade = false,
    required CommonParamKeyValue pEnteSelected,
    required WidgetRef wRef,
  }) async {
    return;
  }

  factory TableComprobantesVTModel.fromError({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    var filter = pFilter.isEmpty ? "" : "[$pFilter]";
    var razonSocial = "CON ERROR s/Filtro $filter";
    var pCpbteVT = TableComprobantesVTModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    pCpbteVT.nroCpbte = -3;
    pCpbteVT.razonSocialCodClie = razonSocial;
    return pCpbteVT;
  }

  factory TableComprobantesVTModel.noRecordFound({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    var filter = pFilter.isEmpty ? "" : "[$pFilter]";
    var razonSocial = "NO HAY REGISTRO(s) s/Filtro $filter";
    var pCpbteVT = TableComprobantesVTModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    pCpbteVT.nroCpbte = -1;
    pCpbteVT.razonSocialCodClie = razonSocial;
    return pCpbteVT;
  }

  /// Method to create a new object from default value
  factory TableComprobantesVTModel.fromDefault({
    TableEmpresaModel? pEmpresa,
  }) {
    TableEmpresaModel eEmpresa = pEmpresa ??= TableEmpresaModel.fromDefault();
    TableTipoDeComprobanteModel eTipoDeComprobante =
        TableTipoDeComprobanteModel.fromDefault(
      pEmpresa: eEmpresa,
    );
    TablePaisModel ePais = TablePaisModel.fromDefault(
      pEmpresa: eEmpresa,
    );
    TableProvinciaModel eProvincia = TableProvinciaModel.fromDefault(
      pEmpresa: eEmpresa,
      pPais: ePais,
    );
    TableCiudadModel eCiudad = TableCiudadModel.fromDefault(
      pEmpresa: eEmpresa,
      pPais: ePais,
      pProvincia: eProvincia,
    );
    TableDetBarrioCiudadModel eBarrioCiudad =
        TableDetBarrioCiudadModel.fromDefault(
      pEmpresa: eEmpresa,
      pPais: ePais,
      pProvincia: eProvincia,
      pCiudad: eCiudad,
    );
    TablePerfilComprobanteFEModel ePerfilComprobanteFE =
        TablePerfilComprobanteFEModel.fromDefault(
      pEmpresa: eEmpresa,
    );
    TableCondicionDeVentaModel eCondicionDeVenta =
        TableCondicionDeVentaModel.fromDefault(
      pEmpresa: eEmpresa,
    );
    // TablePaisModel ePaisFacturacion = TablePaisModel.fromDefault(
    //   pEmpresa: eEmpresa,
    // );
    // TableProvinciaModel eProvinciaFacturacion = TableProvinciaModel.fromDefault(
    //   pEmpresa: eEmpresa,
    //   pPais: ePais,
    // );
    // TableCiudadModel eCiudadFacturacion = TableCiudadModel.fromDefault(
    //   pEmpresa: eEmpresa,
    //   pPais: ePais,
    //   pProvincia: eProvincia,
    // );
    // TableDetBarrioCiudadModel eBarrioCiudadFacturacion =
    //     TableDetBarrioCiudadModel.fromDefault(
    //   pEmpresa: eEmpresa,
    //   pPais: ePais,
    //   pProvincia: eProvincia,
    //   pCiudad: eCiudad,
    // );
    TableClienteV2Model eCliente = TableClienteV2Model.fromDefault(
      pEmpresa: eEmpresa,
    );
    TableDetServicioDATOSClienteV2Model eDetServicioDATOSCliente =
        TableDetServicioDATOSClienteV2Model.fromDefault(
      pEmpresa: eEmpresa,
      pCliente: eCliente,
    );

    return TableComprobantesVTModel._internal(
      nroCpbte: -1,
      claseCpbte: "",
      codTpoCpbte: "",
      descripcionCodTpoCpbte: "",
      codTal: -1,
      descripcionCodTal: "",
      numero: -1,
      fechaCpbte: CommonDateModel.fromDefault(),
      codClie: -1,
      razonSocialCodClie: "",
      numeroDeCuentaCodClie: "",
      estadoCodClie: "",
      codLetra: "",
      nroSucursal: -1,
      importeTotalIVA: CommonNumbersModel.tryParse("0").data,
      importeTotalSinImpuestos: CommonNumbersModel.tryParse("0").data,
      importeTotalConImpuestos: CommonNumbersModel.tryParse("0").data,
      totalBonificacionSinImpuestos: CommonNumbersModel.tryParse("0").data,
      totalBonificacionIVA: CommonNumbersModel.tryParse("0").data,
      totalBonificacionConImpuestos: CommonNumbersModel.tryParse("0").data,
      estado: "",
      codCondVta: -1,
      descripcionCodCondVta: "",
      fecha1stVenc: CommonDateModel.fromDefault(),
      importeTotal1stVenc: CommonNumbersModel.tryParse("0").data,
      fecha2ndVenc: CommonDateModel.fromDefault(),
      importeTotal2ndVenc: CommonNumbersModel.tryParse("0").data,
      fecha3rdVenc: CommonDateModel.fromDefault(),
      importeTotal3rdVenc: CommonNumbersModel.tryParse("0").data,
      impresoraFiscal: CommonBooleanModel.newBoolean(),
      modeloImpresion: -1,
      leyenda: "",
      utilizaVencimientos: CommonBooleanModel.newBoolean(),
      utilizaSoloUnCodigoDeLetra: CommonBooleanModel.newBoolean(),
      facturacionElectronica: CommonBooleanModel.newBoolean(),
      codigoTipoCpbteFE: -1,
      descripcionCodigoTipoCpbteFE: "",
      cuit: "",
      nroDoc: "",
      cicloFacturacion: "",
      ultPeriodoFacturacion: CommonDateModel.fromDefault(),
      fechaUltPeriodoFacturacion: CommonDateModel.fromDefault(),
      codigoTpoDocFE: -1,
      descripcionCodigoTpoDocFE: '',
      moduloDATOS: CommonBooleanModel.newBoolean(),
      codigoPerfilCpbteFE: -1,
      descripcionCodigoPerfilCpbteFE: "",
      caei: "",
      fechaVencAutorizacion: CommonDateModel.fromDefault(),
      fechaANULCpbte: CommonDateModel.fromDefault(),
      importeTotalImputado: CommonNumbersModel.tryParse("0").data,
      importeTotalACuenta: CommonNumbersModel.tryParse("0").data,
      importeTotalRestaImputar: CommonNumbersModel.tryParse("0").data,
      fechaCANCpbte: CommonDateModel.fromDefault(),
      nroCpbteRefCAN: -1,
      nroCpbteRefFE: -1,
      importeTotalImpuestos: CommonNumbersModel.tryParse("0").data,
      fechaDesdeServFactu: CommonDateModel.fromDefault(),
      fechaHastaServFactu: CommonDateModel.fromDefault(),
      fechaDesdeServFactuProrrateo: CommonDateModel.fromDefault(),
      fechaHastaServFactuProrrateo: CommonDateModel.fromDefault(),
      importeTotalProrrateo: CommonNumbersModel.tryParse("0").data,
      confirmarProrrateo: CommonBooleanModel.newBoolean(),
      confirmarInteres: CommonBooleanModel.newBoolean(),
      confirmarPerfilCliente: CommonBooleanModel.newBoolean(),
      aplicaProrrateo: CommonBooleanModel.newBoolean(),
      aplicaInteres: CommonBooleanModel.newBoolean(),
      aplicaPerfilCliente: CommonBooleanModel.newBoolean(),
      importeTotalInteres: CommonNumbersModel.tryParse("0").data,
      importeTotalEfectivoFP: CommonNumbersModel.tryParse("0").data,
      importeTotalDiferidoFP: CommonNumbersModel.tryParse("0").data,
      facturacionPorCtaYOrden: CommonBooleanModel.newBoolean(),
      leyendaFacturacionPorCtaYOrden: "",
      liquidaIVA: CommonBooleanModel.newBoolean(),
      codClieAGE: -1,
      domicilio: "",
      nroPuerta: "",
      piso: "",
      depto: "",
      torre: "",
      sector: "",
      codPais: -1,
      descripcionCodPais: "",
      codPcia: -1,
      descripcionCodPcia: "",
      codCdad: -1,
      descripcionCodCdad: "",
      codigoBarrio: -1,
      descripcionCodigoBarrio: "",
      telefono: "",
      eMail: "",
      fechaNacIniAct: CommonDateModel.fromDefault(),
      codCatIVA: "",
      descripcionCodCatIVA: "",
      saldoActual: CommonNumbersModel.tryParse("0").data,
      ultFechaActSaldo: CommonDateModel.fromDefault(),
      ultFechaVenta: CommonDateModel.fromDefault(),
      ultFechaCobro: CommonDateModel.fromDefault(),
      moduloVOZ: CommonBooleanModel.newBoolean(),
      codEmp: -1,
      razonSocialCodEmp: "",
      hash: "",
      lockHash: "",
      lockUsername: "",
      lockDateTime: CommonDateTimeModel.fromDefault(),
      lockLastAccessDatetime: CommonDateTimeModel.fromDefault(),
      createdDateTime: CommonDateTimeModel.fromDefault(),
      createdUsername: "",
      createdTerminal: "",
      lastModifiedDateTime: CommonDateTimeModel.fromDefault(),
      lastModifiedUsername: "",
      lastModifiedTerminal: "",
      tipoFacturacion: "",
      tipoRegistracion: "",
      codigoPerfilCpbteVT: -1,
      descripcionCodigoPerfilCpbteVT: "",
      nroServicio: -1,
      tipoServicio: "",
      moduloTELEVISION: CommonBooleanModel.newBoolean(),
      tipoCliente: "",
      nroCpbteVT: -1,
      estadoNroCpbteVT: "",
      periodoFacturacion: CommonDateModel.fromDefault(),
      environment: "default",
      eEmpresa: eEmpresa,
      eCliente: eCliente,
      eDetServicioDATOSCliente: eDetServicioDATOSCliente,
      eTipoDeComprobante: eTipoDeComprobante,
      ePais: ePais,
      eProvincia: eProvincia,
      eCiudad: eCiudad,
      eBarrioCiudad: eBarrioCiudad,
      ePerfilComprobanteFE: ePerfilComprobanteFE,
      eCondicionDeVenta: eCondicionDeVenta,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableComprobantesVTModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    int pVersion = 2,
  }) {
    return TableComprobantesVTModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
    );
  }

  /// Method to create a new object from JSON received from backend
  factory TableComprobantesVTModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
  }) {
    String className = "TableComprobantesVTModel";
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    try {
      /// Set all the vars for proper manipulation before assigning it
      ///
      int nroCpbte = -1;
      if (int.tryParse(map['NroCpbte'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'NroCpbte',
          className: className,
        );
      }
      nroCpbte = int.parse(map["NroCpbte"].toString());
      String claseCpbte = map["ClaseCpbte"];
      String codTpoCpbte = map["CodTpoCpbte"].toString();
      String descripcionCodTpoCpbte = map["DescripcionCodTpoCpbte"].toString();
      int codTal = int.parse(map["CodTal"].toString());
      String descripcionCodTal = map["DescripcionCodTal"].toString();

      int numero = int.parse(map["Numero"].toString());

      CommonDateModel fechaCpbte = CommonDateModel.parse(
        map["FechaCpbte"],
        fieldName: "FechaCpbte",
      );

      int codClie = int.parse(map["CodClie"].toString());
      String razonSocialCodClie = map['RazonSocialCodClie'].toString();
      String numeroDeCuentaCodClie = map['NumeroDeCuentaCodClie'].toString();
      String estadoCodClie = map['EstadoCodClie'].toString();
      String codLetra = map["CodLetra"];
      int nroSucursal = int.parse(map["NroSucursal"].toString());
      var importeTotalIVA =
          CommonNumbersModel.tryParse(map["ImporteTotalIVA"]).data;
      var importeTotalSinImpuestos =
          CommonNumbersModel.tryParse(map["ImporteTotalSinImpuestos"]).data;
      var importeTotalConImpuestos =
          CommonNumbersModel.tryParse(map["ImporteTotalConImpuestos"]).data;
      var totalBonificacionSinImpuestos =
          CommonNumbersModel.tryParse(map["TotalBonificacionSinImpuestos"])
              .data;
      var totalBonificacionIVA =
          CommonNumbersModel.tryParse(map["TotalBonificacionIVA"]).data;
      var totalBonificacionConImpuestos =
          CommonNumbersModel.tryParse(map["TotalBonificacionConImpuestos"])
              .data;
      String estado = map["Estado"];
      int codCondVta = int.parse(map["CodCondVta"].toString());
      String descripcionCodCondVta = map["DescripcionCodCondVta"].toString();

      var fecha1stVenc = CommonDateModel.parse(map["Fecha1stVenc"]);
      var importeTotal1stVenc =
          CommonNumbersModel.tryParse(map["ImporteTotal1StVenc"]).data;

      var fecha2ndVenc = CommonDateModel.parse(map["Fecha2ndVenc"]);
      var importeTotal2ndVenc =
          CommonNumbersModel.tryParse(map["ImporteTotal2ndVenc"]).data;

      var fecha3rdVenc = CommonDateModel.parse(map["Fecha3rdVenc"]);
      var importeTotal3rdVenc =
          CommonNumbersModel.tryParse(map["ImporteTotal3rdVenc"]).data;

      var impresoraFiscal =
          CommonBooleanModel.parse(map["ImpresoraFiscal"]).data;
      int modeloImpresion = int.parse(map["ModeloImpresion"].toString());
      String leyenda = map["Leyenda"];
      var utilizaVencimientos =
          CommonBooleanModel.parse(map["UtilizaVencimientos"]).data;
      var utilizaSoloUnCodigoDeLetra =
          CommonBooleanModel.parse(map["UtilizaSoloUnCodigoDeLetra"]).data;
      var facturacionElectronica =
          CommonBooleanModel.parse(map["FacturacionElectronica"]).data;

      //int codigoTipoCpbteFE = int.parse(map["CodigoTipoCpbteFE"].toString());
      int codigoTipoCpbteFE = -10000;
      String descripcionCodigoTipoCpbteFE =
          map["DescripcionCodigoTipoCpbteFE"].toString();

      String cuit = map["CUIT"];
      String nroDoc = map["NroDoc"];
      String cicloFacturacion = map["CicloFacturacion"];
      var ultPeriodoFacturacion =
          CommonDateModel.parse(map["UltPeriodoFacturacion"]);
      var fechaUltPeriodoFacturacion =
          CommonDateModel.parse(map["FechaUltPeriodoFacturacion"]);

      int codigoTpoDocFE = int.parse(map["CodigoTpoDocFE"].toString());
      String descripcionCodigoTpoDocFE =
          map["DescripcionCodigoTpoDocFE"].toString();

      var moduloDATOS = CommonBooleanModel.parse(map["ModuloDATOS"]).data;
      var moduloTELEVISION =
          CommonBooleanModel.parse(map["ModuloTELEVISION"]).data;

      int codigoPerfilCpbteFE =
          int.parse(map["CodigoPerfilCpbteFE"].toString());
      String descripcionCodigoPerfilCpbteFE =
          map["DescripcionCodigoPerfilCpbteFE"].toString();

      String caei = map["CAE_I"];
      var fechaVencAutorizacion =
          CommonDateModel.parse(map["FechaVencAutorizacion"]);
      var fechaANULCpbte = CommonDateModel.parse(map["FechaANULCpbte"]);
      var importeTotalImputado =
          CommonNumbersModel.tryParse(map["ImporteTotalImputado"]).data;
      var importeTotalACuenta =
          CommonNumbersModel.tryParse(map["ImporteTotalACuenta"]).data;
      var importeTotalRestaImputar =
          CommonNumbersModel.tryParse(map["ImporteTotalRestaImputar"]).data;
      var fechaCANCpbte = CommonDateModel.parse(map["FechaCANCpbte"]);
      int nroCpbteRefCAN = -1000;
      // int.parse(map["NroCpbteRefCAN"].toString());
      int nroCpbteRefFE = -1000;
      // int.parse(map["NroCpbteRefFE"].toString());
      var importeTotalImpuestos =
          CommonNumbersModel.tryParse(map["ImporteTotalImpuestos"]).data;
      var fechaDesdeServFactu =
          CommonDateModel.parse(map["FechaDesdeServFactu"]);
      var fechaHastaServFactu =
          CommonDateModel.parse(map["FechaHastaServFactu"]);
      var fechaDesdeServFactuProrrateo =
          CommonDateModel.parse(map["FechaDesdeServFactuProrrateo"]);
      var fechaHastaServFactuProrrateo =
          CommonDateModel.parse(map["FechaHastaServFactuProrrateo"]);
      var importeTotalProrrateo =
          CommonNumbersModel.tryParse(map["ImporteTotalProrrateo"]).data;

      var confirmarProrrateo =
          CommonBooleanModel.parse(map["ConfirmarProrrateo"]).data;
      var confirmarInteres =
          CommonBooleanModel.parse(map["ConfirmarInteres"]).data;
      var confirmarPerfilCliente =
          CommonBooleanModel.parse(map["ConfirmarPerfilCliente"]).data;
      var aplicaProrrateo =
          CommonBooleanModel.parse(map["AplicaProrrateo"]).data;
      var aplicaInteres = CommonBooleanModel.parse(map["AplicaInteres"]).data;
      var aplicaPerfilCliente =
          CommonBooleanModel.parse(map["AplicaPerfilCliente"]).data;
      var importeTotalInteres =
          CommonNumbersModel.tryParse(map["ImporteTotalInteres"]).data;
      var importeTotalEfectivoFP =
          CommonNumbersModel.tryParse(map["ImporteTotalEfectivoFP"]).data;
      var importeTotalDiferidoFP =
          CommonNumbersModel.tryParse(map["ImporteTotalDiferidoFP"]).data;
      var facturacionPorCtaYOrden =
          CommonBooleanModel.parse(map["FacturacionPorCtaYOrden"]).data;
      String leyendaFacturacionPorCtaYOrden =
          map["LeyendaFacturacionPorCtaYOrden"];
      var liquidaIVA = CommonBooleanModel.parse(map["LiquidaIVA"]).data;
      int codClieAGE = -1000; //int.parse(map["CodClieAGE"].toString());
      String domicilio = map["Domicilio"];
      String nroPuerta = map["NroPuerta"];
      String piso = map["Piso"].toString();
      String depto = map["Depto"].toString();
      String torre = map["Torre"].toString();
      String sector = map["Sector"].toString();
      int codPais = -100;
      //int.parse(map["CodPais"].toString());
      String descripcionCodPais = map["DescripcionCodPais"].toString();
      int codPcia = -100; //int.parse(map["CodPcia"].toString());
      String descripcionCodPcia = map["DescripcionCodPcia"].toString();
      int codCdad = -100;
      //int.parse(map["CodCdad"].toString());
      String descripcionCodCdad = map["DescripcionCodCdad"].toString();
      int codigoBarrio = -100;
      // int.parse(map["CodigoBarrio"].toString());
      String descripcionCodigoBarrio =
          map["DescripcionCodigoBarrio"].toString();
      String telefono = map["Telefono"].toString();
      String eMail = map["EMail"].toString();
      var fechaNacIniAct = CommonDateModel.parse(map["FechaNacIniAct"]);
      String codCatIVA = map["CodCatIVA"].toString();
      String descripcionCodCatIVA = map["DescripcionCodCatIVA"].toString();
      var saldoActual = CommonNumbersModel.tryParse(map["SaldoActual"]).data;
      var ultFechaActSaldo = CommonDateModel.parse(map["UltFechaActSaldo"]);
      var ultFechaVenta = CommonDateModel.parse(map["UltFechaVenta"]);
      var ultFechaCobro = CommonDateModel.parse(map["UltFechaCobro"]);
      var moduloVOZ = CommonBooleanModel.parse(map["ModuloVOZ"]).data;
      int codEmp = int.parse(map["CodEmp"].toString());
      String razonSocialCodEmp = map["RazonSocialCodEmp"].toString();
      int codigoPerfilCpbteVT = -100;
      //int.parse(map["CodigoPerfilCpbteVT"].toString());
      String descripcionCodigoPerfilCpbteVT =
          map['DescripcionCodigoPerfilCpbteVT'].toString();
      int nroServicio = int.parse(map["NroServicio"].toString());
      String tipoServicio = map["TipoServicio"].toString();

      String tipoCliente = map["TipoCliente"];
      String hash = map["Hash"].toString();
      String lockHash = map["LockHash"].toString();
      String lockUsername = map["LockUsername"].toString();
      var lockDateTime = CommonDateTimeModel.parse(map["LockDateTime"]);
      var lockLastAccessDatetime =
          CommonDateTimeModel.parse(map["LockLastAccessDateTime"]);
      var createdDateTime = CommonDateTimeModel.parse(map["CreatedDateTime"]);
      String createdUsername = map["CreatedUsername"].toString();
      String createdTerminal = map["CreatedTerminal"].toString();
      var lastModifiedDateTime =
          CommonDateTimeModel.parse(map["LastModifiedDateTime"]);
      String lastModifiedUsername = map["LastModifiedUsername"].toString();
      String lastModifiedTerminal = map["LastModifiedTerminal"].toString();
      String tipoFacturacion = map["TipoFacturacion"].toString();
      String tipoRegistracion = map["TipoRegistracion"].toString();
      int nroCpbteVT = -100;
      //int.parse(map["NroCpbteVT"].toString());
      String estadoNroCpbteVT = map["EstadoNroCpbteVT"].toString();
      var periodoFacturacion = CommonDateModel.parse(map["PeriodoFacturacion"]);

      String environment = map["Environment"];

      /// Create the Empresa object
      ///
      TableEmpresaModel pEmpresa = TableEmpresaModel.fromDefault();
      var rEmpresa = map["Empresa"];
      if (rEmpresa == null) {
        pEmpresa = TableEmpresaModel.fromKey(
          pCodEmp: codEmp,
          pRazonSocial: razonSocialCodEmp,
          pEnvironment: environment,
        );
      } else if (rEmpresa is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info de la empresa asociada al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rEmpresa.runtimeType}.$supportMessage',
          propertyName: 'Empresa',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pEmpresa = TableEmpresaModel.fromJson(rEmpresa);
      }

      /// Create the TipoDeComprobante object
      ///
      TableTipoDeComprobanteModel pTipoDeComprobante =
          TableTipoDeComprobanteModel.fromDefault(
        pEmpresa: pEmpresa,
      );
      var rTipoDeComprobante = map["TipoDeComprobante"];
      if (rTipoDeComprobante == null) {
        pTipoDeComprobante = TableTipoDeComprobanteModel.fromKey(
          pEmpresa: pEmpresa,
          pCodTpoCpbte: codTpoCpbte,
          pDescripcion: descripcionCodTpoCpbte,
          pClaseCpbte: claseCpbte,
          pEnvironment: environment,
        );
      } else if (rTipoDeComprobante is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info del tipo de comprobante asociada al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rTipoDeComprobante.runtimeType}.$supportMessage',
          propertyName: 'TipoDeComprobante',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pTipoDeComprobante = TableTipoDeComprobanteModel.fromJson(
          map: rTipoDeComprobante,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
        );
      }

      /// Create the Cliente object
      ///
      TableClienteV2Model pCliente = TableClienteV2Model.fromDefault(
        pEmpresa: pEmpresa,
      );
      var rCliente = map["Cliente"];
      if (rCliente == null) {
        pCliente = TableClienteV2Model.fromKey(
          pEmpresa: pEmpresa,
          pTipoCliente: tipoCliente,
          pCodClie: codClie,
          pRazonSocial: razonSocialCodClie,
        );
      } else if (rCliente is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info del cliente asociada al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rCliente.runtimeType}.$supportMessage',
          propertyName: 'Cliente',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pCliente = TableClienteV2Model.fromJson(
          map: rCliente,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
        );
      }

      /// Create the DetNroServicio object
      ///
      TableDetServicioDATOSClienteV2Model pDetServicioClienteDATOS =
          TableDetServicioDATOSClienteV2Model.fromDefault(
        pEmpresa: pEmpresa,
        pCliente: pCliente,
      );
      var rDetServicioClienteDATOS = map["DetServicioClienteDATOS"];
      if (rDetServicioClienteDATOS == null) {
        pDetServicioClienteDATOS = TableDetServicioDATOSClienteV2Model.fromKey(
          pEmpresa: pEmpresa,
          pCliente: pCliente,
          pNroServicio: nroServicio,
          pTipoServicio: tipoServicio,
          pNroUnico: -9,
        );
      } else if (rDetServicioClienteDATOS is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info del servicio del cliente asociadp al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rCliente.runtimeType}.$supportMessage',
          propertyName: 'DetServicioClienteDATOS',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pDetServicioClienteDATOS = TableDetServicioDATOSClienteV2Model.fromJson(
          map: rDetServicioClienteDATOS,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
          pCliente: pCliente,
        );
      }

      /// Create the Pais object
      ///
      TablePaisModel pPais = TablePaisModel.fromDefault(
        pEmpresa: pEmpresa,
      );
      var rPais = map["Pais"];
      if (rPais == null) {
        pPais = TablePaisModel.fromKey(
          pEmpresa: pEmpresa,
          pCodPais: codPais,
          pDescripcion: descripcionCodPais,
          pEnvironment: environment,
        );
      } else if (rPais is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info del país asociada al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rPais.runtimeType}.$supportMessage',
          propertyName: 'Pais',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pPais = TablePaisModel.fromJson(
          map: rPais,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
        );
      }

      /// Create the Provincia object
      ///
      TableProvinciaModel pProvincia = TableProvinciaModel.fromDefault(
        pEmpresa: pEmpresa,
        pPais: pPais,
      );
      var rProvincia = map["Provincia"];
      if (rProvincia == null) {
        pProvincia = TableProvinciaModel.fromKey(
          pEmpresa: pEmpresa,
          pPais: pPais,
          pCodPcia: codPcia,
          pDescripcion: descripcionCodPcia,
          pEnvironment: environment,
        );
      } else if (rProvincia is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info de la provincia asociada al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rProvincia.runtimeType}.$supportMessage',
          propertyName: 'Provincia',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pProvincia = TableProvinciaModel.fromJson(
          map: rProvincia,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
          pPais: pPais,
        );
      }

      /// Create the Ciudad object
      ///
      TableCiudadModel pCiudad = TableCiudadModel.fromDefault(
        pEmpresa: pEmpresa,
        pPais: pPais,
        pProvincia: pProvincia,
      );
      var rCiudad = map["Ciudad"];
      if (rCiudad == null) {
        pCiudad = TableCiudadModel.fromKey(
          pEmpresa: pEmpresa,
          pPais: pPais,
          pProvincia: pProvincia,
          pCodCdad: codCdad,
          pDescripcion: descripcionCodCdad,
          pEnvironment: environment,
        );
      } else if (rCiudad is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info de la ciudad asociada al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rProvincia.runtimeType}.$supportMessage',
          propertyName: 'Ciudad',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pCiudad = TableCiudadModel.fromJson(
          map: rCiudad,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
          pPais: pPais,
          pProvincia: pProvincia,
        );
      }

      /// Create the Barrio object
      ///
      TableDetBarrioCiudadModel pBarrioCiudad =
          TableDetBarrioCiudadModel.fromDefault(
        pEmpresa: pEmpresa,
        pPais: pPais,
        pProvincia: pProvincia,
        pCiudad: pCiudad,
      );
      var rBarrioCiudad = map["BarrioCiudad"];
      if (rBarrioCiudad == null) {
        pBarrioCiudad = TableDetBarrioCiudadModel.fromKey(
          pEmpresa: pEmpresa,
          pPais: pPais,
          pProvincia: pProvincia,
          pCiudad: pCiudad,
          pCodigoBarrio: codigoBarrio,
          pDescripcion: descripcionCodigoBarrio,
          pEnvironment: environment,
        );
      } else if (rBarrioCiudad is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info de la provincia asociada al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rProvincia.runtimeType}.$supportMessage',
          propertyName: 'BarrioCiudad',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pBarrioCiudad = TableDetBarrioCiudadModel.fromJson(
          map: rBarrioCiudad,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
          pPais: pPais,
          pProvincia: pProvincia,
          pCiudad: pCiudad,
        );
      }

      // /// Create the Perfil de Ancho de Banda object
      // ///
      // TablePerfilAnchoDeBandaModel pPerfilAnchoDeBanda =
      //     TablePerfilAnchoDeBandaModel.fromDefault(
      //   pEmpresa: pEmpresa,
      // );
      // var rPerfilAnchoDeBanda = map["PerfilAnchoDeBanda"];
      // if (rPerfilAnchoDeBanda == null) {
      //   pPerfilAnchoDeBanda = TablePerfilAnchoDeBandaModel.fromKey(
      //     pEmpresa: pEmpresa,
      //     pCodigo: codPerfilAnchoBanda,
      //     pDescripcion: descripcionCodPerfilAnchoBanda,
      //     pEnvironment: environment,
      //   );
      // } else if (rPerfilAnchoDeBanda is! Map<String, dynamic>) {
      //   throw ErrorHandler(
      //     errorCode: 300100,
      //     errorDsc:
      //         'Error obteniendo la info del perfil de ancho de banda asociado al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rProvincia.runtimeType}.$supportMessage',
      //     propertyName: 'PerfilAnchoDeBanda',
      //     className: className,
      //     stacktrace: StackTrace.current,
      //   );
      // } else {
      //   pPerfilAnchoDeBanda = TablePerfilAnchoDeBandaModel.fromJson(
      //     rPerfilAnchoDeBanda,
      //     errorCode,
      //     pEmpresa: pEmpresa,
      //   );
      // }

      /// Create the Perfil de Comprobante FE object
      ///
      TablePerfilComprobanteFEModel pPerfilComprobanteFE =
          TablePerfilComprobanteFEModel.fromDefault(
        pEmpresa: pEmpresa,
      );
      var rPerfilComprobanteFE = map["PerfilComprobanteFE"];
      if (rPerfilComprobanteFE == null) {
        pPerfilComprobanteFE = TablePerfilComprobanteFEModel.fromKey(
          pEmpresa: pEmpresa,
          pCodigo: codigoPerfilCpbteFE,
          pDescripcion: descripcionCodigoPerfilCpbteFE,
          pEnvironment: environment,
        );
      } else if (rPerfilComprobanteFE is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info del perfil de comprobante fe asociado al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rProvincia.runtimeType}.$supportMessage',
          propertyName: 'PerfilComprobanteFE',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pPerfilComprobanteFE = TablePerfilComprobanteFEModel.fromJson(
          map: rPerfilComprobanteFE,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
        );
      }

      /// Create the Perfil de Comprobante VT object
      ///
      // TablePerfilComprobanteVTModel pPerfilComprobanteVT =
      //     TablePerfilComprobanteVTModel.fromDefault(
      //   pEmpresa: pEmpresa,
      //   pPerfilComprobanteFE: pPerfilComprobanteFE,
      //   pPerfilAnchoDeBanda: pPerfilAnchoDeBanda,
      // );
      // var rPerfilComprobanteVT = map["PerfilComprobanteVT"];
      // if (rPerfilComprobanteVT == null) {
      //   pPerfilComprobanteVT = TablePerfilComprobanteVTModel.fromKey(
      //     pEmpresa: pEmpresa,
      //     pPerfilComprobanteFE: pPerfilComprobanteFE,
      //     pPerfilAnchoDeBanda: pPerfilAnchoDeBanda,
      //     pCodigo: codigoPerfilCpbteFE,
      //     pDescripcion: descripcionCodigoPerfilCpbteFE,
      //     pEnvironment: environment,
      //   );
      // } else if (rPerfilComprobanteVT is! Map<String, dynamic>) {
      //   throw ErrorHandler(
      //     errorCode: 300100,
      //     errorDsc:
      //         'Error obteniendo la info del perfil de comprobante fe asociado al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rProvincia.runtimeType}.$supportMessage',
      //     propertyName: 'PerfilComprobanteFE',
      //     className: className,
      //     stacktrace: StackTrace.current,
      //   );
      // } else {
      //   pPerfilComprobanteVT = TablePerfilComprobanteVTModel.fromJson(
      //     rPerfilComprobanteVT,
      //     errorCode,
      //     pEmpresa: pEmpresa,
      //   );
      // }

      /// Create the Condicion de Venta object
      ///
      TableCondicionDeVentaModel pCondicionDeVenta =
          TableCondicionDeVentaModel.fromDefault(
        pEmpresa: pEmpresa,
      );
      var rCondicionDeVenta = map["CondicionDeVenta"];
      if (rCondicionDeVenta == null) {
        pCondicionDeVenta = TableCondicionDeVentaModel.fromKey(
          pEmpresa: pEmpresa,
          pCodigo: codCondVta,
          pDescripcion: descripcionCodCondVta,
          pEnvironment: environment,
        );
      } else if (rCondicionDeVenta is! Map<String, dynamic>) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc:
              'Error obteniendo la info del perfil de comprobante fe asociado al registro.\r\nEsperábamos encontrar Map<String,dynamic> y encontramos ${rProvincia.runtimeType}.$supportMessage',
          propertyName: 'CondicionDeVenta',
          className: className,
          stacktrace: StackTrace.current,
        );
      } else {
        pCondicionDeVenta = TableCondicionDeVentaModel.fromJson(
          map: rCondicionDeVenta,
          errorCode: errorCode,
          pEmpresa: pEmpresa,
        );
      }

      return TableComprobantesVTModel._internal(
        nroCpbte: nroCpbte,
        claseCpbte: claseCpbte,
        codTpoCpbte: codTpoCpbte,
        descripcionCodTpoCpbte: descripcionCodTpoCpbte,
        codTal: codTal,
        descripcionCodTal: descripcionCodTal,
        numero: numero,
        fechaCpbte: fechaCpbte,
        codClie: codClie,
        razonSocialCodClie: razonSocialCodClie,
        numeroDeCuentaCodClie: numeroDeCuentaCodClie,
        estadoCodClie: estadoCodClie,
        codLetra: codLetra,
        nroSucursal: nroSucursal,
        importeTotalIVA: importeTotalIVA,
        importeTotalSinImpuestos: importeTotalSinImpuestos,
        importeTotalConImpuestos: importeTotalConImpuestos,
        totalBonificacionSinImpuestos: totalBonificacionSinImpuestos,
        totalBonificacionIVA: totalBonificacionIVA,
        totalBonificacionConImpuestos: totalBonificacionConImpuestos,
        estado: estado,
        codCondVta: codCondVta,
        descripcionCodCondVta: descripcionCodCondVta,
        fecha1stVenc: fecha1stVenc,
        importeTotal1stVenc: importeTotal1stVenc,
        fecha2ndVenc: fecha2ndVenc,
        importeTotal2ndVenc: importeTotal2ndVenc,
        fecha3rdVenc: fecha3rdVenc,
        importeTotal3rdVenc: importeTotal3rdVenc,
        impresoraFiscal: impresoraFiscal,
        modeloImpresion: modeloImpresion,
        leyenda: leyenda,
        utilizaVencimientos: utilizaVencimientos,
        utilizaSoloUnCodigoDeLetra: utilizaSoloUnCodigoDeLetra,
        facturacionElectronica: facturacionElectronica,
        codigoTipoCpbteFE: codigoTipoCpbteFE,
        descripcionCodigoTipoCpbteFE: descripcionCodigoTipoCpbteFE,
        cuit: cuit,
        nroDoc: nroDoc,
        cicloFacturacion: cicloFacturacion,
        ultPeriodoFacturacion: ultPeriodoFacturacion,
        fechaUltPeriodoFacturacion: fechaUltPeriodoFacturacion,
        codigoTpoDocFE: codigoTpoDocFE,
        descripcionCodigoTpoDocFE: descripcionCodigoTpoDocFE,
        moduloDATOS: moduloDATOS,
        codigoPerfilCpbteFE: codigoPerfilCpbteFE,
        descripcionCodigoPerfilCpbteFE: descripcionCodigoPerfilCpbteFE,
        caei: caei,
        fechaVencAutorizacion: fechaVencAutorizacion,
        fechaANULCpbte: fechaANULCpbte,
        importeTotalImputado: importeTotalImputado,
        importeTotalACuenta: importeTotalACuenta,
        importeTotalRestaImputar: importeTotalRestaImputar,
        fechaCANCpbte: fechaCANCpbte,
        nroCpbteRefCAN: nroCpbteRefCAN,
        nroCpbteRefFE: nroCpbteRefFE,
        importeTotalImpuestos: importeTotalImpuestos,
        fechaDesdeServFactu: fechaDesdeServFactu,
        fechaHastaServFactu: fechaHastaServFactu,
        fechaDesdeServFactuProrrateo: fechaDesdeServFactuProrrateo,
        fechaHastaServFactuProrrateo: fechaHastaServFactuProrrateo,
        importeTotalProrrateo: importeTotalProrrateo,
        confirmarProrrateo: confirmarProrrateo,
        confirmarInteres: confirmarInteres,
        confirmarPerfilCliente: confirmarPerfilCliente,
        aplicaProrrateo: aplicaProrrateo,
        aplicaInteres: aplicaInteres,
        aplicaPerfilCliente: aplicaPerfilCliente,
        importeTotalInteres: importeTotalInteres,
        importeTotalEfectivoFP: importeTotalEfectivoFP,
        importeTotalDiferidoFP: importeTotalDiferidoFP,
        facturacionPorCtaYOrden: facturacionPorCtaYOrden,
        leyendaFacturacionPorCtaYOrden: leyendaFacturacionPorCtaYOrden,
        liquidaIVA: liquidaIVA,
        codClieAGE: codClieAGE,
        domicilio: domicilio,
        nroPuerta: nroPuerta,
        piso: piso,
        depto: depto,
        torre: torre,
        sector: sector,
        codPais: codPais,
        descripcionCodPais: descripcionCodPais,
        codPcia: codPcia,
        descripcionCodPcia: descripcionCodPcia,
        codCdad: codCdad,
        descripcionCodCdad: descripcionCodCdad,
        codigoBarrio: codigoBarrio,
        descripcionCodigoBarrio: descripcionCodigoBarrio,
        telefono: telefono,
        eMail: eMail,
        fechaNacIniAct: fechaNacIniAct,
        codCatIVA: codCatIVA,
        descripcionCodCatIVA: descripcionCodCatIVA,
        saldoActual: saldoActual,
        ultFechaActSaldo: ultFechaActSaldo,
        ultFechaVenta: ultFechaVenta,
        ultFechaCobro: ultFechaCobro,
        moduloVOZ: moduloVOZ,
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        hash: hash,
        lockHash: lockHash,
        lockUsername: lockUsername,
        lockDateTime: lockDateTime,
        lockLastAccessDatetime: lockLastAccessDatetime,
        createdDateTime: createdDateTime,
        createdUsername: createdUsername,
        createdTerminal: createdTerminal,
        lastModifiedDateTime: lastModifiedDateTime,
        lastModifiedUsername: lastModifiedUsername,
        lastModifiedTerminal: lastModifiedTerminal,
        tipoFacturacion: tipoFacturacion,
        tipoRegistracion: tipoRegistracion,
        codigoPerfilCpbteVT: codigoPerfilCpbteVT,
        descripcionCodigoPerfilCpbteVT: descripcionCodigoPerfilCpbteVT,
        nroServicio: nroServicio,
        moduloTELEVISION: moduloTELEVISION,
        tipoCliente: tipoCliente,
        tipoServicio: tipoServicio,
        nroCpbteVT: nroCpbteVT,
        estadoNroCpbteVT: estadoNroCpbteVT,
        periodoFacturacion: periodoFacturacion,
        environment: environment,
        eEmpresa: pEmpresa,
        eTipoDeComprobante: pTipoDeComprobante,
        eCliente: pCliente,
        eDetServicioDATOSCliente: pDetServicioClienteDATOS,
        ePais: pPais,
        eProvincia: pProvincia,
        eCiudad: pCiudad,
        eBarrioCiudad: pBarrioCiudad,
        ePerfilComprobanteFE: pPerfilComprobanteFE,
        eCondicionDeVenta: pCondicionDeVenta,
      );
    } catch (e, stacktrace) {
      developer.log(
        'CATCH:MAP: ${map.toString()} ',
        name: className,
        error: e,
        stackTrace: stacktrace,
      );
      if (e is ErrorHandler) {
        rethrow;
      } else {
        developer.log(
          'CATCH: ${e.toString()} $stacktrace',
          name: className,
          error: e,
          stackTrace: stacktrace,
        );

        throw ErrorHandler(
          errorCode: 70990,
          errorDsc: 'Internal error <= ${e.toString()}',
          propertyName: 'unknown',
          className: className,
          stacktrace: stacktrace,
        );
      }
    }
  }

  /// toJson returns a Json Go's type JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      "NroCpbte": nroCpbte,
      "ClaseCpbte": claseCpbte,
      "CodTpoCpbte": codTpoCpbte,
      "CodTal": codTal,
      "Numero": numero,
      "FechaCpbte": fechaCpbte,
      "CodClie": codClie,
      "CodLetra": codLetra,
      "NroSucursal": nroSucursal,
      "ImporteTotalIVA": importeTotalIVA,
      "ImporteTotalSinImpuestos": importeTotalSinImpuestos,
      "ImporteTotalConImpuestos": importeTotalConImpuestos,
      "TotalBonificacionSinImpuestos": totalBonificacionSinImpuestos,
      "TotalBonificacionIVA": totalBonificacionIVA,
      "TotalBonificacionConImpuestos": totalBonificacionConImpuestos,
      "Estado": estado,
      "CodCondVta": codCondVta,
      "Fecha1stVenc": fecha1stVenc,
      "ImporteTotal1stVenc": importeTotal1stVenc,
      "Fecha2ndVenc": fecha2ndVenc,
      "ImporteTotal2ndVenc": importeTotal2ndVenc,
      "Fecha3rdVenc": fecha3rdVenc,
      "ImporteTotal3rdVenc": importeTotal3rdVenc,
      "ImpresoraFiscal": impresoraFiscal,
      "ModeloImpresion": modeloImpresion,
      "Leyenda": leyenda,
      "UtilizaVencimientos": utilizaVencimientos,
      "UtilizaSoloUnCodigoDeLetra": utilizaSoloUnCodigoDeLetra,
      "FacturacionElectronica": facturacionElectronica,
      "CodigoTipoCpbteFE": codigoTipoCpbteFE,
      "CUIT": cuit,
      "NroDoc": nroDoc,
      "CicloFacturacion": cicloFacturacion,
      "UltPeriodoFacturacion": ultPeriodoFacturacion,
      "FechaUltPeriodoFacturacion": fechaUltPeriodoFacturacion,
      "CodigoTpoDocFE": codigoTpoDocFE,
      "ModuloDATOS": moduloDATOS,
      "CodigoPerfilCpbteFE": codigoPerfilCpbteFE,
      "CAE_I": caei,
      "FechaVencAutorizacion": fechaVencAutorizacion,
      "FechaANULCpbte": fechaANULCpbte,
      "ImporteTotalImputado": importeTotalImputado,
      "ImporteTotalACuenta": importeTotalACuenta,
      "ImporteTotalRestaImputar": importeTotalRestaImputar,
      "FechaCANCpbte": fechaCANCpbte,
      "NroCpbteRefCAN": nroCpbteRefCAN,
      "NroCpbteRefFE": nroCpbteRefFE,
      "ImporteTotalImpuestos": importeTotalImpuestos,
      "FechaDesdeServFactu": fechaDesdeServFactu,
      "FechaHastaServFactu": fechaHastaServFactu,
      "FechaDesdeServFactuProrrateo": fechaDesdeServFactuProrrateo,
      "FechaHastaServFactuProrrateo": fechaHastaServFactuProrrateo,
      "ImporteTotalProrrateo": importeTotalProrrateo,
      "ConfirmarProrrateo": confirmarProrrateo,
      "ConfirmarInteres": confirmarInteres,
      "ConfirmarPerfilCliente": confirmarPerfilCliente,
      "AplicaProrrateo": aplicaProrrateo,
      "AplicaInteres": aplicaInteres,
      "AplicaPerfilCliente": aplicaPerfilCliente,
      "ImporteTotalInteres": importeTotalInteres,
      "ImporteTotalEfectivoFP": importeTotalEfectivoFP,
      "ImporteTotalDiferidoFP": importeTotalDiferidoFP,
      "FacturacionPorCtaYOrden": facturacionPorCtaYOrden,
      "LeyendaFacturacionPorCtaYOrden": leyendaFacturacionPorCtaYOrden,
      "LiquidaIVA": liquidaIVA,
      "CodClieAGE": codClieAGE,
      "Domicilio": domicilio,
      "NroPuerta": nroPuerta,
      "Piso": piso,
      "Depto": depto,
      "CodPais": codPais,
      "CodPcia": codPcia,
      "CodCdad": codCdad,
      "CodigoBarrio": codigoBarrio,
      "Telefono": telefono,
      "EMail": eMail,
      "FechaNacIniAct": fechaNacIniAct,
      "CodCatIVA": codCatIVA,
      "SaldoActual": saldoActual,
      "UltFechaActSaldo": ultFechaActSaldo,
      "UltFechaVenta": ultFechaVenta,
      "UltFechaCobro": ultFechaCobro,
      "ModuloVOZ": moduloVOZ,
      "CodEmp": codEmp,
      "Hash": hash,
      "LockHash": lockHash,
      "LockUsername": lockUsername,
      "LockDateTime": lockDateTime,
      "LockLastAccessDateTime": lockLastAccessDatetime,
      "CreatedDateTime": createdDateTime,
      "CreatedUsername": createdUsername,
      "CreatedTerminal": createdTerminal,
      "LastModifiedDateTime": lastModifiedDateTime,
      "LastModifiedUsername": lastModifiedUsername,
      "LastModifiedTerminal": lastModifiedTerminal,
      "TipoFacturacion": tipoFacturacion,
      "TipoRegistracion": tipoRegistracion,
      "CodigoPerfilCpbteVT": codigoPerfilCpbteVT,
      "NroServicio": nroServicio,
      "ModuloTELEVISION": moduloTELEVISION,
      "TipoCliente": tipoCliente,
      "NroCpbteVT": nroCpbteVT,
      "PeriodoFacturacion": periodoFacturacion,
      "Environment": environment,
      "EEmpresa": eEmpresa,
      "ECliente": eCliente,
      "EDetServicioDATOSCliente": eDetServicioDATOSCliente,
      "EPais": ePais,
      "EProvincia": eProvincia,
      "ECiudad": eCiudad,
      "EBarrioCiudad": eBarrioCiudad,
      "EPerfilComprobanteFE": ePerfilComprobanteFE,
      "ECondicionDeVenta": eCondicionDeVenta,
    };
  }

  /// toMap return a Json dart's type Map
  @override
  Map<String, dynamic> toMap() {
    return {
      "nroCpbte": nroCpbte,
      "claseCpbte": claseCpbte,
      "codTpoCpbte": codTpoCpbte,
      "codTal": codTal,
      "numero": numero,
      "fechaCpbte": fechaCpbte,
      "codClie": codClie,
      "codLetra": codLetra,
      "nroSucursal": nroSucursal,
      "importeTotalIVA": importeTotalIVA,
      "importeTotalSinImpuestos": importeTotalSinImpuestos,
      "importeTotalConImpuestos": importeTotalConImpuestos,
      "totalBonificacionSinImpuestos": totalBonificacionSinImpuestos,
      "totalBonificacionIVA": totalBonificacionIVA,
      "totalBonificacionConImpuestos": totalBonificacionConImpuestos,
      "estado": estado,
      "codCondVta": codCondVta,
      "fecha1stVenc": fecha1stVenc,
      "importeTotal1stVenc": importeTotal1stVenc,
      "fecha2ndVenc": fecha2ndVenc,
      "importeTotal2ndVenc": importeTotal2ndVenc,
      "fecha3rdVenc": fecha3rdVenc,
      "importeTotal3rdVenc": importeTotal3rdVenc,
      "impresoraFiscal": impresoraFiscal,
      "modeloImpresion": modeloImpresion,
      "leyenda": leyenda,
      "utilizaVencimientos": utilizaVencimientos,
      "utilizaSoloUnCodigoDeLetra": utilizaSoloUnCodigoDeLetra,
      "facturacionElectronica": facturacionElectronica,
      "codigoTipoCpbteFE": codigoTipoCpbteFE,
      "cuit": cuit,
      "nroDoc": nroDoc,
      "cicloFacturacion": cicloFacturacion,
      "ultPeriodoFacturacion": ultPeriodoFacturacion,
      "fechaUltPeriodoFacturacion": fechaUltPeriodoFacturacion,
      "codigoTpoDocFE": codigoTpoDocFE,
      "moduloDATOS": moduloDATOS,
      "codigoPerfilCpbteFE": codigoPerfilCpbteFE,
      "caei": caei,
      "fechaVencAutorizacion": fechaVencAutorizacion,
      "fechaANULCpbte": fechaANULCpbte,
      "importeTotalImputado": importeTotalImputado,
      "importeTotalACuenta": importeTotalACuenta,
      "importeTotalRestaImputar": importeTotalRestaImputar,
      "fechaCANCpbte": fechaCANCpbte,
      "nroCpbteRefCAN": nroCpbteRefCAN,
      "nroCpbteRefFE": nroCpbteRefFE,
      "importeTotalImpuestos": importeTotalImpuestos,
      "fechaDesdeServFactu": fechaDesdeServFactu,
      "fechaHastaServFactu": fechaHastaServFactu,
      "fechaDesdeServFactuProrrateo": fechaDesdeServFactuProrrateo,
      "fechaHastaServFactuProrrateo": fechaHastaServFactuProrrateo,
      "importeTotalProrrateo": importeTotalProrrateo,
      "confirmarProrrateo": confirmarProrrateo,
      "confirmarInteres": confirmarInteres,
      "confirmarPerfilCliente": confirmarPerfilCliente,
      "aplicaProrrateo": aplicaProrrateo,
      "aplicaInteres": aplicaInteres,
      "aplicaPerfilCliente": aplicaPerfilCliente,
      "importeTotalInteres": importeTotalInteres,
      "importeTotalEfectivoFP": importeTotalEfectivoFP,
      "importeTotalDiferidoFP": importeTotalDiferidoFP,
      "facturacionPorCtaYOrden": facturacionPorCtaYOrden,
      "leyendaFacturacionPorCtaYOrden": leyendaFacturacionPorCtaYOrden,
      "liquidaIVA": liquidaIVA,
      "codClieAGE": codClieAGE,
      "domicilio": domicilio,
      "nroPuerta": nroPuerta,
      "piso": piso,
      "depto": depto,
      "codPais": codPais,
      "codPcia": codPcia,
      "codCdad": codCdad,
      "codigoBarrio": codigoBarrio,
      "telefono": telefono,
      "eMail": eMail,
      "fechaNacIniAct": fechaNacIniAct,
      "codCatIVA": codCatIVA,
      "saldoActual": saldoActual,
      "ultFechaActSaldo": ultFechaActSaldo,
      "ultFechaVenta": ultFechaVenta,
      "ultFechaCobro": ultFechaCobro,
      "moduloVOZ": moduloVOZ,
      "codEmp": codEmp,
      "hash": hash,
      "lockHash": lockHash,
      "lockUsername": lockUsername,
      "lockDateTime": lockDateTime,
      "lockLastAccessDatetime": lockLastAccessDatetime,
      "createdDateTime": createdDateTime,
      "createdUsername": createdUsername,
      "createdTerminal": createdTerminal,
      "lastModifiedDateTime": lastModifiedDateTime,
      "lastModifiedUsername": lastModifiedUsername,
      "lastModifiedTerminal": lastModifiedTerminal,
      "tipoFacturacion": tipoFacturacion,
      "tipoRegistracion": tipoRegistracion,
      "CodigoPerfilCpbteVT": codigoPerfilCpbteVT,
      "nroServicio": nroServicio,
      "moduloTELEVISION": moduloTELEVISION,
      "tipoCliente": tipoCliente,
      "nroCpbteVT": nroCpbteVT,
      "periodoFacturacion": periodoFacturacion,
      "environment": environment,
      "eEmpresa": eEmpresa,
      "eCliente": eCliente,
      "eDetServicioDATOSCliente": eDetServicioDATOSCliente,
      "ePais": ePais,
      "eProvincia": eProvincia,
      "eCiudad": eCiudad,
      "eBarrioCiudad": eBarrioCiudad,
      "ePerfilComprobanteFE": ePerfilComprobanteFE,
      "eCondicionDeVenta": eCondicionDeVenta,
    };
  }

  /// toString overrides the method to comply with Go
  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TableComprobantesVTModel) return false;

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
      '($claseCpbte) ${nroCpbte.toString().padLeft(9, '0')} - ${importeTotalConImpuestos.asStringWithPrecSpanish(2)}';

  @override
  String get dropDownKey => nroCpbte.toString();

  @override
  String get dropDownSubTitle =>
      '($claseCpbte) ${nroCpbte.toString().padLeft(9, '0')} - ${importeTotalConImpuestos.asStringWithPrecSpanish(2)}';

  @override
  String get dropDownTitle => nroCpbte.toString();

  @override
  String get dropDownValue => nroCpbte.toString();

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
  String get textOnDisabled => "";
}
