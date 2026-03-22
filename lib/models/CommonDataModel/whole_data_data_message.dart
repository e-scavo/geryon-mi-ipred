import 'dart:developer';

import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/whole_data_data_local_params_message.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFileDescriptorModel/common_file_descriptor_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonSendMassiveEmailModel/model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/onu_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/pon_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Paises/model.dart';

/// import 'package:geryon_erp_app/models/extensions/numbers_extensions.dart';

class CommonDataModelWholeDataDataMessage<T extends CommonModel<T>> {
  static const String className = "CommonDataModelWholeDataDataMessage";
  final String actionRequest;
  final ConstRequests globalRequest;
  final ConstRequests localRequest;

  final bool jsonData;
  final String lang;
  final CommonDataModelWholeDataDataLocalParamsMessage<T> localParams;
  final List<T> records;
  final int totalFilteredRecords;
  final int totalRecords;
  final dynamic additionalData;
  final String descriptionOnRecordsAdded;
  final String descriptionOnRecordsDuplicated;
  final String descriptionOnRecordsOnErrors;
  final List<CommonSendMassiveEmailModel> sendMassiveEmailRecords;

  final List<CommonFileDescriptorModel> lFiles;

  final Map<String, dynamic> grandTotals;
  final List<PONModel>? nasPONs;
  final List<ONUModel>? nasONUs;

  /// Method to create the real object depends on the entry we receive
  const CommonDataModelWholeDataDataMessage._internal({
    required this.actionRequest,
    required this.globalRequest,
    required this.localRequest,
    required this.jsonData,
    required this.lang,
    required this.localParams,
    required this.records,
    required this.totalFilteredRecords,
    required this.totalRecords,
    required this.additionalData,
    required this.descriptionOnRecordsAdded,
    required this.descriptionOnRecordsDuplicated,
    required this.descriptionOnRecordsOnErrors,
    required this.sendMassiveEmailRecords,
    required this.lFiles,
    required this.grandTotals,
    this.nasPONs,
    this.nasONUs,
  });

  /// Create the object fromDefault parameteres
  factory CommonDataModelWholeDataDataMessage.fromDefault() {
    var actionRequest = "";
    var globalRequest = ConstRequests.unknown;
    var localRequest = ConstRequests.unknown;
    var jsonData = true;
    var lang = "";
    List<T> records = [];
    var totalFilteredRecords = -1;
    var totalRecords = -1;
    dynamic additionalData;
    var localParams =
        CommonDataModelWholeDataDataLocalParamsMessage<T>.fromDefault();
    String descriptionOnRecordsAdded = "";
    String descriptionOnRecordsDuplicated = "";
    String descriptionOnRecordsOnErrors = "";
    List<CommonSendMassiveEmailModel> sendMassiveEmailRecords = [];

    List<CommonFileDescriptorModel> lFiles = [];

    Map<String, dynamic> grandTotals = {};

    return CommonDataModelWholeDataDataMessage._internal(
      actionRequest: actionRequest,
      globalRequest: globalRequest,
      localRequest: localRequest,
      jsonData: jsonData,
      lang: lang,
      localParams: localParams,
      records: records,
      totalFilteredRecords: totalFilteredRecords,
      totalRecords: totalRecords,
      additionalData: additionalData,
      descriptionOnRecordsAdded: descriptionOnRecordsAdded,
      descriptionOnRecordsDuplicated: descriptionOnRecordsDuplicated,
      descriptionOnRecordsOnErrors: descriptionOnRecordsOnErrors,
      sendMassiveEmailRecords: sendMassiveEmailRecords,
      lFiles: lFiles,
      grandTotals: grandTotals,
    );
  }

