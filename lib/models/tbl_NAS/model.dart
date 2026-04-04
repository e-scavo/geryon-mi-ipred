import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonClaseCpbteVT/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_data_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/CommonGenericProcedureParams/mode.dart';
import 'package:geryon_web_app_ws_v2/models/CommonUtils/common_utils.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/GenericDataModel/model.dart';
import 'package:geryon_web_app_ws_v2/shared/overlays/error_dialog_route.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/onu_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/params_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/pon_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/snmp_versions.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/tipo_nas.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/type_vendors.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

class TableNASModel
    implements CommonModel<TableNASModel>, CommonParamKeyValueCapable {
  static String className = 'TableNASModel';
  static String logClassName = '.::$className::.';
  static final String _defaultTable = "tbl_NAS";

  @override
  String iDefaultTable() {
    return _defaultTable;
  }

  static String sDefaultTable() {
    return _defaultTable;
  }

  int id;
  String nasName;
  String shortName;
  VendorTypeModel type;
  int ports;
  String secret;
  String server;
  String community;
  String description;
  String snmpUsername;
  String snmpPassword;
  SNMPVersionsModel snmpVersion;
  String snmpCommunity;
  int snmpPort;
  String sshUsername;
  String sshPassword;
  int sshPort;
  String latitud;
  String longitud;
  TipoNASModel tipoNAS;
  String estado;
  int cantPONs;
  int codEmp;
  String razonSocialCodEmp;
  String environment;
  TableEmpresaModel eEmpresa;

  late List<CommonParamKeyValue<TableNASModel>> pNASes;
  late CommonParamKeyValue<TableNASModel> pNAS;
  late List<CommonParamKeyValue<PONModel>> pPONes;
  late List<CommonParamKeyValue<ONUModel>> pONUes;

  /// Constructor privado para la inicialización
  /// Utilizado por las fábricas
  /// y para crear instancias desde JSON.
  /// Este constructor es privado para evitar la creación directa de instancias
  /// y forzar el uso de las fábricas.
  /// VALORES POR DEFECTO:
  /// - id: 0 => El registro no está establecido "SELECCIONE UN..."
  /// - id: -1 => El registro está establecido por defecto
  /// - id: -2 => El registro ha fallado al buscarse (en error)
  /// - id: > 0 => El registro está establecido con un ID específico
  TableNASModel._internal({
    required this.id,
    required this.nasName,
    required this.shortName,
    required this.type,
    required this.ports,
    required this.secret,
    required this.server,
    required this.community,
    required this.description,
    required this.snmpUsername,
    required this.snmpPassword,
    required this.snmpVersion,
    required this.snmpCommunity,
    required this.snmpPort,
    required this.sshUsername,
    required this.sshPassword,
    required this.sshPort,
    required this.latitud,
    required this.longitud,
    required this.tipoNAS,
    required this.estado,
    required this.cantPONs,
    required this.codEmp,
    required this.razonSocialCodEmp,
    required this.environment,
    required this.eEmpresa,
  });

  factory TableNASModel.fromDefault({
    required TableEmpresaModel pEmpresa,
  }) {
    var id = -1;
    var nasName = '';
    var shortName = '';
    var type = VendorTypeModel.unknown;
    var ports = 0;
    var secret = '';
    var server = '';
    var community = '';
    var description = '';
    var snmpUsername = '';
    var snmpPassword = '';
    var snmpVersion = SNMPVersionsModel.unknown;
    var snmpCommunity = '';
    var snmpPort = 0;
    var sshUsername = '';
    var sshPassword = '';
    var sshPort = 0;
    var latitud = '';
    var longitud = '';
    var tipoNAS = TipoNASModel.unknown;
    var estado = '';
    var cantPONs = 0;
    var codEmp = pEmpresa.codEmp;
    var razonSocialCodEmp = pEmpresa.razonSocial;
    var environment = 'default';
    var eEmpresa = pEmpresa;
    return TableNASModel._internal(
      id: id,
      nasName: nasName,
      shortName: shortName,
      type: type,
      ports: ports,
      secret: secret,
      server: server,
      community: community,
      description: description,
      snmpUsername: snmpUsername,
      snmpPassword: snmpPassword,
      snmpVersion: snmpVersion,
      snmpCommunity: snmpCommunity,
      snmpPort: snmpPort,
      sshUsername: sshUsername,
      sshPassword: sshPassword,
      sshPort: sshPort,
      latitud: latitud,
      longitud: longitud,
      tipoNAS: tipoNAS,
      estado: estado,
      cantPONs: cantPONs,
      codEmp: codEmp,
      razonSocialCodEmp: razonSocialCodEmp,
      environment: environment,
      eEmpresa: eEmpresa,
    );
  }

  factory TableNASModel.fromKey({
    required int id,
    required String nasName,
    required String shortName,
    required TableEmpresaModel pEmpresa,
  }) {
    switch (id) {
      case 0:
        return TableNASModel.fromSelectRecord(pEmpresa: pEmpresa);
      case -1:
        return TableNASModel.fromDefault(pEmpresa: pEmpresa);
      case -2:
        return TableNASModel.fromError(
          pEmpresa: pEmpresa,
          pFilter: nasName,
        );
      default:
        break;
    }
    var rObject = TableNASModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    rObject.codEmp = pEmpresa.codEmp;
    rObject.razonSocialCodEmp = pEmpresa.razonSocial;
    rObject.id = id;
    rObject.nasName = nasName;
    rObject.environment = pEmpresa.environment;
    return rObject;
  }

  factory TableNASModel.fromSelectRecord({
    required TableEmpresaModel pEmpresa,
  }) {
    var rObject = TableNASModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    rObject.id = 0; // Default ID for new records
    rObject.nasName = 'SELECIONE UNA OLT';
    rObject.shortName = '0.0.0.0';

    return rObject;
  }

  /// Método de fábrica para crear una instancia desde JSON
  ///
  static TableNASModel fromJson({
    required Map<String, dynamic> map,
    int errorCode = 0,
  }) {
    return TableNASModel.fromJsonGral(
      map: map,
      errorCode: errorCode,
      pEmpresa: TableEmpresaModel.fromDefault(),
    );
  }

  factory TableNASModel.fromError({
    required TableEmpresaModel pEmpresa,
    required String pFilter,
  }) {
    var rObject = TableNASModel.fromDefault(
      pEmpresa: pEmpresa,
    );
    rObject.id = -2;
    rObject.nasName = "Error recibido";
    rObject.codEmp = -2;
    rObject.razonSocialCodEmp = "";
    return rObject;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'NasName': nasName,
      'ShortName': shortName,
      'Type': type.key,
      'Ports': ports,
      'Secret': secret,
      'Server': server,
      'Community': community,
      'Descripcion': description,
      'SNMPUsername': snmpUsername,
      'SNMPPassword': snmpPassword,
      'SNMPVersion': snmpVersion.key,
      'SNMPCommunity': snmpCommunity,
      'SNMPPort': snmpPort,
      'SSHUsername': sshUsername,
      'SSHPassword': sshPassword,
      'SSHPort': sshPort,
      'Latitud': latitud,
      'Longitud': longitud,
      'TipoNAS': tipoNAS.key,
      'Estado': estado,
      'CantPONs': cantPONs,
      'CodEmp': codEmp,
      'RazonSocialCodEmp': razonSocialCodEmp,
      'Environment': environment,
      'EEmpresa': eEmpresa,
    };
  }

  @override
  String toString() {
    return toJson.toString();
  }

  @override
  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory TableNASModel.fromJsonGral({
    required Map<String, dynamic> map,
    int errorCode = 0,
    required TableEmpresaModel pEmpresa,
    int pVersion = 2,
  }) {
    String functionName = "fromJson";
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';

    try {
      int id = -1;
      if (int.tryParse(map['ID'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'ID',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      id = int.parse(map['ID'].toString());
      String nasName = map['NasName'].toString();
      String shortName = map['ShortName'].toString();
      var type = VendorTypeModel.fromKey(map['Type'].toString());
      int ports = 0;
      if (int.tryParse(map['Ports'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'Ports',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      ports = int.parse(map['Ports'].toString());
      String secret = map['Secret'].toString();
      String server = map['Server'].toString();
      String community = map['Community'].toString();
      String descripcion = map['Descripcion'].toString();
      String snmpUsername = map['SNMPUsername'].toString();
      String snmpPassword = map['SNMPPassword'].toString();
      var snmpVersion =
          SNMPVersionsModel.fromKey(map['SNMPVersion'].toString());
      String snmpCommunity = map['SNMPCommunity'].toString();
      int snmpPort = 0;
      if (int.tryParse(map['SNMPPort'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'SNMPPort',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      snmpPort = int.parse(map['SNMPPort'].toString());
      String sshUsername = map['SSHUsername'].toString();
      String sshPassword = map['SSHPassword'].toString();
      int sshPort = 0;
      if (int.tryParse(map['SSHPort'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'SSHPort',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      sshPort = int.parse(map['SSHPort'].toString());
      String latitud = map['Latitud'].toString();
      String longitud = map['Longitud'].toString();
      var tipoNAS = TipoNASModel.fromKey(map['TipoNAS'].toString());
      String estado = map['Estado'].toString();
      int cantPONs = 0;
      if (int.tryParse(map['CantPONs'].toString()) == null) {
        throw ErrorHandler(
          errorCode: 300100,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'CantPONs',
          propertyValue: null,
          className: className,
          functionName: functionName,
          stacktrace: StackTrace.current,
        );
      }
      cantPONs = int.parse(map['CantPONs'].toString());

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

      var environment = map["Environment"].toString();

      if (pEmpresa.environment == 'default') {
        pEmpresa.codEmp = codEmp;
        pEmpresa.razonSocial = razonSocialCodEmp;
        pEmpresa.environment = environment;
      }
      var eEmpresa = pEmpresa;
      if (map['Empresa'] != null) {
        eEmpresa = TableEmpresaModel.fromJson(map['Empresa']);
      }
      return TableNASModel._internal(
        id: id,
        nasName: nasName,
        shortName: shortName,
        type: type,
        ports: ports,
        secret: secret,
        server: server,
        community: community,
        description: descripcion,
        snmpUsername: snmpUsername,
        snmpPassword: snmpPassword,
        snmpVersion: snmpVersion,
        snmpCommunity: snmpCommunity,
        snmpPort: snmpPort,
        sshUsername: sshUsername,
        sshPassword: sshPassword,
        sshPort: sshPort,
        latitud: latitud,
        longitud: longitud,
        tipoNAS: tipoNAS,
        estado: estado,
        cantPONs: cantPONs,
        codEmp: codEmp,
        razonSocialCodEmp: razonSocialCodEmp,
        environment: environment,
        eEmpresa: eEmpresa,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! TableNASModel) return false;

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
  Map<String, dynamic> getKeyEntity() {
    return {
      'ID': id,
      'CodEmp': codEmp,
      'Environment': environment,
    };
  }

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownItemAsString =>
      '${id.toString().padLeft(2, '0')} - $shortName[$nasName]';

  @override
  String get dropDownKey => id.toString();

  @override
  String get dropDownSubTitle =>
      '${id.toString().padLeft(2, '0')} - $shortName[$nasName]';

  @override
  String get dropDownTitle => shortName;

  @override
  String get dropDownValue => nasName;

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({required String searchText}) {
    throw UnimplementedError();
  }

  @override
  CommonParamKeyValueCapable fromDefault() {
    throw UnimplementedError();
  }

  /// filterSearchFromDropDownbyID
  /// Busca un registro por ID en la lista de dropDown
  Future<List<CommonParamKeyValue<TableNASModel>>> filterSearchFromDropDownBy({
    required String searchText,
    required WidgetRef wRef,
    required ProcedureParamsModel procedureParams,
    CommonGenericProcedureParamsModel? pParams,
  }) async {
    String funcionName = "$runtimeType";
    developer.log(
      'DEBUG_17888 [$funcionName] filterSearchFromDropDownByID: $searchText',
      name: 'geryon_web_app_ws_v2',
    );
    // Implementación de búsqueda por ID
    TableNASModel fEnteSelected = this;
    GenericDataModel<TableNASModel> dataModel;
    String hashID = generateRandomUniqueHash();
    await wRef.read(notifierServiceProvider).mapThreadsToDataModels.set(
          key: hashID,
          value: GenericDataModel<TableNASModel>(
            wRef: wRef,
            debug: wRef.read(notifierServiceProvider).debug,
          ),
        );
    dataModel =
        wRef.read(notifierServiceProvider).mapThreadsToDataModels.get(hashID);
    dataModel.threadID = hashID;
    dataModel.pGlobalRequest = ConstRequests.viewRequest;
    dataModel.pLocalRequest = ConstRequests.viewRequest;
    dataModel.cEmpresa = eEmpresa;
    dataModel.cEncRecord = this;
    dataModel.fromJsonFunction = TableNASModel.fromJson;
    dataModel.threadParams = {};
    Map<String, dynamic> pLocalParams = {};
    switch (procedureParams.searchBy) {
      case "KeyTipoNAS":
        dataModel.threadParams = {
          'SelectBy': 'KeyTipoNAS',
          'CodEmp': codEmp,
          'TipoNAS': procedureParams.tipoNAS.key,
          'IsEmpresaAggregated': true,
        };
        pLocalParams = {
          'SelectBy': 'KeyTipoNAS',
          'CodEmp': codEmp,
          'TipoNAS': procedureParams.tipoNAS.key,
          'IsEmpresaAggregated': true,
          'ActionRequest': "ViewRecord",
          'DBVersion': 2,
          'Search': searchText,
          'ClaseCpbte': "",
        };
        break;
      case 'KeyID':
        dataModel.threadParams = {
          'SelectBy': 'KeyID',
          'CodEmp': codEmp,
          'ID': id,
          'IsEmpresaAggregated': true,
        };
        pLocalParams = {
          'SelectBy': 'KeyID',
          'CodEmp': codEmp,
          'ID': id,
          'IsEmpresaAggregated': true,
          'ActionRequest': "ViewRecord",
          'DBVersion': 2,
          'Search': searchText,
          'ClaseCpbte': "",
        };
        break;
      default:
        break;
    }

    var pGenericParams = GenericModel.fromDefault();
    pGenericParams.pTable = iDefaultTable();
    pGenericParams.pLocalParamsRequest = pLocalParams;
    ErrorHandler rFilteredRecords = await dataModel.filterSearchFromDropDown(
      pParams: pGenericParams,
      pEnte: fEnteSelected,
    );
    if (rFilteredRecords.errorCode != 0) {
      /// Si hay error, entonces lo muestro
      /// y retorno el error
      rFilteredRecords.errorDsc = '''Error al obtener los datos del NAS.
          Código de empresa: $codEmp
          ID: $id
          ${rFilteredRecords.errorDsc}
          ''';
      rFilteredRecords.stacktrace ??= StackTrace.current;
      var eEnteFiltered = TableNASModel.fromError(
        pEmpresa: eEmpresa,
        pFilter: searchText,
      );
      var cEnteFiltered = CommonParamKeyValue.fromType(
        tObject: eEnteFiltered,
      );
      pNASes = [cEnteFiltered];
      pNAS = cEnteFiltered;

      /// Si hay error, entonces lo muestro
      if (navigatorKey.currentContext != null) {
        await Navigator.of(navigatorKey.currentContext!).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: rFilteredRecords,
          ),
        );
      }
      return pNASes;
    }

    /// Si no hay error, entonces verifico que la data sea del tipo esperado
    if (rFilteredRecords.data is! List<TableNASModel>) {
      /// Si la data no es del tipo esperado, entonces retorno el error
      var rError = ErrorHandler(
        errorCode: 777,
        errorDsc: '''Error al obtener los datos del país seleccionado.
                  Esperábamos recibir List<TableNASModel>> y recibimos ${rFilteredRecords.data.runtimeType}
                  ''',
        propertyName: 'Data',
        propertyValue: rFilteredRecords.data,
        functionName: funcionName,
        className: className,
        stacktrace: StackTrace.current,
      );
      var eEnteFiltered = TableNASModel.fromError(
        pEmpresa: eEmpresa,
        pFilter: searchText,
      );
      var cEnteFiltered = CommonParamKeyValue.fromType(
        tObject: eEnteFiltered,
      );
      pNASes = [cEnteFiltered];
      pNAS = cEnteFiltered;

      /// Si hay error, entonces lo muestro
      if (navigatorKey.currentContext != null) {
        await Navigator.of(navigatorKey.currentContext!).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: rError,
          ),
        );
      }
      return pNASes;
    }
    CommonClasesCpbteVT lClaseCpbteVT =
        pParams?.claseCpbte ?? CommonClasesCpbteVT.unknown;
    var tData = rFilteredRecords.data as List<TableNASModel>;

    List<CommonParamKeyValue<TableNASModel>> rResults = [];
    // if (pParams != null) {
    //   switch (pParams.claseCpbte) {
    //     case CommonClasesCpbteVT.ticketsRemedyVT:
    //       lClaseCpbteVT = CommonClasesCpbteVT.ticketsRemedyVT;
    //       break;
    //     case null:
    //       lClaseCpbteVT = CommonClasesCpbteVT.unknown;
    //       break;
    //     default:
    //       lClaseCpbteVT = pParams.claseCpbte!;

    //       /// ELEMENTO: NUEVO SERVICIO
    //       var eNewService =
    //           TableDetServicioDATOSClienteV2Model.fromNewNRoServicio(
    //               pEmpresa: eEmpresa,
    //               pCliente: eCliente,
    //               pClaseCpbteVT: claseCpbteVT);
    //       var kNewService = CommonParamKeyValue.fromType(
    //         tObject: eNewService,
    //       );
    //       rResults.add(kNewService);
    //       break;
    //   }
    // }
    for (var element in tData) {
      rResults.add(
        CommonParamKeyValue.fromType(
          tObject: element,
        ),
      );
    }
    pNASes = rResults;
    return pNASes;
  }

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => '';

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
      kValue: "CodBanco",
      vValue: "Código",
      vFunction: null,
    );
    fieldNames.add(
      kValue: "Descripcion",
      vValue: "Nombre",
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

  /// filterSearchFromDropDownbyID
  /// Busca un registro por ID en la lista de dropDown
  Future<List<CommonParamKeyValue<PONModel>>> filterSearchFromDropDownPONesBy({
    required String searchText,
    required WidgetRef wRef,
    required ProcedureParamsModel procedureParams,
    CommonGenericProcedureParamsModel? pParams,
  }) async {
    String funcionName = "$runtimeType";
    developer.log(
      'DEBUG_17888 [$funcionName] filterSearchFromDropDownPONesBy: $searchText - CodEmp:$codEmp - ID:$id',
      name: 'geryon_web_app_ws_v2',
    );
    // Implementación de búsqueda por ID
    TableNASModel fEnteSelected = this;
    GenericDataModel<TableNASModel> dataModel;
    String hashID = generateRandomUniqueHash();
    await wRef.read(notifierServiceProvider).mapThreadsToDataModels.set(
          key: hashID,
          value: GenericDataModel<TableNASModel>(
            wRef: wRef,
            debug: wRef.read(notifierServiceProvider).debug,
          ),
        );
    dataModel =
        wRef.read(notifierServiceProvider).mapThreadsToDataModels.get(hashID);
    dataModel.threadID = hashID;
    dataModel.pGlobalRequest = ConstRequests.customRequest;
    dataModel.pLocalRequest = ConstRequests.customRequest;
    dataModel.cEmpresa = eEmpresa;
    dataModel.cEncRecord = this;
    dataModel.fromJsonFunction = TableNASModel.fromJson;
    dataModel.threadParams = {};
    Map<String, dynamic> pLocalParams = {};
    switch (procedureParams.searchBy) {
      case "KeyPONsByNAS":
        dataModel.threadParams = {
          'SelectBy': 'KeyPONsByNAS',
          'CodEmp': codEmp,
          'ID': id,
          'IsEmpresaAggregated': true,
        };
        pLocalParams = {
          'SelectBy': 'KeyPONsByNAS',
          'CodEmp': codEmp,
          'ID': id,
          'IsEmpresaAggregated': true,
          'ActionRequest': "ViewRecord",
          'DBVersion': 2,
          'Search': searchText,
          'ClaseCpbte': "",
        };
        break;
      default:
        break;
    }

    var pGenericParams = GenericModel.fromDefault();
    pGenericParams.pGlobalRequest = ConstRequests.customRequest;
    pGenericParams.pLocalRequest = ConstRequests.customRequest;
    pGenericParams.pActionRequest = ConstRequests.customRequest;
    pGenericParams.pTable = iDefaultTable();
    pGenericParams.pLocalParamsRequest = pLocalParams;
    ErrorHandler rFilteredRecords = await dataModel.filterSearchFromDropDown(
      pParams: pGenericParams,
      pEnte: fEnteSelected,
    );
    developer.log('DEBUG_8191 - $rFilteredRecords');
    if (rFilteredRecords.errorCode != 0) {
      /// Si hay error, entonces lo muestro
      /// y retorno el error
      rFilteredRecords.errorDsc = '''Error al obtener los datos del NAS.
          Código de empresa: $codEmp
          ID: $id
          ${rFilteredRecords.errorDsc}
          ''';
      rFilteredRecords.stacktrace ??= StackTrace.current;
      var eEnteFiltered = PONModel.fromError(
        pNASId: this,
        pFilter: searchText,
      );
      var cEnteFiltered = CommonParamKeyValue.fromType(
        tObject: eEnteFiltered,
      );
      pPONes = [cEnteFiltered];

      /// Si hay error, entonces lo muestro
      if (navigatorKey.currentContext != null) {
        await Navigator.of(navigatorKey.currentContext!).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: rFilteredRecords,
          ),
        );
      }
      return pPONes;
    }
    var rawData =
        rFilteredRecords.rawData as CommonDataModelWholeMessage<TableNASModel>;
    var rawDataData =
        rawData.data as CommonDataModelWholeDataMessage<TableNASModel>;
    var rawDataDataData = rawDataData.data;
    developer.log(
      'DEBUG_8191 - rawData: ${rawData.runtimeType} - rawDataData: ${rawDataData.runtimeType} - rawDataDataData: ${rawDataDataData.runtimeType}',
      name: 'geryon_web_app_ws_v2',
    );
    if (rawDataDataData.nasPONs == null) {
      /// Si no hay PONs asociados, entonces retorno un error
      var rError = ErrorHandler(
        errorCode: 888,
        errorDsc: '''No se encontraron PONs asociados al NAS seleccionado.
                  Código de empresa: $codEmp
                  ID: $id
                  ''',
        propertyName: 'Data',
        propertyValue: rawDataDataData.nasPONs.toString(),
        functionName: funcionName,
        className: className,
        stacktrace: StackTrace.current,
      );
      var eEnteFiltered = PONModel.fromError(
        pNASId: this,
        pFilter: searchText,
      );
      var cEnteFiltered = CommonParamKeyValue.fromType(
        tObject: eEnteFiltered,
      );
      pPONes = [cEnteFiltered];

      /// Si hay error, entonces lo muestro
      if (navigatorKey.currentContext != null) {
        await Navigator.of(navigatorKey.currentContext!).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: rError,
          ),
        );
      }
      return pPONes;
    }
    // CommonClasesCpbteVT lClaseCpbteVT =
    //     pParams?.claseCpbte ?? CommonClasesCpbteVT.unknown;
    var tData = rawDataDataData.nasPONs as List<PONModel>;

    List<CommonParamKeyValue<PONModel>> rResults = [];
    // if (pParams != null) {
    //   switch (pParams.claseCpbte) {
    //     case CommonClasesCpbteVT.ticketsRemedyVT:
    //       lClaseCpbteVT = CommonClasesCpbteVT.ticketsRemedyVT;
    //       break;
    //     case null:
    //       lClaseCpbteVT = CommonClasesCpbteVT.unknown;
    //       break;
    //     default:
    //       lClaseCpbteVT = pParams.claseCpbte!;

    //       /// ELEMENTO: NUEVO SERVICIO
    //       var eNewService =
    //           TableDetServicioDATOSClienteV2Model.fromNewNRoServicio(
    //               pEmpresa: eEmpresa,
    //               pCliente: eCliente,
    //               pClaseCpbteVT: claseCpbteVT);
    //       var kNewService = CommonParamKeyValue.fromType(
    //         tObject: eNewService,
    //       );
    //       rResults.add(kNewService);
    //       break;
    //   }
    // }
    for (var element in tData) {
      rResults.add(
        CommonParamKeyValue.fromType(
          tObject: element,
        ),
      );
    }
    pPONes = rResults;
    return pPONes;
  }

  /// filterSearchFromDropDownONUesBy
  /// Busca un registro por ID en la lista de dropDown
  Future<List<CommonParamKeyValue<ONUModel>>> filterSearchFromDropDownONUesBy({
    required String searchText,
    required WidgetRef wRef,
    required ProcedureParamsModel procedureParams,
    CommonGenericProcedureParamsModel? pParams,
  }) async {
    String funcionName = "$runtimeType";
    developer.log(
      'DEBUG_17888 [$funcionName] filterSearchFromDropDownONUesBy: $searchText - CodEmp:$codEmp - ID:$id',
      name: 'geryon_web_app_ws_v2',
    );
    // Implementación de búsqueda por ID
    TableNASModel fEnteSelected = this;
    GenericDataModel<TableNASModel> dataModel;
    String hashID = generateRandomUniqueHash();
    await wRef.read(notifierServiceProvider).mapThreadsToDataModels.set(
          key: hashID,
          value: GenericDataModel<TableNASModel>(
            wRef: wRef,
            debug: wRef.read(notifierServiceProvider).debug,
          ),
        );
    dataModel =
        wRef.read(notifierServiceProvider).mapThreadsToDataModels.get(hashID);
    dataModel.threadID = hashID;
    dataModel.pGlobalRequest = ConstRequests.customRequest;
    dataModel.pLocalRequest = ConstRequests.customRequest;
    dataModel.cEmpresa = eEmpresa;
    dataModel.cEncRecord = this;
    dataModel.fromJsonFunction = TableNASModel.fromJson;
    dataModel.threadParams = {};
    Map<String, dynamic> pLocalParams = {};
    switch (procedureParams.searchBy) {
      case "KeyONUsByPON":
        dataModel.threadParams = {
          'SelectBy': 'KeyONUsByPON',
          'CodEmp': codEmp,
          'ID': id,
          'PONID': procedureParams.pon,
          'ONUID': procedureParams.onu,
          'IsEmpresaAggregated': true,
        };
        pLocalParams = {
          'SelectBy': 'KeyONUsByPON',
          'CodEmp': codEmp,
          'ID': id,
          'PONID': procedureParams.pon,
          'ONUID': procedureParams.onu,
          'IsEmpresaAggregated': true,
          'ActionRequest': "ViewRecord",
          'DBVersion': 2,
          'Search': searchText,
          'ClaseCpbte': "",
        };
        break;
      default:

        /// Si no se especifica un tipo de búsqueda, entonces devuelvo un error
        var rError = ErrorHandler(
          errorCode: 777,
          errorDsc: '''Error al obtener los datos de la ONU seleccionada.
                    No se especificó un tipo de búsqueda válido.
                    Código de empresa: $codEmp
                    ID: $id
                    PON ID: ${procedureParams.pon.id}
                    ONU ID: ${procedureParams.onu.index}
                    ''',
          propertyName: 'SearchBy',
          propertyValue: procedureParams.searchBy,
          functionName: funcionName,
          className: className,
          stacktrace: StackTrace.current,
        );
        var eEnteFiltered = ONUModel.fromError(
          pPONId: procedureParams.pon,
          pFilter: searchText,
        );
        var cEnteFiltered = CommonParamKeyValue.fromType(
          tObject: eEnteFiltered,
        );
        pONUes = [cEnteFiltered];

        /// Si hay error, entonces lo muestro
        if (navigatorKey.currentContext != null) {
          await Navigator.of(navigatorKey.currentContext!).push(
            ModelGeneralPoPUpErrorMessageDialog(
              error: rError,
            ),
          );
        }
        return pONUes;
    }

    var pGenericParams = GenericModel.fromDefault();
    pGenericParams.pGlobalRequest = ConstRequests.customRequest;
    pGenericParams.pLocalRequest = ConstRequests.customRequest;
    pGenericParams.pActionRequest = ConstRequests.customRequest;
    pGenericParams.pTable = iDefaultTable();
    pGenericParams.pLocalParamsRequest = pLocalParams;
    ErrorHandler rFilteredRecords = await dataModel.filterSearchFromDropDown(
      pParams: pGenericParams,
      pEnte: fEnteSelected,
    );
    developer.log('DEBUG_8191 - $rFilteredRecords');
    if (rFilteredRecords.errorCode != 0) {
      /// Si hay error, entonces lo muestro
      /// y retorno el error
      rFilteredRecords.errorDsc = '''Error al obtener los datos del NAS.
          Código de empresa: $codEmp
          ID: $id
          ${rFilteredRecords.errorDsc}
          ''';
      rFilteredRecords.stacktrace ??= StackTrace.current;
      var eEnteFiltered = ONUModel.fromError(
        pPONId: procedureParams.pon,
        pFilter: searchText,
      );
      var cEnteFiltered = CommonParamKeyValue.fromType(
        tObject: eEnteFiltered,
      );
      pONUes = [cEnteFiltered];

      /// Si hay error, entonces lo muestro
      if (navigatorKey.currentContext != null) {
        await Navigator.of(navigatorKey.currentContext!).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: rFilteredRecords,
          ),
        );
      }
      return pONUes;
    }
    var rawData =
        rFilteredRecords.rawData as CommonDataModelWholeMessage<TableNASModel>;
    var rawDataData =
        rawData.data as CommonDataModelWholeDataMessage<TableNASModel>;
    var rawDataDataData = rawDataData.data;
    developer.log(
      'DEBUG_8191 - rawData: ${rawData.runtimeType} - rawDataData: ${rawDataData.runtimeType} - rawDataDataData: ${rawDataDataData.runtimeType}',
      name: 'geryon_web_app_ws_v2',
    );
    if (rawDataDataData.nasONUs == null) {
      /// Si no hay PONs asociados, entonces retorno un error
      var rError = ErrorHandler(
        errorCode: 888,
        errorDsc: '''No se encontraron ONUS asociados al NAS seleccionado.
                  Código de empresa: $codEmp
                  ID: $id
                  ''',
        propertyName: 'Data',
        propertyValue: rawDataDataData.nasONUs.toString(),
        functionName: funcionName,
        className: className,
        stacktrace: StackTrace.current,
      );
      var eEnteFiltered = ONUModel.fromError(
        pPONId: procedureParams.pon,
        pFilter: searchText,
      );
      var cEnteFiltered = CommonParamKeyValue.fromType(
        tObject: eEnteFiltered,
      );
      pONUes = [cEnteFiltered];

      /// Si hay error, entonces lo muestro
      if (navigatorKey.currentContext != null) {
        await Navigator.of(navigatorKey.currentContext!).push(
          ModelGeneralPoPUpErrorMessageDialog(
            error: rError,
          ),
        );
      }
      return pONUes;
    }
    // CommonClasesCpbteVT lClaseCpbteVT =
    //     pParams?.claseCpbte ?? CommonClasesCpbteVT.unknown;
    var tData = rawDataDataData.nasONUs as List<ONUModel>;

    List<CommonParamKeyValue<ONUModel>> rResults = [];
    // if (pParams != null) {
    //   switch (pParams.claseCpbte) {
    //     case CommonClasesCpbteVT.ticketsRemedyVT:
    //       lClaseCpbteVT = CommonClasesCpbteVT.ticketsRemedyVT;
    //       break;
    //     case null:
    //       lClaseCpbteVT = CommonClasesCpbteVT.unknown;
    //       break;
    //     default:
    //       lClaseCpbteVT = pParams.claseCpbte!;

    //       /// ELEMENTO: NUEVO SERVICIO
    //       var eNewService =
    //           TableDetServicioDATOSClienteV2Model.fromNewNRoServicio(
    //               pEmpresa: eEmpresa,
    //               pCliente: eCliente,
    //               pClaseCpbteVT: claseCpbteVT);
    //       var kNewService = CommonParamKeyValue.fromType(
    //         tObject: eNewService,
    //       );
    //       rResults.add(kNewService);
    //       break;
    //   }
    // }
    for (var element in tData) {
      rResults.add(
        CommonParamKeyValue.fromType(
          tObject: element,
        ),
      );
    }
    pONUes = rResults;
    return pONUes;
  }
}
