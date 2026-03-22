import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonParamRequest/header_request.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonParamRequest extends Equatable {
  static final String _className = "CommonParamRequest";
  static final String logClassName = ".::$_className::.";
  final Map<String, dynamic> pRequest;
  final Map<String, dynamic> pLocalParams;
  final Map<String, dynamic> pOptions;

  const CommonParamRequest._internal({
    required this.pRequest,
    required this.pLocalParams,
    required this.pOptions,
  });

  factory CommonParamRequest.fromData({
    required String pAction,
    required String pTable,
    required ConstRequests pGlobalRequest,
    required ConstRequests pLocalRequest,
    required Map<String, dynamic> pLocalParams,
    String pLang = "es-AR",
    Duration pDuration = const Duration(seconds: 10),
    HeaderParamsRequest? pHeaderParamsRequest,
  }) {
    const String functionName = 'fromData';

    /// Header:
    Map<String, dynamic> pRequest = {};
    pRequest['ChannelName'] = 'GERYON_General_SCRUD';
    pRequest['Action'] = pAction;

    /// Header => pParams
    Map<String, dynamic> pParams = {};
    pParams['JSON_Data'] = true;
    pParams['Table'] = pTable;
    pParams['ActionRequest'] = 'SCRUD:$pTable';
    pParams['GlobalRequest'] = pGlobalRequest.typeId;
    pParams['LocalRequest'] = pLocalRequest.typeId;
    pParams['Lang'] = pLang;
    if (pHeaderParamsRequest != null) {
      if (pTable.isEmpty) {
        if (pHeaderParamsRequest.table.isEmpty) {
          var errorDsc = 'La propiedad "Table" no ha sido especificada\r\n';
          errorDsc += 'ni comomo parámetro general pTable\r\n';
          errorDsc += 'ni como parámetro en pHeaderParamsRequest\r\n';
          throw ErrorHandler(
            errorCode: 330,
            errorDsc: errorDsc,
            className: _className,
            functionName: functionName,
            propertyName: 'Table',
            propertyValue: '',
            stacktrace: StackTrace.current,
          );
        }
        pTable = pHeaderParamsRequest.table;
        pParams['Table'] = pTable;
        pParams['ActionRequest'] = 'SCRUD:$pTable';
      }
      pHeaderParamsRequest.toMap().forEach((key, value) {
        pParams[key] = value;
      });

      /// Valido si existe Header => pParams => LocalParams
      /// Si existe, esta tiene predominancia por sobre el parámetro pLocalParams
      /// enviada al procedimiento
      if (pHeaderParamsRequest.localParams.isNotEmpty) {
        pLocalParams = pHeaderParamsRequest.localParams;
      }
      if (pLocalParams["Target"] == null || pLocalParams["Target"].isEmpty) {
        pLocalParams["Target"] = "customers";
      }
    }
    Map<String, dynamic> pOptions = {};
    pOptions['requestTimeOut'] = pDuration;
    pOptions['responseDuration'] = const Duration(seconds: 0);

    pRequest['pParams'] = pParams;

    var rData = CommonParamRequest._internal(
      pRequest: pRequest,
      pLocalParams: pLocalParams,
      pOptions: pOptions,
    );
    log("$logClassName - rData:[$rData]");
    return rData;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = pRequest;
    map["LocalParams"] = pLocalParams;
    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  String toJson() {
    return toMap().toString();
  }

  @override
  List<Object?> get props => [
        pRequest,
      ];
}