  /// Convert from `Map` to [this].
  factory CommonDataModelWholeDataDataMessage.fromJson({
    required Map<String, dynamic> map,
    required T Function({
      required Map<String, dynamic> map,
      int errorCode,
    }) fromJsonFunction,
    required int errorCode,
  }) {
    String funcName = 'fromJson';
    String supportMessage =
        '\r\nPlease try again in few seconds or contact support if the problem continues.';
    CommonDataModelWholeDataDataLocalParamsMessage<T> localParams;
    try {
      if (map['LocalParams'] is Map<String, dynamic>) {
        localParams = CommonDataModelWholeDataDataLocalParamsMessage.fromJson(
            map['LocalParams'], errorCode);
      } else {
        localParams =
            CommonDataModelWholeDataDataLocalParamsMessage.fromDefault();
      }
    } catch (e, stacktrace) {
      /// Always throw an ErrorHandler instance (no matter what)
      /// This is to standarize
      if (e is ErrorHandler) {
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 78999,
          errorDsc: e.toString(),
          propertyName: "LocalParams",
          className: className,
          stacktrace: stacktrace,
        );
      }
    }
    List<String> propSanity = [];
    switch (localParams.actionRequest) {
      /// Trabajos acá los comunes
      ///
      case "FilterDataSuspensionDeServicioMasivaByPeriodo":
      case "FilterDataReactivacionDeServicioMasivaByPeriodo":
      case "GenerateBillingFromMassiveProcessByPeriod":
      case "GenerateDetComprobantesPedidosVTFromPerfilVT":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalRecords',
        ];
        break;

