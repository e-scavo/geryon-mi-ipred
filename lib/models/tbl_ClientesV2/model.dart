import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonBooleanModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDateTimeModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonNumbersModel/number_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonUtils/common_utils.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/model.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/error_dialog_route.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_AFIP_WSFE_TiposDeDocumentos/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_CategoriasDeIVA/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Ciudades/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_ClientesV2/tiposaldoactual_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_CondicionesDeVenta/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_DetBarriosCiudades/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Paises/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Provincias/model.dart';

class TableClienteV2Model
    implements CommonModel<TableClienteV2Model>, CommonParamKeyValueCapable {
  static const String className = "TableClienteV2Model";
  static const String logClassName = ".::$className::.";
  static final String _defaultTable = 'tbl_Clientes';

  bool forceEdit = false;
  bool canEdit = false;
  bool isCombinationControlShiftF9Pressed = false;
//   String copyToClipBoardPagoFacil = '''
// 👍 Hola *_RazonSocialCodClie_*

// Cómo pagar con el código de barras que necesitás para pagos online como *Pago Fácil*.
// Para ello tenés que ir al sitio *https://pagosenlinea.pagofacil.com.ar/*.
// Hacé clic en *CON FACTURA*.
// Luego completás con el código de barras *_CodigoBarrasRazonSocialCodClie_* y hacés click en *CONTINUAR*.
// Completás el monto *_SaldoActualRazonSocialCodClie_* a pagar y hacés click en *CONTINUAR*.

// *IMPORTANTE*: ÚNICAMENTE CON *TARJETA DE DÉBITO*.

// ❓ Cualquier duda o consulta, nos contactás!!

// Saludos
// Atte. *IP·RED*
// ''';
  String copyToClipBoardBancoROELAAlias = '''
🌟 Hola *{{RazonSocial}}!*

Te contamos cómo podés pagar tu servicio por transferencia usando tu *ALIAS*.

💻 ¿Cómo realizar el pago?
1️⃣ Ingresá a tu Home Banking o Billetera.
2️⃣ Dirigite al área de Transferencias.
3️⃣ Ingresá TU ALIAS de pago: *{{RoelaAliasCuentaBancaria}}*
4️⃣ Presioná CONTINUAR.
5️⃣ Ingresá el importe adeudado: *{{SaldoActual}}*
6️⃣ Completá el pago siguiendo las instrucciones de la plataforma.

⚠️ Importante: Tu pago se acreditará dentro de las próximas 48 hs hábiles de forma automática.

❓ Si tenés alguna consulta, escribinos y te ayudamos.
✅ ¡Gracias por elegirnos!
📞 *IP·RED*
''';

  String copyToClipBoardHomebanking = '''
🌟 Hola *{{RazonSocial}}!*

Te contamos cómo podés pagar tu servicio por Home Banking o Pago Mis Cuentas usando tu código electrónico de pago.

💻 ¿Cómo realizar el pago?
1️⃣ Ingresá a tu Home Banking o Pago Mis Cuentas.
2️⃣ Dirigite al área de Pago de Servicios.
3️⃣ Buscá nuestra empresa: 🔍 *"IPRED"* o *"IP RED"* (según tu banco).
4️⃣ Ingresá este código electrónico de pago: *{{CodigoPMCnPF}}*
5️⃣ Presioná CONTINUAR.
6️⃣ Verificá que aparezca tu factura y que el importe sea: *{{SaldoActual}}*
7️⃣ Completá el pago siguiendo las instrucciones de la plataforma.

⚠️ Importante: Tu pago se acreditará dentro de las próximas 48 hs hábiles de forma automática.

❓ Si tenés alguna consulta, escribinos y te ayudamos.
✅ ¡Gracias por elegirnos!
📞 *IP·RED*
''';

  String copyToClipBoardPagoFacil = '''
🌟 Hola *{{RazonSocial}}*!

Te compartimos el código de barras que necesitás para pagar tu servicio de forma online a través de Pago Fácil.

💳 ¿Cómo realizar el pago?
1️⃣ Ingresá en 👉 https://pagosenlinea.pagofacil.com.ar/
2️⃣ Hacé clic en "CON FACTURA"
3️⃣ Completá el siguiente código de barras: *{{CodigoBarrasPMCnPF}}*
4️⃣ Presioná CONTINUAR
5️⃣ Indicá el monto a abonar: *{{SaldoActual}}*
6️⃣ Hacé clic en CONTINUAR

⚠️ Importante: El pago se realiza únicamente con tarjeta de débito.

❓ Si tenés alguna duda, escribinos y te ayudamos.
✅ ¡Muchas gracias por elegirnos!
📞 *IP·RED*
''';

  String processTemplate({
    required String pTemplate,
    required Map<String, dynamic> pData,
  }) {
    String myTemplate = pTemplate;
    // Obtengo los FieldNames (por defecto)
    //var fieldNames = getView(pViewName: 'default');
    var fieldNames = pData;
    //fieldNames.getColumns().values.forEach((element) {
    for (var element in fieldNames.keys) {
      switch (fieldNames[element]) {
        case const (Map<String, dynamic>):
          continue;
        case const (null):
          continue;
        case const (CommonNumbersModel):
          CommonNumbersModel? saldoActual = fieldNames[element];
          String sSaldoActual = 'CONSULTAR';
          if (saldoActual != null) {
            sSaldoActual = saldoActual.asStringWithPrecSpanish(2).trim();
          }
          myTemplate = myTemplate.replaceAll(
            "{{SaldoActual}}",
            sSaldoActual,
          );
          break;
        default:
          switch (element) {
            case "SaldoActual":
              String sSaldoActual = 'CONSULTAR';
              var rSaldoActual =
                  CommonNumbersModel.tryParse(fieldNames[element]);
              if (rSaldoActual.errorCode == 0) {
                sSaldoActual = rSaldoActual.data.asStringWithPrecSpanish(2);
              }
              myTemplate = myTemplate.replaceAll(
                "{{$element}}",
                sSaldoActual,
              );
              break;
            default:
              myTemplate = myTemplate.replaceAll(
                "{{$element}}",
                fieldNames[element].toString(),
              );
          }
      }
      // // if (pData[element] != null) {
      // //   pData[element] = '';
      // myTemplate = myTemplate.replaceAll(
      //   "{{$element}}",
      //   fieldNames[element].toString(),
      // );
      // // }
    }
    // //{{RazonSocialCodClie}}
    // myTemplate = myTemplate.replaceAll(
    //   "{{RazonSocialCodClie}}",
    //   pData['RazonSocial'] ?? "",
    // );
    // myTemplate = myTemplate.replaceAll(
    //   "{{CodigoPMCnPF}}",
    //   pData['CodigoPMCnPF'] ?? "",
    // );
    // CommonNumbersModel? saldoActual = pData['SaldoActual'];
    // String sSaldoActual = 'CONSULTAR';
    // if (saldoActual != null) {
    //   sSaldoActual = saldoActual.asStringWithPrecSpanish(2).trim();
    // }
    // myTemplate = myTemplate.replaceAll(
    //   "{{SaldoActualRazonSocialCodClie}}",
    //   sSaldoActual,
    // );
    return myTemplate;
  }

  late List<CommonParamKeyValue<TipoSaldoActualModel>> pTiposSaldoActual;
  late CommonParamKeyValue<TipoSaldoActualModel> pTipoSaldoActual;
  List<CommonParamKeyValue> pEstados = [
    CommonParamKeyValue.fromStandard(
      key: 'PENDIENTE-???',
      value: 'PENDIENTE-???',
      title: 'PENDIENTE S.G.',
      subTitle: 'Comprobante sin guardar',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'Pendiente',
      value: 'Pendiente',
      title: 'PENDIENTE',
      subTitle: 'Comprobante recién ingresado',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'Pendiente-INST',
      value: 'Pendiente-INST',
      title: 'PEN. INST.',
      subTitle: 'Pendiente de instalación',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'Activo',
      value: 'Activo',
      title: 'ACTIVO',
      subTitle: 'Entidad completamente activa',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'Suspendido',
      value: 'Suspendido',
      title: 'SUSPENDIDO',
      subTitle: 'Entidad completamente suspendida',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'Moroso',
      value: 'Moroso',
      title: 'Moroso',
      subTitle: 'Entidad completamente morosa',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'Baja',
      value: 'Baja',
      title: 'Baja',
      subTitle: 'Entidad completamente baja',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'Documentacion',
      value: 'Documentacion',
      title: 'Documentacion',
      subTitle: 'Entidad completamente en documentación',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'BAJA',
      value: 'BAJA',
      title: 'BAJA',
      subTitle: 'Comprobante baja',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: '1era Mora',
      value: '1era Mora',
      title: '1era Mora',
      subTitle: 'En mora',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: '2da Mora',
      value: '2da Mora',
      title: '2da Mora',
      subTitle: 'En mora',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: '3era Mora',
      value: '3era Mora',
      title: '3era Mora',
      subTitle: 'En Mora',
      avatar: "",
    ),
    CommonParamKeyValue.fromStandard(
      key: 'Otro',
      value: 'Otro',
      title: 'Otro',
      subTitle: 'Otro',
      avatar: "",
    ),
  ];

  /// Table Fields
  int codEmp;
  String razonSocialCodEmp;
  String tipoCliente;
  int codClie;
  String razonSocial;
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
  String codPostal;
  int codigoBarrio;
  String descripcionCodigoBarrio;
  String telefono;
  String email;
  int codCondVta;
  String descripcionCodCondVta;
  CommonDateModel fechaNacIniAct;
  String codCatIVA;
  String descripcionCodCatIVA;
  String cuit;
  String nroDoc;
  String observaciones;
  CommonDateModel fechaAlta;
  CommonNumbersModel saldoActual;
  CommonNumbersModel saldoInicial;
  CommonDateModel ultFechaActSaldo;
  CommonDateModel ultFechaVenta;
  CommonDateModel ultFechaCobro;
  String cicloFacturacion;
  CommonDateModel ultPeriodoFacturacion;
  CommonDateModel fechaUltPeriodoFacturacion;
  int codigoTpoDocFE;
  String descripcionCodigoTpoDocFE;
  CommonBooleanModel facturacionElectronica;
  CommonBooleanModel moduloDATOS;
  CommonBooleanModel moduloVOZ;
  CommonBooleanModel moduloTELEVISION;
  String estado;
  CommonDateModel fechaUltCbioEstado;
  String intranetUsername;
  String intranetPassword;
  String tag;
  String numeroDeCuenta;
  String lastModifiedDate;
  String lastModifiedTime;
  String lastModifiedUsername;
  String lastModifiedTerminal;
  String roelaAliasCuentaBancaria;
  String roelaCBUCuentaBancaria;
  String codigoBarrasPMCnPF;
  String codigoPMCnPF;
  String hash;
  String lockHash;
  String lockUsername;
  String lockTerminal;
  CommonDateTimeModel lockDateTime;
  CommonDateTimeModel lockLastAccessDateTime;
  String createdUsername;
  String createdTerminal;
  CommonDateTimeModel createdDateTime;
  String fromType;
  String environment;

  /// Objects
  TableEmpresaModel eEmpresa;
  TablePaisModel ePais;
  TableProvinciaModel eProvincia;
  TableCiudadModel eCiudad;
  TableDetBarrioCiudadModel eBarrioCiudad;
  TableCondicionDeVentaModel eCondicionDeVenta;
  TableCategoriaDeIVAModel eCategoriaDeIVA;
  TableAFIPWSFETiposDeDocumentos eAFIPWSFETipoDeDocuemnto;

  TableClienteV2Model._internal({
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.tipoCliente,
    required this.codClie,
    required this.razonSocial,
    required this.domicilio,
    required this.nroPuerta,
    required this.piso,
    required this.depto,
    required this.codCdad,
    required this.descripcionCodCdad,
    required this.codPostal,
    required this.codigoBarrio,
    required this.descripcionCodigoBarrio,
    required this.telefono,
    required this.email,
    required this.codCondVta,
    required this.descripcionCodCondVta,
    required this.fechaNacIniAct,
    required this.codCatIVA,
    required this.descripcionCodCatIVA,
    required this.cuit,
    required this.nroDoc,
    required this.observaciones,
    required this.fechaAlta,
    required this.saldoActual,
    required this.saldoInicial,
    required this.ultFechaActSaldo,
    required this.ultFechaVenta,
    required this.ultFechaCobro,
    required this.cicloFacturacion,
    required this.ultPeriodoFacturacion,
    required this.fechaUltPeriodoFacturacion,
    required this.codigoTpoDocFE,
    required this.descripcionCodigoTpoDocFE,
    required this.facturacionElectronica,
    required this.moduloDATOS,
    required this.estado,
    required this.fechaUltCbioEstado,
    required this.intranetUsername,
    required this.intranetPassword,
    required this.moduloVOZ,
    required this.tag,
    required this.numeroDeCuenta,
    required this.codPais,
    required this.descripcionCodPais,
    required this.codPcia,
    required this.descripcionCodPcia,
    required this.torre,
    required this.sector,
    required this.moduloTELEVISION,
    required this.lastModifiedDate,
    required this.lastModifiedTime,
    required this.lastModifiedUsername,
    required this.lastModifiedTerminal,
    required this.roelaAliasCuentaBancaria,
    required this.roelaCBUCuentaBancaria,
    required this.codigoBarrasPMCnPF,
    required this.codigoPMCnPF,
    required this.hash,
    required this.lockHash,
    required this.lockUsername,
    required this.lockTerminal,
    required this.lockDateTime,
    required this.lockLastAccessDateTime,
    required this.createdUsername,
    required this.createdTerminal,
    required this.createdDateTime,
    required this.fromType,
    required this.environment,
    required this.eEmpresa,
    required this.ePais,
    required this.eProvincia,
    required this.eCiudad,
    required this.eBarrioCiudad,
    required this.eCondicionDeVenta,
    required this.eCategoriaDeIVA,
    required this.eAFIPWSFETipoDeDocuemnto,
  }) {
    pTiposSaldoActual = TipoSaldoActualModel.values
        .map(
          (e) => CommonParamKeyValue<TipoSaldoActualModel>.fromType(tObject: e),
        )
        .toList();
    pTipoSaldoActual = pTiposSaldoActual.first;
  }

  /// If we create an object from default
  ///
  factory TableClienteV2Model.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    var codEmp = pEmpresa.codEmp;
    var razonSocialCodEmp = pEmpresa.razonSocial;
    var tipoCliente = 'Cliente';
    var codClie = -1;
    var razonSocial = "SELECCIONE UN CLIENTE";
    var domicilio = "";
    var nroPuerta = "";
    var piso = "";
    var depto = "";
    var codPais = 0;
    var descripcionCodPais = "";
    var codPcia = 0;
    var descripcionCodPcia = "";
    var codCdad = 0;
    var descripcionCodCdad = "";
    var codPostal = "";
    var codigoBarrio = 0;
    var descripcionCodigoBarrio = "";
    var telefono = "";
    var email = "";
    var codCondVta = 0;
    var descripcionCodCondVta = "";
    var fechaNacIniAct = CommonDateModel.fromDefault();
    var codCatIVA = "";
    var descripcionCodCatIVA = "";
    var cuit = "";
    var nroDoc = "";
    var observaciones = "";
    var fechaAlta = CommonDateModel.fromDefault();
    var saldoActual = CommonNumbersModel.newNumbers();
    var saldoInicial = CommonNumbersModel.newNumbers();
    var ultFechaActSaldo = CommonDateModel.fromDefault();
    var ultFechaVenta = CommonDateModel.fromDefault();
    var ultFechaCobro = CommonDateModel.fromDefault();
    var cicloFacturacion = "";
    var ultPeriodoFacturacion = CommonDateModel.fromDefault();
    var fechaUltPeriodoFacturacion = CommonDateModel.fromDefault();
    var codigoTpoDocFE = 0;
    var descripcionCodigoTpoDocFE = "";
    var facturacionElectronica = CommonBooleanModel.newBoolean();
    var moduloDATOS = CommonBooleanModel.newBoolean();
    var moduloVOZ = CommonBooleanModel.newBoolean();
    var moduloTELEVISION = CommonBooleanModel.newBoolean();
    var estado = "";
    var fechaUltCbioEstado = CommonDateModel.fromDefault();
    var intranetUsername = "";
    var intranetPassword = "";
    var tag = "";
    var numeroDeCuenta = "";
    var torre = "";
    var sector = "";
    var lastModifiedDate = "";
    var lastModifiedTime = "";
    var lastModifiedUsername = "";
    var lastModifiedTerminal = "";
    var roelaAliasCuentaBancaria = "";
    var roelaCBUCuentaBancaria = "";
    var codigoBarrasPMCnPF = "";
    var codigoPMCnPF = "";
    var hash = "";
    var lockHash = "";
    var lockUsername = "";
    var lockTerminal = "";
    var lockDateTime = CommonDateTimeModel.fromDefault();
    var lockLastAccessDateTime = CommonDateTimeModel.fromDefault();
    var createdUsername = "";
    var createdTerminal = "";
    var createdDateTime = CommonDateTimeModel.fromDefault();
    var fromType = "default";
    var environment = pEmpresa.environment;
    var eEmpresa = pEmpresa;
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
    var eCondicionDeVenta = TableCondicionDeVentaModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eCategoriaDeIVA = TableCategoriaDeIVAModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eAFIPWSFETipoDeDocuemnto = TableAFIPWSFETiposDeDocumentos.fromDefault(
      pEmpresa: pEmpresa,
    );
    return TableClienteV2Model._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocial: razonSocial,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codPostal: codPostal,
      codigoBarrio: codigoBarrio,
      descripcionCodigoBarrio: descripcionCodigoBarrio,
      telefono: telefono,
      email: email,
      codCondVta: codCondVta,
      descripcionCodCondVta: descripcionCodCondVta,
      fechaNacIniAct: fechaNacIniAct,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      cuit: cuit,
      nroDoc: nroDoc,
      observaciones: observaciones,
      fechaAlta: fechaAlta,
      saldoActual: saldoActual,
      saldoInicial: saldoInicial,
      ultFechaActSaldo: ultFechaActSaldo,
      ultFechaVenta: ultFechaVenta,
      ultFechaCobro: ultFechaCobro,
      cicloFacturacion: cicloFacturacion,
      ultPeriodoFacturacion: ultPeriodoFacturacion,
      fechaUltPeriodoFacturacion: fechaUltPeriodoFacturacion,
      codigoTpoDocFE: codigoTpoDocFE,
      descripcionCodigoTpoDocFE: descripcionCodigoTpoDocFE,
      facturacionElectronica: facturacionElectronica,
      moduloDATOS: moduloDATOS,
      estado: estado,
      fechaUltCbioEstado: fechaUltCbioEstado,
      intranetUsername: intranetUsername,
      intranetPassword: intranetPassword,
      moduloVOZ: moduloVOZ,
      tag: tag,
      numeroDeCuenta: numeroDeCuenta,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      torre: torre,
      sector: sector,
      moduloTELEVISION: moduloTELEVISION,
      lastModifiedDate: lastModifiedDate,
      lastModifiedTime: lastModifiedTime,
      lastModifiedUsername: lastModifiedUsername,
      lastModifiedTerminal: lastModifiedTerminal,
      roelaAliasCuentaBancaria: roelaAliasCuentaBancaria,
      roelaCBUCuentaBancaria: roelaCBUCuentaBancaria,
      codigoBarrasPMCnPF: codigoBarrasPMCnPF,
      codigoPMCnPF: codigoPMCnPF,
      hash: hash,
      lockHash: lockHash,
      lockUsername: lockUsername,
      lockTerminal: lockTerminal,
      lockDateTime: lockDateTime,
      lockLastAccessDateTime: lockLastAccessDateTime,
      createdUsername: createdUsername,
      createdTerminal: createdTerminal,
      createdDateTime: createdDateTime,
      fromType: fromType,
      environment: environment,
      eEmpresa: eEmpresa,
      ePais: ePais,
      eProvincia: eProvincia,
      eCiudad: eCiudad,
      eBarrioCiudad: eBarrioCiudad,
      eCondicionDeVenta: eCondicionDeVenta,
      eCategoriaDeIVA: eCategoriaDeIVA,
      eAFIPWSFETipoDeDocuemnto: eAFIPWSFETipoDeDocuemnto,
    );
  }

  /// If we create an object from key
  ///
  factory TableClienteV2Model.fromKey(
      {required TableEmpresaModel pEmpresa,
      required String pTipoCliente,
      required int pCodClie,
      required String pRazonSocial}) {
    var codEmp = pEmpresa.codEmp;
    var razonSocialCodEmp = pEmpresa.razonSocial;
    var tipoCliente = pTipoCliente;
    var codClie = pCodClie;
    var razonSocial = pRazonSocial;
    var domicilio = "";
    var nroPuerta = "";
    var piso = "";
    var depto = "";
    var codPais = 0;
    var descripcionCodPais = "";
    var codPcia = 0;
    var descripcionCodPcia = "";
    var codCdad = 0;
    var descripcionCodCdad = "";
    var codPostal = "";
    var codigoBarrio = 0;
    var descripcionCodigoBarrio = "";
    var telefono = "";
    var email = "";
    var codCondVta = 0;
    var descripcionCodCondVta = "";
    var fechaNacIniAct = CommonDateModel.fromDefault();
    var codCatIVA = "";
    var descripcionCodCatIVA = "";
    var cuit = "";
    var nroDoc = "";
    var observaciones = "";
    var fechaAlta = CommonDateModel.fromDefault();
    var saldoActual = CommonNumbersModel.newNumbers();
    var saldoInicial = CommonNumbersModel.newNumbers();
    var ultFechaActSaldo = CommonDateModel.fromDefault();
    var ultFechaVenta = CommonDateModel.fromDefault();
    var ultFechaCobro = CommonDateModel.fromDefault();
    var cicloFacturacion = "";
    var ultPeriodoFacturacion = CommonDateModel.fromDefault();
    var fechaUltPeriodoFacturacion = CommonDateModel.fromDefault();
    var codigoTpoDocFE = 0;
    var descripcionCodigoTpoDocFE = "";
    var facturacionElectronica = CommonBooleanModel.newBoolean();
    var moduloDATOS = CommonBooleanModel.newBoolean();
    var moduloVOZ = CommonBooleanModel.newBoolean();
    var moduloTELEVISION = CommonBooleanModel.newBoolean();
    var estado = "";
    var fechaUltCbioEstado = CommonDateModel.fromDefault();
    var intranetUsername = "";
    var intranetPassword = "";
    var tag = "";
    var numeroDeCuenta = "";
    var torre = "";
    var sector = "";
    var lastModifiedDate = "";
    var lastModifiedTime = "";
    var lastModifiedUsername = "";
    var lastModifiedTerminal = "";
    var roelaAliasCuentaBancaria = "";
    var roelaCBUCuentaBancaria = "";
    var codigoBarrasPMCnPF = "";
    var codigoPMCnPF = "";
    var hash = "";
    var lockHash = "";
    var lockUsername = "";
    var lockTerminal = "";
    var lockDateTime = CommonDateTimeModel.fromDefault();
    var lockLastAccessDateTime = CommonDateTimeModel.fromDefault();
    var createdUsername = "";
    var createdTerminal = "";
    var createdDateTime = CommonDateTimeModel.fromDefault();
    var fromType = "default";
    var environment = pEmpresa.environment;
    var eEmpresa = pEmpresa;
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
    var eCondicionDeVenta = TableCondicionDeVentaModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eCategoriaDeIVA = TableCategoriaDeIVAModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eAFIPWSFETipoDeDocuemnto = TableAFIPWSFETiposDeDocumentos.fromDefault(
      pEmpresa: pEmpresa,
    );
    return TableClienteV2Model._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocial: razonSocial,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codPostal: codPostal,
      codigoBarrio: codigoBarrio,
      descripcionCodigoBarrio: descripcionCodigoBarrio,
      telefono: telefono,
      email: email,
      codCondVta: codCondVta,
      descripcionCodCondVta: descripcionCodCondVta,
      fechaNacIniAct: fechaNacIniAct,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      cuit: cuit,
      nroDoc: nroDoc,
      observaciones: observaciones,
      fechaAlta: fechaAlta,
      saldoActual: saldoActual,
      saldoInicial: saldoInicial,
      ultFechaActSaldo: ultFechaActSaldo,
      ultFechaVenta: ultFechaVenta,
      ultFechaCobro: ultFechaCobro,
      cicloFacturacion: cicloFacturacion,
      ultPeriodoFacturacion: ultPeriodoFacturacion,
      fechaUltPeriodoFacturacion: fechaUltPeriodoFacturacion,
      codigoTpoDocFE: codigoTpoDocFE,
      descripcionCodigoTpoDocFE: descripcionCodigoTpoDocFE,
      facturacionElectronica: facturacionElectronica,
      moduloDATOS: moduloDATOS,
      estado: estado,
      fechaUltCbioEstado: fechaUltCbioEstado,
      intranetUsername: intranetUsername,
      intranetPassword: intranetPassword,
      moduloVOZ: moduloVOZ,
      tag: tag,
      numeroDeCuenta: numeroDeCuenta,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      torre: torre,
      sector: sector,
      moduloTELEVISION: moduloTELEVISION,
      lastModifiedDate: lastModifiedDate,
      lastModifiedTime: lastModifiedTime,
      lastModifiedUsername: lastModifiedUsername,
      lastModifiedTerminal: lastModifiedTerminal,
      roelaAliasCuentaBancaria: roelaAliasCuentaBancaria,
      roelaCBUCuentaBancaria: roelaCBUCuentaBancaria,
      codigoBarrasPMCnPF: codigoBarrasPMCnPF,
      codigoPMCnPF: codigoPMCnPF,
      hash: hash,
      lockHash: lockHash,
      lockUsername: lockUsername,
      lockTerminal: lockTerminal,
      lockDateTime: lockDateTime,
      lockLastAccessDateTime: lockLastAccessDateTime,
      createdUsername: createdUsername,
      createdTerminal: createdTerminal,
      createdDateTime: createdDateTime,
      fromType: fromType,
      environment: environment,
      eEmpresa: eEmpresa,
      ePais: ePais,
      eProvincia: eProvincia,
      eCiudad: eCiudad,
      eBarrioCiudad: eBarrioCiudad,
      eCondicionDeVenta: eCondicionDeVenta,
      eCategoriaDeIVA: eCategoriaDeIVA,
      eAFIPWSFETipoDeDocuemnto: eAFIPWSFETipoDeDocuemnto,
    );
  }

  /// If we create an object from default
  ///
  factory TableClienteV2Model.noRecordFound({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    var codEmp = pEmpresa.codEmp;
    var razonSocialCodEmp = pEmpresa.razonSocial;
    var tipoCliente = 'Cliente';
    var codClie = -1;
    var filter = pFilter.isEmpty ? "" : "[$pFilter]";
    var razonSocial = "NO HAY REGISTRO(s) s/Filtro $filter";
    var domicilio = "";
    var nroPuerta = "";
    var piso = "";
    var depto = "";
    var codPais = 0;
    var descripcionCodPais = "";
    var codPcia = 0;
    var descripcionCodPcia = "";
    var codCdad = 0;
    var descripcionCodCdad = "";
    var codPostal = "";
    var codigoBarrio = 0;
    var descripcionCodigoBarrio = "";
    var telefono = "";
    var email = "";
    var codCondVta = 0;
    var descripcionCodCondVta = "";
    var fechaNacIniAct = CommonDateModel.fromDefault();
    var codCatIVA = "";
    var descripcionCodCatIVA = "";
    var cuit = "";
    var nroDoc = "";
    var observaciones = "";
    var fechaAlta = CommonDateModel.fromDefault();
    var saldoActual = CommonNumbersModel.newNumbers();
    var saldoInicial = CommonNumbersModel.newNumbers();
    var ultFechaActSaldo = CommonDateModel.fromDefault();
    var ultFechaVenta = CommonDateModel.fromDefault();
    var ultFechaCobro = CommonDateModel.fromDefault();
    var cicloFacturacion = "";
    var ultPeriodoFacturacion = CommonDateModel.fromDefault();
    var fechaUltPeriodoFacturacion = CommonDateModel.fromDefault();
    var codigoTpoDocFE = 0;
    var descripcionCodigoTpoDocFE = "";
    var facturacionElectronica = CommonBooleanModel.newBoolean();
    var moduloDATOS = CommonBooleanModel.newBoolean();
    var moduloVOZ = CommonBooleanModel.newBoolean();
    var moduloTELEVISION = CommonBooleanModel.newBoolean();
    var estado = "";
    var fechaUltCbioEstado = CommonDateModel.fromDefault();
    var intranetUsername = "";
    var intranetPassword = "";
    var tag = "";
    var numeroDeCuenta = "";
    var torre = "";
    var sector = "";
    var lastModifiedDate = "";
    var lastModifiedTime = "";
    var lastModifiedUsername = "";
    var lastModifiedTerminal = "";
    var roelaAliasCuentaBancaria = "";
    var roelaCBUCuentaBancaria = "";
    var codigoBarrasPMCnPF = "";
    var codigoPMCnPF = "";
    var hash = "";
    var lockHash = "";
    var lockUsername = "";
    var lockTerminal = "";
    var lockDateTime = CommonDateTimeModel.fromDefault();
    var lockLastAccessDateTime = CommonDateTimeModel.fromDefault();
    var createdUsername = "";
    var createdTerminal = "";
    var createdDateTime = CommonDateTimeModel.fromDefault();
    var fromType = "default";
    var environment = pEmpresa.environment;
    var eEmpresa = pEmpresa;
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
    var eCondicionDeVenta = TableCondicionDeVentaModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eCategoriaDeIVA = TableCategoriaDeIVAModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eAFIPWSFETipoDeDocuemnto = TableAFIPWSFETiposDeDocumentos.fromDefault(
      pEmpresa: pEmpresa,
    );
    return TableClienteV2Model._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocial: razonSocial,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codPostal: codPostal,
      codigoBarrio: codigoBarrio,
      descripcionCodigoBarrio: descripcionCodigoBarrio,
      telefono: telefono,
      email: email,
      codCondVta: codCondVta,
      descripcionCodCondVta: descripcionCodCondVta,
      fechaNacIniAct: fechaNacIniAct,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      cuit: cuit,
      nroDoc: nroDoc,
      observaciones: observaciones,
      fechaAlta: fechaAlta,
      saldoActual: saldoActual,
      saldoInicial: saldoInicial,
      ultFechaActSaldo: ultFechaActSaldo,
      ultFechaVenta: ultFechaVenta,
      ultFechaCobro: ultFechaCobro,
      cicloFacturacion: cicloFacturacion,
      ultPeriodoFacturacion: ultPeriodoFacturacion,
      fechaUltPeriodoFacturacion: fechaUltPeriodoFacturacion,
      codigoTpoDocFE: codigoTpoDocFE,
      descripcionCodigoTpoDocFE: descripcionCodigoTpoDocFE,
      facturacionElectronica: facturacionElectronica,
      moduloDATOS: moduloDATOS,
      estado: estado,
      fechaUltCbioEstado: fechaUltCbioEstado,
      intranetUsername: intranetUsername,
      intranetPassword: intranetPassword,
      moduloVOZ: moduloVOZ,
      tag: tag,
      numeroDeCuenta: numeroDeCuenta,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      torre: torre,
      sector: sector,
      moduloTELEVISION: moduloTELEVISION,
      lastModifiedDate: lastModifiedDate,
      lastModifiedTime: lastModifiedTime,
      lastModifiedUsername: lastModifiedUsername,
      lastModifiedTerminal: lastModifiedTerminal,
      roelaAliasCuentaBancaria: roelaAliasCuentaBancaria,
      roelaCBUCuentaBancaria: roelaCBUCuentaBancaria,
      codigoBarrasPMCnPF: codigoBarrasPMCnPF,
      codigoPMCnPF: codigoPMCnPF,
      hash: hash,
      lockHash: lockHash,
      lockUsername: lockUsername,
      lockTerminal: lockTerminal,
      lockDateTime: lockDateTime,
      lockLastAccessDateTime: lockLastAccessDateTime,
      createdUsername: createdUsername,
      createdTerminal: createdTerminal,
      createdDateTime: createdDateTime,
      fromType: fromType,
      environment: environment,
      eEmpresa: eEmpresa,
      ePais: ePais,
      eProvincia: eProvincia,
      eCiudad: eCiudad,
      eBarrioCiudad: eBarrioCiudad,
      eCondicionDeVenta: eCondicionDeVenta,
      eCategoriaDeIVA: eCategoriaDeIVA,
      eAFIPWSFETipoDeDocuemnto: eAFIPWSFETipoDeDocuemnto,
    );
  }

  /// If we create an object from default
  ///
  factory TableClienteV2Model.fromError({
    required TableEmpresaModel pEmpresa,
    String pFilter = "",
  }) {
    var codEmp = pEmpresa.codEmp;
    var razonSocialCodEmp = pEmpresa.razonSocial;
    var tipoCliente = 'Cliente';
    var codClie = -1;
    var filter = pFilter.isEmpty ? "" : "[$pFilter]";
    var razonSocial = "NO HAY REGISTRO(s) s/error $filter";
    var domicilio = "";
    var nroPuerta = "";
    var piso = "";
    var depto = "";
    var codPais = 0;
    var descripcionCodPais = "";
    var codPcia = 0;
    var descripcionCodPcia = "";
    var codCdad = 0;
    var descripcionCodCdad = "";
    var codPostal = "";
    var codigoBarrio = 0;
    var descripcionCodigoBarrio = "";
    var telefono = "";
    var email = "";
    var codCondVta = 0;
    var descripcionCodCondVta = "";
    var fechaNacIniAct = CommonDateModel.fromDefault();
    var codCatIVA = "";
    var descripcionCodCatIVA = "";
    var cuit = "";
    var nroDoc = "";
    var observaciones = "";
    var fechaAlta = CommonDateModel.fromDefault();
    var saldoActual = CommonNumbersModel.newNumbers();
    var saldoInicial = CommonNumbersModel.newNumbers();
    var ultFechaActSaldo = CommonDateModel.fromDefault();
    var ultFechaVenta = CommonDateModel.fromDefault();
    var ultFechaCobro = CommonDateModel.fromDefault();
    var cicloFacturacion = "";
    var ultPeriodoFacturacion = CommonDateModel.fromDefault();
    var fechaUltPeriodoFacturacion = CommonDateModel.fromDefault();
    var codigoTpoDocFE = 0;
    var descripcionCodigoTpoDocFE = "";
    var facturacionElectronica = CommonBooleanModel.newBoolean();
    var moduloDATOS = CommonBooleanModel.newBoolean();
    var moduloVOZ = CommonBooleanModel.newBoolean();
    var moduloTELEVISION = CommonBooleanModel.newBoolean();
    var estado = "";
    var fechaUltCbioEstado = CommonDateModel.fromDefault();
    var intranetUsername = "";
    var intranetPassword = "";
    var tag = "";
    var numeroDeCuenta = "";
    var torre = "";
    var sector = "";
    var lastModifiedDate = "";
    var lastModifiedTime = "";
    var lastModifiedUsername = "";
    var lastModifiedTerminal = "";
    var roelaAliasCuentaBancaria = "";
    var roelaCBUCuentaBancaria = "";
    var codigoBarrasPMCnPF = "";
    var codigoPMCnPF = "";
    var hash = "";
    var lockHash = "";
    var lockUsername = "";
    var lockTerminal = "";
    var lockDateTime = CommonDateTimeModel.fromDefault();
    var lockLastAccessDateTime = CommonDateTimeModel.fromDefault();
    var createdUsername = "";
    var createdTerminal = "";
    var createdDateTime = CommonDateTimeModel.fromDefault();
    var fromType = "default";
    var environment = pEmpresa.environment;
    var eEmpresa = pEmpresa;
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
    var eCondicionDeVenta = TableCondicionDeVentaModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eCategoriaDeIVA = TableCategoriaDeIVAModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    var eAFIPWSFETipoDeDocuemnto = TableAFIPWSFETiposDeDocumentos.fromDefault(
      pEmpresa: pEmpresa,
    );
    return TableClienteV2Model._internal(
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocial: razonSocial,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      codPostal: codPostal,
      codigoBarrio: codigoBarrio,
      descripcionCodigoBarrio: descripcionCodigoBarrio,
      telefono: telefono,
      email: email,
      codCondVta: codCondVta,
      descripcionCodCondVta: descripcionCodCondVta,
      fechaNacIniAct: fechaNacIniAct,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      cuit: cuit,
      nroDoc: nroDoc,
      observaciones: observaciones,
      fechaAlta: fechaAlta,
      saldoActual: saldoActual,
      saldoInicial: saldoInicial,
      ultFechaActSaldo: ultFechaActSaldo,
      ultFechaVenta: ultFechaVenta,
      ultFechaCobro: ultFechaCobro,
      cicloFacturacion: cicloFacturacion,
      ultPeriodoFacturacion: ultPeriodoFacturacion,
      fechaUltPeriodoFacturacion: fechaUltPeriodoFacturacion,
      codigoTpoDocFE: codigoTpoDocFE,
      descripcionCodigoTpoDocFE: descripcionCodigoTpoDocFE,
      facturacionElectronica: facturacionElectronica,
      moduloDATOS: moduloDATOS,
      estado: estado,
      fechaUltCbioEstado: fechaUltCbioEstado,
      intranetUsername: intranetUsername,
      intranetPassword: intranetPassword,
      moduloVOZ: moduloVOZ,
      tag: tag,
      numeroDeCuenta: numeroDeCuenta,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      torre: torre,
      sector: sector,
      moduloTELEVISION: moduloTELEVISION,
      lastModifiedDate: lastModifiedDate,
      lastModifiedTime: lastModifiedTime,
      lastModifiedUsername: lastModifiedUsername,
      lastModifiedTerminal: lastModifiedTerminal,
      roelaAliasCuentaBancaria: roelaAliasCuentaBancaria,
      roelaCBUCuentaBancaria: roelaCBUCuentaBancaria,
      codigoBarrasPMCnPF: codigoBarrasPMCnPF,
      codigoPMCnPF: codigoPMCnPF,
      hash: hash,
      lockHash: lockHash,
      lockUsername: lockUsername,
      lockTerminal: lockTerminal,
      lockDateTime: lockDateTime,
      lockLastAccessDateTime: lockLastAccessDateTime,
      createdUsername: createdUsername,
      createdTerminal: createdTerminal,
      createdDateTime: createdDateTime,
      fromType: fromType,
      environment: environment,
      eEmpresa: eEmpresa,
      ePais: ePais,
      eProvincia: eProvincia,
      eCiudad: eCiudad,
      eBarrioCiudad: eBarrioCiudad,
      eCondicionDeVenta: eCondicionDeVenta,
      eCategoriaDeIVA: eCategoriaDeIVA,
      eAFIPWSFETipoDeDocuemnto: eAFIPWSFETipoDeDocuemnto,
    );
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableClienteV2Model fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
    TableEmpresaModel? pEmpresa,
    int pVersion = 2,
  }) {
    return TableClienteV2Model.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: TableEmpresaModel.fromDefault(),
      pVersion: pVersion,
    );
  }

  /// If we create an object from default
  ///
  factory TableClienteV2Model.fromJsonGral({
    required Map<String, dynamic> map,
    required int errorCode,
    required TableEmpresaModel pEmpresa,
    int pVersion = 2,
  }) {
    String functionName = "fromJson";
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';

    try {
      int codEmp = -1;
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
      codEmp = int.parse(map['CodEmp'].toString());
      var razonSocialCodEmp = map['RazonSocialCodEmp'].toString();
      var tipoCliente = map['TipoCliente'].toString();
      var codClie = -1;
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
      codClie = int.parse(map['CodClie'].toString());
      var razonSocial = map['RazonSocial'].toString();
      String domicilio = map['Domicilio'].toString();
      String nroPuerta = map['NroPuerta'].toString();
      String piso = map['Piso'].toString();
      String depto = map['Depto'].toString();

      var codPais = -1;
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
      codPais = int.parse(map['CodPais'].toString());
      String descripcionCodPais = map['DescripcionCodPais'].toString();

      var codPcia = -1;
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
      codPcia = int.parse(map['CodPcia'].toString());
      String descripcionCodPcia = map['DescripcionCodPcia'].toString();

      var codCdad = -1;
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
      codCdad = int.parse(map['CodCdad'].toString());
      String descripcionCodCdad = map['DescripcionCodCdad'].toString();
      String codPostal = map['CodPostal'].toString();

      var codigoBarrio = -1;
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
      codigoBarrio = int.parse(map['CodigoBarrio'].toString());
      String descripcionCodigoBarrio =
          map['DescripcionCodigoBarrio'].toString();
      String telefono = map['Telefono'].toString();
      String email = map['EMail'].toString();

      var codCondVta = -1;
      if (int.tryParse(map['CodCondVta'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodCondVta',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      codCondVta = int.parse(map['CodCondVta'].toString());
      String descripcionCodCondVta = map['DescripcionCodCondVta'].toString();
      //String fechaNacIniAct = map['FechaNacIniAct'].toString();
      //String fechaNacIniAct = map['FechaNacIniActSQL'] ?? '0000-00-00';

      String codCatIVA = map['CodCatIVA'].toString();
      String descripcionCodCatIVA = map['DescripcionCodCatIVA'].toString();
      log("Build_Fiscal: fromJson - ${map["DescripcionCodCatIVA"]} ${map["CodCatIVA"]} $map");
      String cuit = map['CUIT'].toString();
      String nroDoc = map['NroDoc'].toString();
      String observaciones = map['Observaciones'].toString();
      //String fechaAlta = map['FechaAlta'].toString();
      //String fechaAlta = map['FechaAltaSQL'] ?? '0000-00-00';

      var rSaldoActual = CommonNumbersModel.tryParse(
        map['SaldoActual'],
        fieldName: 'SaldoActual',
      );
      if (rSaldoActual.errorCode != 0) {
        throw ErrorHandler(
          errorCode: rSaldoActual.errorCode,
          errorDsc: rSaldoActual.errorDsc,
          className: className,
          functionName: functionName,
          propertyName: 'SaldoActual',
          propertyValue: map["SaldoActual"],
          stacktrace: StackTrace.current,
        );
      }
      var saldoActual = rSaldoActual.data;

      var rSaldoInicial = CommonNumbersModel.tryParse(
        map['SaldoInicial'],
      );
      if (rSaldoInicial.errorCode != 0) {
        throw ErrorHandler(
          errorCode: rSaldoInicial.errorCode,
          errorDsc: rSaldoInicial.errorDsc,
          className: className,
          functionName: functionName,
          propertyName: 'SaldoInicial',
          propertyValue: map["SaldoInicial"],
          stacktrace: StackTrace.current,
        );
      }
      var saldoInicial = rSaldoInicial.data;
      var fechaNacIniAct = CommonDateModel.fromDefault();
      var fechaAlta = CommonDateModel.fromDefault();
      var ultFechaActSaldo = CommonDateModel.fromDefault();
      var ultFechaVenta = CommonDateModel.fromDefault();
      var ultFechaCobro = CommonDateModel.fromDefault();
      var fechaUltCbioEstado = CommonDateModel.fromDefault();
      var ultPeriodoFacturacion = CommonDateModel.fromDefault();
      var fechaUltPeriodoFacturacion = CommonDateModel.fromDefault();
      switch (pVersion) {
        case 2:
          fechaAlta = CommonDateModel.parse(
            map['FechaAlta'],
            fieldName: 'FechaAlta',
          );
          fechaNacIniAct = CommonDateModel.parse(
            map['FechaNacIniAct'],
            fieldName: 'FechaNacIniAct',
          );
          ultFechaActSaldo = CommonDateModel.parse(
            map['UltFechaActSaldo'],
            fieldName: 'UltFechaActSaldo',
          );
          ultFechaVenta = CommonDateModel.parse(
            map['UltFechaVenta'],
            fieldName: 'UltFechaVenta',
          );
          ultFechaCobro = CommonDateModel.parse(
            map['UltFechaCobro'],
            fieldName: 'UltFechaCobro',
          );
          fechaUltCbioEstado = CommonDateModel.parse(
            map['FechaUltCbioEstado'],
            fieldName: 'FechaUltCbioEstado',
          );
          ultPeriodoFacturacion = CommonDateModel.parse(
            map['UltPeriodoFacturacion'],
            fieldName: 'UltPeriodoFacturacion',
          );
          fechaUltPeriodoFacturacion = CommonDateModel.parse(
            map['FechaUltPeriodoFacturacion'],
            fieldName: 'FechaUltPeriodoFacturacion',
          );
          break;
        default:
          fechaAlta = CommonDateModel.parse(
            map['FechaAltaSQL'],
            fieldName: 'FechaAltaSQL',
          );
          fechaNacIniAct = CommonDateModel.parse(
            map['FechaNacIniActSQL'],
            fieldName: 'FechaNacIniActSQL',
          );
          ultFechaActSaldo = CommonDateModel.parse(
            map['UltFechaActSaldoSQL'],
            fieldName: 'UltFechaActSaldoSQL',
          );
          ultFechaVenta = CommonDateModel.parse(
            map['UltFechaVentaSQL'],
            fieldName: 'UltFechaVentaSQL',
          );
          ultFechaCobro = CommonDateModel.parse(
            map['UltFechaCobroSQL'],
            fieldName: 'UltFechaCobroSQL',
          );
          fechaUltCbioEstado = CommonDateModel.parse(
            map['FechaUltCbioEstadoSQL'],
            fieldName: 'FechaUltCbioEstadoSQL',
          );
          ultPeriodoFacturacion = CommonDateModel.parse(
            map['UltPeriodoFacturacionSQL'],
            fieldName: 'UltPeriodoFacturacionSQL',
          );
          fechaUltPeriodoFacturacion = CommonDateModel.parse(
            map['FechaUltPeriodoFacturacionSQL'],
            fieldName: 'FechaUltPeriodoFacturacionSQL',
          );
      }
      String cicloFacturacion = map['CicloFacturacion'].toString();

      var codigoTpoDocFE = -1;
      if (int.tryParse(map['CodigoTpoDocFE'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CodigoTpoDocFE',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      codigoTpoDocFE = int.parse(map['CodigoTpoDocFE'].toString());
      String descripcionCodigoTpoDocFE =
          map['DescripcionCodigoTpoDocFE'].toString();
      var rFacturacionElectronica = CommonBooleanModel.parse(
        map['FacturacionElectronica'].toString(),
        fieldName: 'FacturacionElectronica',
      );
      if (rFacturacionElectronica.errorCode != 0) {
        throw ErrorHandler(
          errorCode: rFacturacionElectronica.errorCode,
          errorDsc: rFacturacionElectronica.errorDsc,
          propertyName: 'FacturacionElectronica',
          propertyValue: map['FacturacionElectronica'].toString(),
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      var facturacionElectronica = rFacturacionElectronica.data;
      var rModuloDATOS = CommonBooleanModel.parse(
        map['ModuloDATOS'].toString(),
        fieldName: 'ModuloDATOS',
      );
      if (rModuloDATOS.errorCode != 0) {
        throw ErrorHandler(
          errorCode: rModuloDATOS.errorCode,
          errorDsc: rModuloDATOS.errorDsc,
          propertyName: 'ModuloDATOS',
          propertyValue: map['ModuloDATOS'].toString(),
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      var moduloDATOS = rModuloDATOS.data;
      var rModuloVOZ = CommonBooleanModel.parse(
        map['ModuloVOZ'].toString(),
        fieldName: 'ModuloVOZ',
      );
      if (rModuloVOZ.errorCode != 0) {
        throw ErrorHandler(
          errorCode: rModuloVOZ.errorCode,
          errorDsc: rModuloVOZ.errorDsc,
          propertyName: 'ModuloVOZ',
          propertyValue: map['ModuloVOZ'].toString(),
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      var moduloVOZ = rModuloVOZ.data;
      var rModuloTELEVISION = CommonBooleanModel.parse(
        map['ModuloTELEVISION'].toString(),
        fieldName: 'ModuloTELEVISION',
      );
      if (rModuloTELEVISION.errorCode != 0) {
        throw ErrorHandler(
          errorCode: rModuloTELEVISION.errorCode,
          errorDsc: rModuloTELEVISION.errorDsc,
          propertyName: 'ModuloTELEVISION',
          propertyValue: map['ModuloTELEVISION'].toString(),
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      var moduloTELEVISION = rModuloTELEVISION.data;
      String estado = map['Estado'].toString();
      String intranetUsername = map['IntranetUsername'].toString();
      String intranetPassword = map['IntranetPassword'].toString();
      String tag = map['TAG'].toString();
      String numeroDeCuenta = map['NumeroDeCuenta'].toString();
      String torre = map['Torre'].toString();
      String sector = map['Sector'].toString();
      String lastModifiedDate = map['LastModifiedDate'].toString();
      String lastModifiedTime = map['LastModifiedTime'].toString();
      String lastModifiedUsername = map['LastModifiedUsername'].toString();
      String lastModifiedTerminal = map['LastModifiedTerminal'].toString();
      String roelaAliasCuentaBancaria =
          map['RoelaAliasCuentaBancaria'].toString();
      String roelaCBUCuentaBancaria = map['RoelaCBUCuentaBancaria'].toString();
      String codigoPMCnPF = map['CodigoPMCnPF'].toString();
      String codigoBarrasPMCnPF = map['CodigoBarrasPMCnPF'].toString();

      String hash = map['Hash'].toString();
      String lockHash = map['LockHash'].toString();
      String lockUsername = map['LockUsername'].toString();
      String lockTerminal = map['LockTerminal'].toString();
      CommonDateTimeModel lockDateTime = CommonDateTimeModel.parse(
        map['LockDateTime'],
        fieldName: 'LockDateTime',
      );
      CommonDateTimeModel lockLastAccessDateTime = CommonDateTimeModel.parse(
        map['LockLastAccessDateTime'],
        fieldName: 'LockLastAccessDateTime',
      );
      String createdUsername = map['CreatedUsername'].toString();
      String createdTerminal = map['CreatedTerminal'].toString();
      CommonDateTimeModel createdDateTime = CommonDateTimeModel.parse(
        map['CreatedDateTime'],
        fieldName: 'CreatedDateTime',
      );
      var fromType = "Json";
      var environment = map['Environment'].toString();

      /// Objects
      ///
      if (pEmpresa.environment == 'default') {
        pEmpresa.codEmp = codEmp;
        pEmpresa.razonSocial = razonSocialCodEmp;
        pEmpresa.environment = environment;
      }
      var eEmpresa = pEmpresa;
      // if (map['Empresa'] != null) {
      if (!isNull(map['Empresa'])) {
        eEmpresa = TableEmpresaModel.fromJson(map["Empresa"]);
      }
      var ePais = TablePaisModel.fromKey(
        pEmpresa: pEmpresa,
        pCodPais: codPais,
        pDescripcion: descripcionCodPais,
        pEnvironment: environment,
      );
      //if (map['Pais'] != null) {
      if (!isNull(map['Pais'])) {
        ePais = TablePaisModel.fromJson(
          map: map["Pais"],
          errorCode: errorCode,
          pEmpresa: eEmpresa,
        );
      }
      var eProvincia = TableProvinciaModel.fromKey(
        pEmpresa: pEmpresa,
        pPais: ePais,
        pCodPcia: codPcia,
        pDescripcion: descripcionCodPcia,
        pEnvironment: environment,
      );
      if (!isNull(map['Provincia'])) {
        eProvincia = TableProvinciaModel.fromJson(
          map: map["Provincia"],
          errorCode: errorCode,
          pEmpresa: eEmpresa,
          pPais: ePais,
        );
      }
      var eCiudad = TableCiudadModel.fromKey(
        pEmpresa: pEmpresa,
        pPais: ePais,
        pProvincia: eProvincia,
        pCodCdad: codCdad,
        pDescripcion: descripcionCodCdad,
        pEnvironment: environment,
      );
      if (!isNull(map['Ciudad'])) {
        eCiudad = TableCiudadModel.fromJson(
          map: map["Ciudad"],
          errorCode: errorCode,
          pEmpresa: eEmpresa,
          pPais: ePais,
          pProvincia: eProvincia,
        );
      }
      var eBarrioCiudad = TableDetBarrioCiudadModel.fromKey(
        pEmpresa: pEmpresa,
        pPais: ePais,
        pProvincia: eProvincia,
        pCiudad: eCiudad,
        pCodigoBarrio: codigoBarrio,
        pDescripcion: descripcionCodigoBarrio,
        pEnvironment: environment,
      );
      if (!isNull(map['BarrioCiudad'])) {
        eBarrioCiudad = TableDetBarrioCiudadModel.fromJson(
          map: map["BarrioCiudad"],
          errorCode: errorCode,
          pEmpresa: eEmpresa,
          pPais: ePais,
          pProvincia: eProvincia,
          pCiudad: eCiudad,
        );
      }
      var eCondicionDeVenta = TableCondicionDeVentaModel.fromKey(
        pEmpresa: pEmpresa,
        pCodigo: codCondVta,
        pDescripcion: descripcionCodCondVta,
        pEnvironment: environment,
      );
      if (map['CondicionDeVenta'] != null) {
        eCondicionDeVenta = TableCondicionDeVentaModel.fromJson(
          map: map["CondicionDeVenta"],
          errorCode: errorCode,
          pEmpresa: eEmpresa,
        );
      }
      var eCategoriaDeIVA = TableCategoriaDeIVAModel.fromKey(
        pEmpresa: pEmpresa,
        pCodCatIVA: codCatIVA,
        pDescripcion: descripcionCodCatIVA,
      );
      if (map['CategoriaDeIVA'] != null) {
        eCategoriaDeIVA = TableCategoriaDeIVAModel.fromJson2(
          map: map["CategoriaDeIVA"],
          errorCode: errorCode,
          pEmpresa: eEmpresa,
        );
      }
      var eAFIPWSFETipoDeDocuemnto = TableAFIPWSFETiposDeDocumentos.fromKey(
        pID: codigoTpoDocFE,
        pDescripcion: descripcionCodigoTpoDocFE,
        pEmpresa: eEmpresa,
      );
      log("Build_Fiscal: fromJson $eCategoriaDeIVA - $codCatIVA - $descripcionCodCatIVA");
      return TableClienteV2Model._internal(
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        tipoCliente: tipoCliente,
        codClie: codClie,
        razonSocial: razonSocial,
        domicilio: domicilio,
        nroPuerta: nroPuerta,
        piso: piso,
        depto: depto,
        codCdad: codCdad,
        descripcionCodCdad: descripcionCodCdad,
        codPostal: codPostal,
        codigoBarrio: codigoBarrio,
        descripcionCodigoBarrio: descripcionCodigoBarrio,
        telefono: telefono,
        email: email,
        codCondVta: codCondVta,
        descripcionCodCondVta: descripcionCodCondVta,
        fechaNacIniAct: fechaNacIniAct,
        codCatIVA: codCatIVA,
        descripcionCodCatIVA: descripcionCodCatIVA,
        cuit: cuit,
        nroDoc: nroDoc,
        observaciones: observaciones,
        fechaAlta: fechaAlta,
        saldoActual: saldoActual,
        saldoInicial: saldoInicial,
        ultFechaActSaldo: ultFechaActSaldo,
        ultFechaVenta: ultFechaVenta,
        ultFechaCobro: ultFechaCobro,
        cicloFacturacion: cicloFacturacion,
        ultPeriodoFacturacion: ultPeriodoFacturacion,
        fechaUltPeriodoFacturacion: fechaUltPeriodoFacturacion,
        codigoTpoDocFE: codigoTpoDocFE,
        descripcionCodigoTpoDocFE: descripcionCodigoTpoDocFE,
        facturacionElectronica: facturacionElectronica,
        moduloDATOS: moduloDATOS,
        estado: estado,
        fechaUltCbioEstado: fechaUltCbioEstado,
        intranetUsername: intranetUsername,
        intranetPassword: intranetPassword,
        moduloVOZ: moduloVOZ,
        tag: tag,
        numeroDeCuenta: numeroDeCuenta,
        codPais: codPais,
        descripcionCodPais: descripcionCodPais,
        codPcia: codPcia,
        descripcionCodPcia: descripcionCodPcia,
        torre: torre,
        sector: sector,
        moduloTELEVISION: moduloTELEVISION,
        lastModifiedDate: lastModifiedDate,
        lastModifiedTime: lastModifiedTime,
        lastModifiedUsername: lastModifiedUsername,
        lastModifiedTerminal: lastModifiedTerminal,
        roelaAliasCuentaBancaria: roelaAliasCuentaBancaria,
        roelaCBUCuentaBancaria: roelaCBUCuentaBancaria,
        codigoBarrasPMCnPF: codigoBarrasPMCnPF,
        codigoPMCnPF: codigoPMCnPF,
        hash: hash,
        lockHash: lockHash,
        lockUsername: lockUsername,
        lockTerminal: lockTerminal,
        lockDateTime: lockDateTime,
        lockLastAccessDateTime: lockLastAccessDateTime,
        createdUsername: createdUsername,
        createdTerminal: createdTerminal,
        createdDateTime: createdDateTime,
        fromType: fromType,
        environment: environment,
        eEmpresa: eEmpresa,
        ePais: ePais,
        eProvincia: eProvincia,
        eCiudad: eCiudad,
        eBarrioCiudad: eBarrioCiudad,
        eCondicionDeVenta: eCondicionDeVenta,
        eCategoriaDeIVA: eCategoriaDeIVA,
        eAFIPWSFETipoDeDocuemnto: eAFIPWSFETipoDeDocuemnto,
      );
    } catch (e, stacktrace) {
      if (e is ErrorHandler) {
        e.stacktrace ??= stacktrace;
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 888999,
          errorDsc: '<sub> ${e.toString()}',
          className: className,
          functionName: functionName,
          propertyName: '<desconocido>',
          propertyValue: '<desconocido>',
          stacktrace: stacktrace,
        );
      }
    }
  }

  /// Object toJson standard
  @override
  Map<String, dynamic> toJson() {
    return {
      'CodEmp': codEmp,
      'RazonSocialCodEmp': razonSocialCodEmp,
      'TipoCliente': tipoCliente,
      'CodClie': codClie,
      'RazonSocial': razonSocial,
      'Domicilio': domicilio,
      'NroPuerta': nroPuerta,
      'Piso': piso,
      'Depto': depto,
      'CodCdad': codCdad,
      'DescripcionCodCdad': descripcionCodCdad,
      'CodPostal': codPostal,
      'CodigoBarrio': codigoBarrio,
      'DescripcionCodigoBarrio': descripcionCodigoBarrio,
      'Telefono': telefono,
      'Email': email,
      'CodCondVta': codCondVta,
      'DescripcionCodCondVta': descripcionCodCondVta,
      'FechaNacIniAct': fechaNacIniAct,
      'CodCatIVA': codCatIVA,
      'DescripcionCodCatIVA': descripcionCodCatIVA,
      'CUIT': cuit,
      'NroDoc': nroDoc,
      'Observaciones': observaciones,
      'FechaAlta': fechaAlta,
      'SaldoActual': saldoActual,
      'SaldoInicial': saldoInicial,
      'UltFechaActSaldo': ultFechaActSaldo,
      'UltFechaVenta': ultFechaVenta,
      'UltFechaCobro': ultFechaCobro,
      'CicloFacturacion': cicloFacturacion,
      'UltPeriodoFacturacion': ultPeriodoFacturacion,
      'FechaUltPeriodoFacturacion': fechaUltPeriodoFacturacion,
      'CodigoTpoDocFE': codigoTpoDocFE,
      'DescripcionCodigoTpoDocFE': descripcionCodigoTpoDocFE,
      'FacturacionElectronica': facturacionElectronica,
      'ModuloDATOS': moduloDATOS,
      'Estado': estado,
      'FechaUltCbioEstado': fechaUltCbioEstado,
      'IntranetUsername': intranetUsername,
      'IntranetPassword': intranetPassword,
      'ModuloVOZ': moduloVOZ,
      'TAG': tag,
      'NumeroDeCuenta': numeroDeCuenta,
      'CodPais': codPais,
      'DescripcionCodPais': descripcionCodPais,
      'CodPcia': codPcia,
      'DescripcionCodPcia': descripcionCodPcia,
      'Torre': torre,
      'Sector': sector,
      'ModuloTELEVISION': moduloTELEVISION,
      'LastModifiedDate': lastModifiedDate,
      'LastModifiedTime': lastModifiedTime,
      'LastModifiedUsername': lastModifiedUsername,
      'LastModifiedTerminal': lastModifiedTerminal,
      'RoelaAliasCuentaBancaria': roelaAliasCuentaBancaria,
      'RoelaCBUCuentaBancaria': roelaCBUCuentaBancaria,
      'CodigoBarrasPMCnPF': codigoBarrasPMCnPF,
      'CodigoPMCnPF': codigoPMCnPF,
      'Hash': hash,
      'LockHash': lockHash,
      'LockUsername': lockUsername,
      'LoclTermianl': lockTerminal,
      'LockDateTime': lockDateTime,
      'LockLastAccessDateTime': lockLastAccessDateTime,
      'CreatedUsername': createdUsername,
      'CreatedTerminal': createdTerminal,
      'CreatedDateTime': createdDateTime,
      'FromType': fromType,
      'Environment': environment,
      'EEmpresa': eEmpresa,
      'EPais': ePais,
      'EProvincia': eProvincia,
      'ECiudad': eCiudad,
      'EBarrioCiudad': eBarrioCiudad,
      'ECondicionDeVenta': eCondicionDeVenta,
      'EAFIPWSFETipoDeDocuemnto': eAFIPWSFETipoDeDocuemnto,
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
      'razonSocial': razonSocial,
      'domicilio': domicilio,
      'nroPuerta': nroPuerta,
      'piso': piso,
      'depto': depto,
      'codCdad': codCdad,
      'descripcionCodCdad': descripcionCodCdad,
      'codPostal': codPostal,
      'codigoBarrio': codigoBarrio,
      'descripcionCodigoBarrio': descripcionCodigoBarrio,
      'telefono': telefono,
      'email': email,
      'codCondVta': codCondVta,
      'descripcionCodCondVta': descripcionCodCondVta,
      'fechaNacIniAct': fechaNacIniAct,
      'codCatIVA': codCatIVA,
      'descripcionCodCatIVA': descripcionCodCatIVA,
      'cuit': cuit,
      'nroDoc': nroDoc,
      'observaciones': observaciones,
      'fechaAlta': fechaAlta,
      'saldoActual': saldoActual,
      'saldoInicial': saldoInicial,
      'ultFechaActSaldo': ultFechaActSaldo,
      'ultFechaVenta': ultFechaVenta,
      'ultFechaCobro': ultFechaCobro,
      'cicloFacturacion': cicloFacturacion,
      'ultPeriodoFacturacion': ultPeriodoFacturacion,
      'fechaUltPeriodoFacturacion': fechaUltPeriodoFacturacion,
      'codigoTpoDocFE': codigoTpoDocFE,
      'descripcionCodigoTpoDocFE': descripcionCodigoTpoDocFE,
      'facturacionElectronica': facturacionElectronica,
      'moduloDATOS': moduloDATOS,
      'estado': estado,
      'fechaUltCbioEstado': fechaUltCbioEstado,
      'intranetUsername': intranetUsername,
      'intranetPassword': intranetPassword,
      'moduloVOZ': moduloVOZ,
      'tag': tag,
      'numeroDeCuenta': numeroDeCuenta,
      'codPais': codPais,
      'descripcionCodPais': descripcionCodPais,
      'codPcia': codPcia,
      'descripcionCodPcia': descripcionCodPcia,
      'torre': torre,
      'sector': sector,
      'moduloTELEVISION': moduloTELEVISION,
      'lastModifiedDate': lastModifiedDate,
      'lastModifiedTime': lastModifiedTime,
      'lastModifiedUsername': lastModifiedUsername,
      'lastModifiedTerminal': lastModifiedTerminal,
      'roelaAliasCuentaBancaria': roelaAliasCuentaBancaria,
      'roelaCBUCuentaBancaria': roelaCBUCuentaBancaria,
      'codigoBarrasPMCnPF': codigoBarrasPMCnPF,
      'codigoPMCnPF': codigoPMCnPF,
      'hash': hash,
      'lockHash': lockHash,
      'lockUsername': lockUsername,
      'lockTerminal': lockTerminal,
      'lockDateTime': lockDateTime,
      'lockLastAccessDateTime': lockLastAccessDateTime,
      'createdUsername': createdUsername,
      'createdTerminal': createdTerminal,
      'createdDateTime': createdDateTime,
      'fromType': fromType,
      'environment': environment,
      'eEmpresa': eEmpresa,
      'ePais': ePais,
      'eProvincia': eProvincia,
      'eCiudad': eCiudad,
      'eBarrioCiudad': eBarrioCiudad,
      'eCondicionDeVenta': eCondicionDeVenta,
      'eAFIPWSFETipoDeDocuemnto': eAFIPWSFETipoDeDocuemnto
    };
  }

  /// Change País Record
  ///
  void changePaisRecord(TablePaisModel pData) {
    codPais = pData.codPais;
    descripcionCodPcia = pData.descripcion;
    ePais = pData;
  }

  /// Change Provincia Record
  ///
  void changeProvinciaRecord(TableProvinciaModel pData) {
    codPcia = pData.codPcia;
    descripcionCodPcia = pData.descripcion;
    eProvincia = pData;
  }

  /// Change Ciudad Record
  ///
  void changeCiudadRecord(TableCiudadModel pData) {
    codCdad = pData.codCdad;
    descripcionCodCdad = pData.descripcion;
    eCiudad = pData;
  }

  /// Change Ciudad Record
  ///
  void changeBarrioRecord(TableDetBarrioCiudadModel pData) {
    codigoBarrio = pData.codigoBarrio;
    descripcionCodigoBarrio = pData.descripcion;
    eBarrioCiudad = pData;
  }

  /// Set CodCatIVA record
  ///
  void setCategoriaDeIVA(TableCategoriaDeIVAModel pData) {
    codCatIVA = pData.codCatIVA;
    descripcionCodCatIVA = pData.descripcion;
    eCategoriaDeIVA = pData;
    setAFIPWSFETipoDeDocumento(TableAFIPWSFETiposDeDocumentos.fromKey(
      pID: pData.codigoIDTipoDocFE,
      pDescripcion: pData.descripcionCodigoIDTipoDocFE,
      pEmpresa: pData.eEmpresa,
    ));
  }

  /// Set CodigoTpoDocFE record
  ///
  void setAFIPWSFETipoDeDocumento(TableAFIPWSFETiposDeDocumentos pData) {
    codigoTpoDocFE = pData.id;
    descripcionCodigoTpoDocFE = pData.descripcion;
    eAFIPWSFETipoDeDocuemnto = pData;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TableClienteV2Model) return false;

    Map<String, dynamic> thisMap = toMap();
    Map<String, dynamic> otherMap = other.toMap();

    for (String key in thisMap.keys) {
      if (thisMap[key].runtimeType != otherMap[key].runtimeType) {
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
      '${codClie.toString().padLeft(6, '0')} - $razonSocial';

  @override
  String get dropDownKey => codClie.toString();

  @override
  String get dropDownSubTitle =>
      "${codClie.toString().padLeft(6, '0')} - ($estado)";

  @override
  String get dropDownTitle => razonSocial;

  @override
  String get dropDownValue => razonSocial;

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({
    required String searchText,
  }) async {
    throw UnimplementedError(
        'filterSearchFromDropDown is not implemented for TableClienteV2Model');
  }

  Future<List<CommonParamKeyValue<TableClienteV2Model>>>
      filterSearchFromDropDownCodClie({
    required String searchText,
    required WidgetRef wRef,
    CommonParamKeyValueCapableModel? pParams,
  }) async {
    String funcionName = "filterSearchFromDropDownCodClie";
    TableClienteV2Model fEnteSelected = TableClienteV2Model.fromDefault(
      pEmpresa: eEmpresa,
    );
    if (searchText.isEmpty || searchText.trim().length < 4) {
      return [];
    }
    List<CommonParamKeyValue<TableClienteV2Model>> pClientes = [];

    /// Obtengo los datos del país del back-end
    ///
    GenericDataModel<TableClienteV2Model> pDataEnteBackend;
    String dThreadHashID = generateRandomUniqueHash();
    await wRef.read(notifierServiceProvider).mapThreadsToDataModels.set(
          key: dThreadHashID,
          value: GenericDataModel<TableClienteV2Model>(
            wRef: wRef,
            debug: wRef.read(notifierServiceProvider).debug,
          ),
        );
    pDataEnteBackend = wRef
        .read(notifierServiceProvider)
        .mapThreadsToDataModels
        .get(dThreadHashID);
    pDataEnteBackend.threadID = dThreadHashID;
    pDataEnteBackend.pGlobalRequest = ConstRequests.viewRequest;
    pDataEnteBackend.pLocalRequest = ConstRequests.viewRequest;
    pDataEnteBackend.cEmpresa = eEmpresa;
    pDataEnteBackend.cEncRecord = TableClienteV2Model.fromDefault(
      pEmpresa: eEmpresa,
    );
    pDataEnteBackend.fromJsonFunction = TableClienteV2Model.fromJson;

    pDataEnteBackend.threadParams = {
      'SelectBy': 'KeyEmpresa',
      'CodEmp': codEmp,
      'IsEmpresaAggregated': true,
    };

    Map<String, dynamic> pLocalParams = {
      'SelectBy': 'KeyEmpresa',
      'CodEmp': codEmp,
      'IsEmpresaAggregated': true,
      'ActionRequest': "ViewRecord",
      'DBVersion': 2,
      'Search': searchText,
      //'ClaseCpbte': claseCpbte,
    };
    // TableEmpresaModel eEmpresa = pEnteSelected.eEmpresa;
    var pGenericParams = GenericModel.fromDefault();
    pGenericParams.pTable = iDefaultTable();
    pGenericParams.pLocalParamsRequest = pLocalParams;

    ErrorHandler rFilteredRecords =
        await pDataEnteBackend.filterSearchFromDropDown(
      pParams: pGenericParams,
      pEnte: fEnteSelected,
    );
    if (rFilteredRecords.errorCode != 0) {
      /// Si hay error, entonces lo muestro
      /// y retorno el error
      rFilteredRecords.errorDsc = '''Error al obtener los datos de los clientes.
          Código de empresa: ${eEmpresa.codEmp}
          ${rFilteredRecords.errorDsc}
          ''';
      rFilteredRecords.stacktrace ??= StackTrace.current;
      var eEnteFiltered = TableClienteV2Model.fromError(
        pEmpresa: eEmpresa,
        pFilter: searchText,
      );
      var rSetSelectedEnte = await setSelectedCliente(
        pFrom: "RazonSocial",
        pCascade: true,
        pEnteSelected: eEnteFiltered,
        wRef: wRef,
      );
      if (rSetSelectedEnte.errorCode != 0) {
        /// Si hay error al establecer el servicio "por defecto", entonces lo muestro
        if (navigatorKey.currentContext != null) {
          await Navigator.of(navigatorKey.currentContext!).push(
            ModelGeneralPoPUpErrorMessageDialog(
              error: rSetSelectedEnte,
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
      return pClientes;
    }

    /// Si no hay error, entonces verifico que la data sea del tipo esperado
    if (rFilteredRecords.data is! List<TableClienteV2Model>) {
      /// Si la data no es del tipo esperado, entonces retorno el error
      var rError = ErrorHandler(
        errorCode: 777,
        errorDsc: '''Error al obtener los datos de los clientes.
                  Esperábamos recibir List<TableClienteV2Model>> y recibimos ${rFilteredRecords.data.runtimeType}
                  ''',
        propertyName: 'Data',
        propertyValue: rFilteredRecords.data,
        functionName: funcionName,
        className: className,
        stacktrace: StackTrace.current,
      );
      var eEnteFiltered = TableClienteV2Model.fromError(
        pEmpresa: eEmpresa,
        pFilter: searchText,
      );
      var rSetSelectedEnte = await setSelectedCliente(
        pFrom: "RazonSocial",
        pEnteSelected: eEnteFiltered,
        pCascade: true,
        wRef: wRef,
      );
      if (rSetSelectedEnte.errorCode != 0) {
        /// Si hay error al establecer el servicio "por defecto", entonces lo muestro
        if (navigatorKey.currentContext != null) {
          await Navigator.of(navigatorKey.currentContext!).push(
            ModelGeneralPoPUpErrorMessageDialog(
              error: rSetSelectedEnte,
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
      return pClientes;
    }
    //List<TableClienteV2Model> data = [];

    /// Si no hay error, entonces verifico que la data sea del tipo esperado
    /// y que contenga al menos un registro
    var tData = rFilteredRecords.data as List<TableClienteV2Model>;

    List<CommonParamKeyValue<TableClienteV2Model>> rResults = [];
    for (var element in tData) {
      rResults.add(
        CommonParamKeyValue.fromType(
          tObject: element,
        ),
      );
    }
    pClientes = rResults;
    return pClientes;
  }

  /// Set the selected cliente.
  /// Implica: =>
  /// - Setear el cliente seleccionado
  /// - Setear el número de servicio
  ///
  Future<ErrorHandler> setSelectedCliente({
    required String pFrom,
    bool pCascade = false,
    required TableClienteV2Model pEnteSelected,
    required WidgetRef wRef,
  }) async {
    String functionName = "$runtimeType";

    /// Solo proceso si el Environment != "default"
    ///
    if (pEnteSelected.environment == "default") {
      return ErrorHandler(
        errorCode: 99,
        errorDsc: '''Error al establecer el cliente.
                El entorno de desarrollo ${pEnteSelected.environment} es incorrecto o inválido.\r\nNo se encuentra programado.
                Código de empresa: ${pEnteSelected.codEmp}
                Tipo de cliente: $tipoCliente
                Código de cliente: ${pEnteSelected.codClie}                
                ''',
        propertyName: 'CodClie',
        propertyValue: pEnteSelected.codClie.toString(),
        className: className,
        functionName: functionName,
      );
    }
    switch (pFrom) {
      case "RazonSocial":

        /// Solo proceso si el Environment != "default"
        ///
        if (pEnteSelected.environment == "default") {
          return ErrorHandler(
            errorCode: 99,
            errorDsc: '''Error al establecer el cliente.
                El entorno de desarrollo ${pEnteSelected.environment} es incorrecto o inválido.\r\nNo se encuentra programado.
                Código de empresa: ${pEnteSelected.codEmp}
                Tipo de cliente: $tipoCliente
                Código de cliente: ${pEnteSelected.codClie}                
                ''',
            propertyName: 'CodClie',
            propertyValue: pEnteSelected.codClie.toString(),
            className: className,
            functionName: functionName,
          );
        }

        /// Establezo los valores de los campos para el cliente seleccionado
        ///
        // var selectedCliente =
        //     CommonParamKeyValue.fromType(tObject: pEnteSelected);
        // pCliente = selectedCliente;

        tipoCliente = pEnteSelected.tipoCliente;
        codClie = pEnteSelected.codClie;
        razonSocial = pEnteSelected.razonSocial;

        //codCondVta = pEnteSelected.codCondVta;
        //descripcionCodCondVta = pEnteSelected.descripcionCodCondVta;

        cuit = pEnteSelected.cuit;
        nroDoc = pEnteSelected.nroDoc;
        numeroDeCuenta = pEnteSelected.numeroDeCuenta;
        cicloFacturacion = pEnteSelected.cicloFacturacion;
        ultPeriodoFacturacion = pEnteSelected.ultPeriodoFacturacion;
        fechaUltPeriodoFacturacion = pEnteSelected.fechaUltPeriodoFacturacion;
        codigoTpoDocFE = pEnteSelected.codigoTpoDocFE;
        moduloDATOS = pEnteSelected.moduloDATOS;
        moduloTELEVISION = pEnteSelected.moduloTELEVISION;
        estado = pEnteSelected.estado;
        domicilio = pEnteSelected.domicilio;
        nroPuerta = pEnteSelected.nroPuerta;
        piso = pEnteSelected.piso;
        depto = pEnteSelected.depto;
        torre = pEnteSelected.torre;
        sector = pEnteSelected.sector;
        telefono = pEnteSelected.telefono;
        email = pEnteSelected.email;
        fechaNacIniAct = pEnteSelected.fechaNacIniAct;
        codCatIVA = pEnteSelected.codCatIVA;
        descripcionCodCatIVA = pEnteSelected.descripcionCodCatIVA;
        saldoActual = pEnteSelected.saldoActual;
        ultFechaActSaldo = pEnteSelected.ultFechaActSaldo;
        ultFechaVenta = pEnteSelected.ultFechaVenta;
        ultFechaCobro = pEnteSelected.ultFechaCobro;
        moduloVOZ = pEnteSelected.moduloVOZ;
        intranetUsername = pEnteSelected.intranetUsername;
        intranetPassword = pEnteSelected.intranetPassword;

        /// Estos campos son todos de facturación.
        /// Se actualizan siempre con la información actualizada de la ficha del cliente
        /// Luego, queda como historial.-
        // domicilioFacturacion = pEnteSelected.domicilio;
        // nroPuertaFacturacion = pEnteSelected.nroPuerta;
        // pisoFacturacion = pEnteSelected.piso;
        // deptoFacturacion = pEnteSelected.depto;
        // sectorFacturacion = pEnteSelected.sector;
        // torreFacturacion = pEnteSelected.torre;

        codigoBarrasPMCnPF = pEnteSelected.codigoBarrasPMCnPF;
        codigoPMCnPF = pEnteSelected.codigoPMCnPF;
        roelaCBUCuentaBancaria = pEnteSelected.roelaCBUCuentaBancaria;
        roelaAliasCuentaBancaria = pEnteSelected.roelaAliasCuentaBancaria;
        // codPaisFacturacion = pEnteSelected.codPais;
        // descripcionCodPaisFacturacion = pEnteSelected.descripcionCodPais;
        // codPciaFacturacion = pEnteSelected.codPcia;
        // descripcionCodPciaFacturacion = pEnteSelected.descripcionCodPcia;
        // codCdadFacturacion = pEnteSelected.codCdad;
        // descripcionCodCdadFacturacion = pEnteSelected.descripcionCodCdad;
        // codPostalCodCdadFacturacion = pEnteSelected.codPostal;
        // codigoBarrioFacturacion = pEnteSelected.codigoBarrio;
        // descripcionCodigoBarrioFacturacion =
        //     pEnteSelected.descripcionCodigoBarrio;

        // eCliente = pEnteSelected;

        /// Solo proceso si el Environment != "default"
        ///
        //if (pEnteSelected.environment != "default") {
        //await setSelectedNroServicio
        // eDetServicioDATOSCliente =
        //     TableDetServicioDATOSClienteV2Model.fromNewNRoServicio(
        //   pEmpresa: eEmpresa,
        //   pCliente: eCliente,
        // );
        // pDetServicioClienteDATOS = CommonParamKeyValue.fromType(
        //   tObject: eDetServicioDATOSCliente,
        // );
        // pDetServiciosDATOSClientes = [pDetServicioClienteDATOS];
        // var rSetNroServicioDATOS = await setSelectedNroServicioDATOS(
        //   pFrom: pFrom,
        //   pCascade: pCascade,
        //   pEnteSelected: eDetServicioDATOSCliente,
        //   wRef: wRef,
        // );

        /// Si hubo error, lo devuelvo
        /// y no sigo procesando
        // if (rSetNroServicioDATOS.errorCode != 0) {
        //   return rSetNroServicioDATOS;
        // }

        /// Si no hubo error, entonces sigo procesando
        /// y devuelvo el error
        return ErrorHandler(
          errorCode: 0,
          errorDsc: "Se estableció el valor del cliente",
          propertyName: 'CodClie',
          propertyValue: codClie.toString(),
          functionName: functionName,
          className: className,
        );
      default:
        return ErrorHandler(
          errorCode: 33,
          errorDsc: '''Error al obtener el cliente.
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

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => "";

  @override
  CommonParamKeyValueCapable fromDefault() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> getKeyEntity() {
    return {
      'CodEmp': codEmp,
      'TipoCliente': tipoCliente,
      'CodClie': codClie,
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

  @override
  String iDefaultTable() {
    return _defaultTable;
  }

  static String sDefaultTable() {
    return _defaultTable;
  }

  CommonFieldNames<TableClienteV2Model> _defaultView() {
    CommonFieldNames<TableClienteV2Model> fieldNames =
        CommonFieldNames<TableClienteV2Model>();
    fieldNames.add(
      kValue: "TAG",
      vValue: "TAG",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodClie",
      vValue: "Código",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "RazonSocial",
      vValue: "Razón Social",
      vFunction: null,
      vTextAlign: TextAlign.center,
      vContentAlignment: Alignment.centerLeft,
      vContentTextAlign: TextAlign.left,
      vWidth: 250,
    );
    fieldNames.add(
      kValue: "Estado",
      vValue: "Estado",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "SaldoActual",
      vValue: "Saldo Actual",
      vFunction: null,
      vTextAlign: TextAlign.center,
      vContentAlignment: Alignment.centerRight,
      vContentTextAlign: TextAlign.right,
    );
    fieldNames.add(
      kValue: "RoelaAliasCuentaBancaria",
      vValue: "Alias Cuenta ROELA",
      vFunction: null,
      vCopyToClipboard: (context, vField) async {
        Map<String, dynamic> myData = vField.toJson();
        String myTemplate = processTemplate(
          pTemplate: copyToClipBoardBancoROELAAlias,
          pData: myData,
        );
        await Clipboard.setData(
          ClipboardData(text: myTemplate),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Alias Copiado al Portapapeles'),
            ),
          );
        }
      },
    );
    fieldNames.add(
      kValue: "RoelaCBUCuentaBancaria",
      vValue: "CBU Cuenta ROELA",
      vFunction: null,
      // vCopyToClipboard: (context, vField) async {
      //   Map<String, dynamic> myData = vField.toJson();
      //   await Clipboard.setData(
      //     ClipboardData(text: myData['RoelaCBUCuentaBancaria']),
      //   );
      //   if (context.mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('CBU Copiado al Portapapeles'),
      //       ),
      //     );
      //   }
      // },
    );
    fieldNames.add(
      kValue: "CodigoBarrasPMCnPF",
      vValue: "Código Barras PMC/PF",
      vFunction: null,
      vCopyToClipboard: (context, vField) async {
        Map<String, dynamic> myData = vField.toJson();
        String myTemplate = processTemplate(
          pTemplate: copyToClipBoardPagoFacil,
          pData: myData,
        );
        await Clipboard.setData(
          ClipboardData(text: myTemplate),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Código Barras Copiado al Portapapeles'),
            ),
          );
        }
      },
    );
    fieldNames.add(
      kValue: "CodigoPMCnPF",
      vValue: "Código PMC/PF",
      vFunction: null,
      vCopyToClipboard: (context, vField) async {
        Map<String, dynamic> myData = vField.toJson();
        String myTemplate = processTemplate(
          pTemplate: copyToClipBoardHomebanking,
          pData: myData,
        );
        await Clipboard.setData(
          ClipboardData(text: myTemplate),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Código PMC/PF Copiado al Portapapeles'),
            ),
          );
        }
      },
    );
    fieldNames.add(
      kValue: "NumeroDeCuenta",
      vValue: "Número de Cuenta",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodCdad",
      vValue: "Código",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodCdad",
      vValue: "Descripción",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DatosDomicilio",
      vValue: "Domicilio",
      vFunction: null,
      vTextAlign: TextAlign.center,
      vContentAlignment: Alignment.centerLeft,
      vContentTextAlign: TextAlign.left,
      vWidth: 150,
    );
    fieldNames.add(
      kValue: "CodCatIVA",
      vValue: "Código",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodCatIVA",
      vValue: "Descripción",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "NroIDFiscal",
      vValue: "ID Fiscal",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "SaldoActual",
      vValue: "Saldo Actual",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "UltFechaActSaldo",
      vValue: "Ult. Fecha Saldo",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "UltFechaCobro",
      vValue: "Ult. Fecha Cobro",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "UltFechaVenta",
      vValue: "Ult. Fecha Venta",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CicloFacturacion",
      vValue: "Ciclo Facturación",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "FacturacionElectronica",
      vValue: "Fact. Electrónica",
      vFunction: null,
    );
    // fieldNames.add(
    //   kValue: "DebitoAutomaticoHabilitado",
    //   vValue: "Débito Automático",
    //   vFunction: null,
    // );
    fieldNames.add(
      kValue: "ModuloDATOS",
      vValue: "Módulo DATOS",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ModuloVOZ",
      vValue: "Módulo VOZ",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "ModuloTELEVISION",
      vValue: "Módulo TV",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "IntranetUsername",
      vValue: "Intranet Username",
      vFunction: null,
      vTextAlign: TextAlign.center,
      vContentAlignment: Alignment.centerLeft,
      vContentTextAlign: TextAlign.left,
      vWidth: null,
    );
    fieldNames.add(
      kValue: "IntranetPassword",
      vValue: "Intranet Password",
      vFunction: null,
      vTextAlign: TextAlign.center,
      vContentAlignment: Alignment.centerLeft,
      vContentTextAlign: TextAlign.left,
      vWidth: null,
    );
    fieldNames.add(
      kValue: "CodPcia",
      vValue: "Código",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodPcia",
      vValue: "Descripción",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "CodPais",
      vValue: "Código",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "DescripcionCodPais",
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
    fieldNames.add(
      kValue: "Environment",
      vValue: "Environment",
      vFunction: null,
    );
    return fieldNames;
  }
}
