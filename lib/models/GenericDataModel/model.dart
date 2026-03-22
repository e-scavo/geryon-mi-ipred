import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';

class GenericModel {
  static const String className = "GenericModel";
  static const String logClassName = ".::$className::.";
  ConstRequests pGlobalRequest;
  ConstRequests pLocalRequest;
  ConstRequests pActionRequest;
  String pTable;
  String pSearchText = "";
  bool pReturnResults = true;
  Map<String, dynamic>? pLocalParamsRequest;

  GenericModel._internal({
    required this.pGlobalRequest,
    required this.pLocalRequest,
    required this.pActionRequest,
    required this.pTable,
    required this.pSearchText,
    required this.pReturnResults,
    required this.pLocalParamsRequest,
  });

  factory GenericModel.fromDefault() {
    ConstRequests pGlobalRequest = ConstRequests.viewRequest;
    ConstRequests pLocalRequest = ConstRequests.viewRequest;
    ConstRequests pActionRequest = ConstRequests.viewRequest;
    String pTable = "DefaultTable";
    String pSearchText = "";
    bool pReturnResults = true;
    Map<String, dynamic>? pLocalParamsRequest;
    return GenericModel._internal(
      pGlobalRequest: pGlobalRequest,
      pLocalRequest: pLocalRequest,
      pActionRequest: pActionRequest,
      pTable: pTable,
      pSearchText: pSearchText,
      pReturnResults: pReturnResults,
      pLocalParamsRequest: pLocalParamsRequest,
    );
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  Map<String, dynamic> toJson() {
    return {
      "GlobalRequest": pGlobalRequest.typeId,
      "LocalRequest": pLocalRequest.typeId,
      "ActionRequest": pActionRequest.typeId,
      "Table": pTable,
      "SearchText": pSearchText,
      "ReturnResults": pReturnResults,
      "LocalParamsRequest": pLocalParamsRequest,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! GenericModel) return false;

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