      /// Old
      ///
      case "GenerateAndDownloadPDFFromVoucher":
        propSanity = [
          'ActionRequest',
          'AdditionalData',
          'Records',
          'TotalRecords',
        ];
        break;
      case "SendMassiveBillingEmails":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalRecords',
        ];
        break;
      case "ChangeRecord":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalRecords',
        ];
        break;
      case "CancelRecord":
      case "SaveRecord":
      case "RevertRecord":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalRecords',
        ];
        break;
      case "PendingBalancesEmailNotifications":
        //'AdditionalData',
        propSanity = [
          'PendingBalancesEmailNotificationsRecords',
          'ActionRequest',
          'Records',
          'TotalRecords',
        ];
        break;
      case "GenerateNewBill":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalRecords',
        ];
        break;
      case "GetDataForBillingDueBilling":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalRecords',
          'CustomRequestGetDataForBillDueBilling',
        ];
        break;
      case "FindNewBills":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalRecords',
        ];
        break;
      case "ViewRecord":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalFilteredRecords',
          'TotalRecords',
        ];
        break;
      case "InsertRecord":
        propSanity = [
          'ActionRequest',
          'Records',
          'TotalRecords',
        ];
        break;
      default:
        throw ErrorHandler(
          errorCode: 78998,
          errorDsc:
              "LocalParams=>ActionRequest es inválida.\r\nActionRequest=>${localParams.actionRequest}\r\nTable=>${localParams.table}",
          propertyName: "Whole=>Data=>Data=>LocalParams",
          className: className,
        );
    }
    List<String> errorPropSanity = [];
    for (String prop in propSanity) {
      if (!map.containsKey(prop)) {
        errorPropSanity.add(prop);
      }
    }
    if (errorPropSanity.isNotEmpty) {
      var eMessage = '''Action: ${localParams.actionRequest} => 
      The following properties haven't been provided by the backend.
      ${errorPropSanity.toString()}      
      $supportMessage
      ''';
      throw ErrorHandler(
        errorCode: 78997,
        errorDsc: eMessage,
        className: className,
      );
    }
    try {
      /// Nullable variables
      ///

      ///
      if (map['ActionRequest'] is! String ||
          (map['ActionRequest'] is String &&
              (map['ActionRequest'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'ActionRequest',
          className: className,
        );
      }
      String actionRequest = map['ActionRequest'];

      if (map['GlobalRequest'] is! String ||
          (map['GlobalRequest'] is String &&
              (map['GlobalRequest'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'GlobalRequest',
          className: className,
        );
      }
      var tGlobalRequest =
          ConstRequests.getById(map['GlobalRequest'].toString());
      if (tGlobalRequest == ConstRequests.unknown) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'GlobalRequest',
          className: className,
        );
      }
      var globalRequest = tGlobalRequest;

      if (map['LocalRequest'] is! String ||
          (map['LocalRequest'] is String &&
              (map['LocalRequest'] as String).isEmpty)) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'LocalRequest',
          className: className,
        );
      }
      var tLocalRequest = ConstRequests.getById(map['LocalRequest'].toString());
      if (tLocalRequest == ConstRequests.unknown) {
        throw ErrorHandler(
          errorCode: 200101,
          errorDsc: 'Can\'t be empty.$supportMessage',
          propertyName: 'LocalRequest',
          className: className,
        );
      }
      var localRequest = tLocalRequest;
      bool jsonData = true;
      String lang = "";

      int totalRecords = -1;
      int totalFilteredRecords = -1;
      dynamic additionalData = map['AdditionalData'];

      String descriptionOnRecordsAdded = "";
      String descriptionOnRecordsDuplicated = "";
      String descriptionOnRecordsOnErrors = "";
      List<CommonSendMassiveEmailModel> sendMassiveEmailRecords = [];
      List<CommonFileDescriptorModel> lFiles = [];

      bool isEmpresaAggregated = false;
      TableEmpresaModel eEmpresa = TableEmpresaModel.fromDefault();
      bool isPaisAggregated = false;
      TablePaisModel ePais = TablePaisModel.fromDefault(
        pEmpresa: eEmpresa,
      );
      // TableProvinciaModel eProvincia = TableProvinciaModel.fromDefault(
      //   pEmpresa: eEmpresa,
      //   pPais: ePais,
      // );

      Map<String, dynamic> grandTotals = {};
      if (map['GrandTotals'] is Map<String, dynamic>) {
        grandTotals = map['GrandTotals'];
      } else {
        grandTotals = {};
      }
      List<PONModel> nasPONs = [];
      if (map["NASPONs"] is List<dynamic>) {
        List<dynamic> nasPONsList = map["NASPONs"];
        if (nasPONsList.isEmpty) {
          nasPONs = [];
        } else if (nasPONsList.first is Map<String, dynamic>) {
          nasPONs = nasPONsList
              .map(
                (e) => PONModel.fromJson(map: e),
              )
              .toList();
        } else {
          throw ErrorHandler(
            errorCode: 78500,
            errorDsc: '''Error en subproceso:
                LocalParams=>ActionRequest ${localParams.actionRequest}
                NASPONs: esperábamos encontrar List<Map<String,dynamic>> y encontramos ${nasPONsList.runtimeType}''',
            propertyName: "Whole=>Data=>Data=>NASPONs",
            className: className,
            stacktrace: StackTrace.current,
          );
        }
      } else {
        nasPONs = [];
      }
      List<ONUModel> nasONUs = [];
      if (map["PONONUs"] is List<dynamic>) {
        List<dynamic> nasONUsList = map["PONONUs"];
        if (nasONUsList.isEmpty) {
          nasONUs = [];
        } else if (nasONUsList.first is Map<String, dynamic>) {
          nasONUs = nasONUsList
              .map(
                (e) => ONUModel.fromJson(map: e),
              )
              .toList();
        } else {
          throw ErrorHandler(
            errorCode: 78500,
            errorDsc: '''Error en subproceso:
                LocalParams=>ActionRequest ${localParams.actionRequest}
                PONONUs: esperábamos encontrar List<Map<String,dynamic>> y encontramos ${nasONUsList.runtimeType}''',
            propertyName: "Whole=>Data=>Data=>PONONUs",
            className: className,
            stacktrace: StackTrace.current,
          );
        }
      } else {
        nasONUs = [];
      }
      switch (localParams.actionRequest) {
        case "PendingBalancesEmailNotifications":
          switch (localParams.subActionRequest) {
            case "GetData":
              var data = map["PendingBalancesEmailNotificationsRecords"];
              if (data is! List<dynamic>) {
                throw ErrorHandler(
                  errorCode: 78500,
                  errorDsc: '''Error en subproceso:
                LocalParams=>ActionRequest ${localParams.actionRequest}
                PendingBalancesEmailNotifications: esperábamos encontrar List<dynamic> y encontramos ${data.runtimeType}''',
                  propertyName:
                      "Whole=>Data=>Data=>PendingBalancesEmailNotifications",
                  className: className,
                  stacktrace: StackTrace.current,
                );
              }
              List<dynamic> dataList = data;
              sendMassiveEmailRecords = dataList
                  .map(
                    (e) => CommonSendMassiveEmailModel.fromMap(e),
                  )
                  .toList();
              if (int.tryParse(map['TotalFilteredRecords'].toString()) ==
                  null) {
                throw ErrorHandler(
                  errorCode: 200101,
                  errorDsc: 'Can\'t be empty.$supportMessage',
                  propertyName: 'TotalFilteredRecords',
                );
              }
              totalFilteredRecords =
                  int.parse(map['TotalFilteredRecords'].toString());
              break;
          }
          if (int.tryParse(map['TotalRecords'].toString()) == null) {
            throw ErrorHandler(
              errorCode: 200101,
              errorDsc: 'Can\'t be empty.$supportMessage',
              propertyName: 'TotalRecords',
            );
          }

          totalRecords = int.parse(map['TotalRecords'].toString());
          break;
        case "GenerateAndDownloadPDFFromVoucher":
          additionalData = map["AdditionalData"];
          if (additionalData is! Map<String, dynamic>) {
            throw ErrorHandler(
              errorCode: 78500,
              errorDsc: '''Error en subproceso:
                LocalParams=>ActionRequest ${localParams.actionRequest}
                AdditionalData: esperábamos encontrar Map<String,dynamic> y encontramos ${additionalData.runtimeType}''',
              propertyName: "Whole=>Data=>Data=>AdditionalData",
              className: className,
              stacktrace: StackTrace.current,
            );
          }
          Map<String, dynamic> additionalDataAsMAP = additionalData;
          if (additionalDataAsMAP["Files"] is! List<dynamic>) {
            throw ErrorHandler(
              errorCode: 78501,
              errorDsc: '''Error en subproceso:
                LocalParams=>ActionRequest ${localParams.actionRequest}
                AdditionalData: ${additionalDataAsMAP.runtimeType}
                AdditionalData=>Files: esperábamos encontrar List<dynamic> y encontramos ${additionalDataAsMAP["Files"]?.runtimeType}''',
              propertyName: "Whole=>Data=>Data=>AdditionalData=>Files[]",
              className: className,
              stacktrace: StackTrace.current,
            );
          }
          List<dynamic> filesReceived = additionalDataAsMAP["Files"];
          for (var element in filesReceived) {
            if (element is! Map<String, dynamic>) {
              throw ErrorHandler(
                errorCode: 78500,
                errorDsc: '''Error en subproceso:
                LocalParams=>ActionRequest ${localParams.actionRequest}
                AdditionalData: ${additionalDataAsMAP.runtimeType}
                AdditionalData=>Files: ${filesReceived.runtimeType}
                AdditionalData=>Files=>File: esperábamos encontrar Map<String,dynamic> y encontramos ${element.runtimeType}''',
                propertyName: "Whole=>Data=>Data=>AdditionalData=>Files=>File",
                className: className,
                stacktrace: StackTrace.current,
              );
            }
            Map<String, dynamic> file = element;
            try {
              var cFile = CommonFileDescriptorModel.fromJson(element);
              lFiles.add(cFile);
            } catch (e, stacktrace) {
              if (e is ErrorHandler) {
                e.stacktrace ?? stacktrace;
                rethrow;
              } else {
                throw ErrorHandler(
                  errorCode: 78500,
                  errorDsc: '''Error en subproceso:
                LocalParams=>ActionRequest ${localParams.actionRequest}
                AdditionalData: ${additionalDataAsMAP.runtimeType}
                AdditionalData=>Files: ${filesReceived.runtimeType}
                AdditionalData=>Files=>File: ${file.runtimeType}
                Error: ${e.toString()}''',
                  propertyName:
                      "Whole=>Data=>Data=>AdditionalData=>Files=>File",
                  propertyValue: file.toString(),
                  className: className,
                  stacktrace: stacktrace,
                );
              }
            }
          }

          break;
        case "FilterDataSuspensionDeServicioMasivaByPeriodo":
        case "FilterDataReactivacionDeServicioMasivaByPeriodo":
        case "GenerateBillingFromMassiveProcessByPeriod":
        case "GenerateDetComprobantesPedidosVTFromPerfilVT":
        case "SendMassiveBillingEmails":
        case "SendEmail":
          break;
        case "GenerateNewBill":
          break;
        case "GetDataForBillingDueBilling":
          break;
        case "FindNewBills":
          break;
        case "CancelRecord":
          break;
        case "SaveRecord":
          break;
        case "ChangeRecord":
        case "RevertRecord":
          totalRecords = int.parse(map['TotalRecords'].toString());

          if (bool.tryParse(map['IsEmpresaAggregated'].toString()) != null) {
            isEmpresaAggregated =
                bool.parse(map['IsEmpresaAggregated'].toString());
          }
          if (isEmpresaAggregated) {
            eEmpresa = TableEmpresaModel.fromJson(map["Empresa"]);
          }
          break;
        case "ViewRecord":
          if (int.tryParse(map['TotalFilteredRecords'].toString()) == null) {
            throw ErrorHandler(
              errorCode: 200101,
              errorDsc: 'Can\'t be empty.$supportMessage',
              propertyName: 'TotalFilteredRecords',
              propertyValue: map['TotalFilteredRecords'].toString(),
              className: className,
              functionName: funcName,
              stacktrace: StackTrace.current,
            );
          }
          totalFilteredRecords =
              int.parse(map['TotalFilteredRecords'].toString());
          if (int.tryParse(map['TotalRecords'].toString()) == null) {
            throw ErrorHandler(
              errorCode: 200101,
              errorDsc: 'Can\'t be empty.$supportMessage',
              propertyName: 'TotalRecords',
            );
          }
          totalRecords = int.parse(map['TotalRecords'].toString());

          if (bool.tryParse(map['IsEmpresaAggregated'].toString()) != null) {
            isEmpresaAggregated =
                bool.parse(map['IsEmpresaAggregated'].toString());
          }
          if (isEmpresaAggregated) {
            eEmpresa = TableEmpresaModel.fromJson(map["Empresa"]);
          }

          if (bool.tryParse(map['IsPaisAggregated'].toString()) != null) {
            isPaisAggregated = bool.parse(map['IsPaisAggregated'].toString());
          }
          if (isPaisAggregated) {
            ePais = TablePaisModel.fromJson(
              map: map["Pais"],
              errorCode: errorCode,
              pEmpresa: eEmpresa,
            );
          }

          break;
        case "InsertRecord":
          switch (globalRequest) {
            case ConstRequests.viewRequest:
              switch (localRequest) {
                case ConstRequests.viewRequest:
                  if (int.tryParse(map['TotalFilteredRecords'].toString()) ==
                      null) {
                    throw ErrorHandler(
                      errorCode: 200101,
                      errorDsc: 'Can\'t be empty.$supportMessage',
                      propertyName: 'TotalFilteredRecords',
                      propertyValue: map['TotalFilteredRecords'].toString(),
                      className: className,
                      functionName: funcName,
                      stacktrace: StackTrace.current,
                    );
                  }
                  totalFilteredRecords =
                      int.parse(map['TotalFilteredRecords'].toString());
                  if (int.tryParse(map['TotalRecords'].toString()) == null) {
                    throw ErrorHandler(
                      errorCode: 200101,
                      errorDsc: 'Can\'t be empty.$supportMessage',
                      propertyName: 'TotalRecords',
                    );
                  }
                  totalRecords = int.parse(map['TotalRecords'].toString());

                  break;
                default:
              }
              break;
            default:
          }
          break;
        default:
          throw ErrorHandler(
            errorCode: 78996,
            errorDsc:
                "LocalParams=>ActionRequest es inválida.\r\nActionRequest=>${localParams.actionRequest}\r\nTable=>${localParams.table}",
            propertyName: "Whole=>Data=>Data=>LocalParams",
            className: className,
          );
      }

      /// Common fields received from JSON
      if (map['Records'] is! List<dynamic>) {
        if (map['Records'] is! List<dynamic>) {
          throw ErrorHandler(
            errorCode: 200101,
            errorDsc:
                'It is not an List<dynamic>. It is a ${map['Records'].runtimeType}.$supportMessage',
            propertyName: 'Records',
            className: className,
          );
        }
      }
      List<T> records = [];
      try {
        records = (map['Records'] as List<dynamic>).map(
          (e) {
            if (e is! Map<String, dynamic>) {
              throw ErrorHandler(
                errorCode: 200103,
                errorDsc:
                    'Data => Records => Element is not a Map<String,dynamic>. It is ${e.runtimeType}',
                propertyName: 'data => Records => element',
                className: className,
              );
            }
            T rr = CommonModel.fromJson(
              map: e,
              errorCode: errorCode,
              fromJsonFunction: fromJsonFunction,
            );
            return rr;
          },
        ).toList();
      } catch (e, stacktrace) {
        log('aaaaaa: - $e - $stacktrace ');
        if (e is ErrorHandler) {
          throw ErrorHandler(
            errorCode: e.errorCode,
            errorDsc: 'Data => Records => ${e.errorDsc}',
            propertyName: 'data => Records => ${e.propertyName}',
            propertyValue: e.propertyValue.toString(),
            className: '$className <= from: ${e.className}',
            functionName: e.functionName,
            stacktrace: e.stacktrace ??= stacktrace,
          );
        } else {
          throw ErrorHandler(
            errorCode: 78995,
            errorDsc: "Internal error catched: ${e.toString()}",
            propertyName: "data <= unknown",
            className: className,
            stacktrace: stacktrace,
          );
        }
      }

      return CommonDataModelWholeDataDataMessage._internal(
        actionRequest: actionRequest,
        globalRequest: globalRequest,
        localRequest: localRequest,
        jsonData: jsonData,
        lang: lang,
        localParams: localParams,
        records: records,
        totalFilteredRecords: totalFilteredRecords,
        totalRecords: totalRecords,
        additionalData: additionalData,
        descriptionOnRecordsAdded: descriptionOnRecordsAdded,
        descriptionOnRecordsDuplicated: descriptionOnRecordsDuplicated,
        descriptionOnRecordsOnErrors: descriptionOnRecordsOnErrors,
        sendMassiveEmailRecords: sendMassiveEmailRecords,
        lFiles: lFiles,
        grandTotals: grandTotals,
        nasPONs: nasPONs,
        nasONUs: nasONUs,
      );
    } catch (e) {
      if (e is ErrorHandler) {
        rethrow;
      } else {
        throw ErrorHandler(
          errorCode: 78994,
          errorDsc: 'Error on decoding JSON. Error [${e.toString()}]',
          propertyName: "Whole => data => data",
          className: className,
        );
      }
    }
  }

  /// Convert from [this] to `Map<String,synamic` JSON.
  ///
  Map<String, dynamic> toJson() {
    return {
      'ActionRequest': actionRequest,
      'JSON_Data': jsonData,
      'Lang': lang,
      'LocalParams': localParams,
      'Records': records,
      'TotalFilteredRecords': totalFilteredRecords,
      'TotalRecords': totalRecords,
      'AdditionalData': additionalData,
      'DescriptionOnRecordsAdded': descriptionOnRecordsAdded,
      'DescriptionOnRecordsDuplicated': descriptionOnRecordsDuplicated,
      'DescriptionOnRecordsOnErrors': descriptionOnRecordsOnErrors,
      'SendMassiveEmailRecords': sendMassiveEmailRecords,
      'LFiles': lFiles,
      'GrandTotals': grandTotals,
      'NASPONs': nasPONs,
      'NASONUs': nasONUs,
    };
  }

  /// Convert from [this] to `Map<String,synamic` JSON.
  ///
  Map<String, dynamic> toMap() {
    return {
      'actionRequest': actionRequest,
      'jsonData': jsonData,
      'lang': lang,
      'localParams': localParams,
      'records': records,
      'totalFilteredRecords': totalFilteredRecords,
      'totalRecords': totalRecords,
      'additionalData': additionalData,
      'descriptionOnRecordsAdded': descriptionOnRecordsAdded,
      'descriptionOnRecordsDuplicated': descriptionOnRecordsDuplicated,
      'descriptionOnRecordsOnErrors': descriptionOnRecordsOnErrors,
      'sendMassiveEmailRecords': sendMassiveEmailRecords,
      'lFiles': lFiles,
      'grandTotals': grandTotals,
      'nasPONs': nasPONs,
      'nasONUs': nasONUs,
    };
  }

  String toJsonString() {
    return toJson().toString();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonDataModelWholeDataDataMessage) return false;

    Map<String, dynamic> thisMap = toJson();
    Map<String, dynamic> otherMap = other.toJson();

    for (String key in thisMap.keys) {
      if (thisMap[key].runtimeType != otherMap[key].runtimeType) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    return toJson().values.fold(0,
        (previousValue, element) => previousValue.hashCode + element.hashCode);
  }
}
