class HeaderParamsRequest {
  bool jsonData = true;
  int offset = -1;
  int pageSize = -1;
  String sortField = '';
  int sortIndex = -1;
  bool sortAsc = false;
  String table = "";
  String actionRequest = "SCRUD:";
  String lang = 'es-AR';
  String search = '';
  String realGlobalRequest = 'UnknownRequest';
  String realLocalRequest = 'UnknownRequest';
  String globalRequest = 'UnknownRequest';
  String localRequest = 'UnknownRequest';
  Map<String, dynamic> localParams = {
    'Target': 'customers',
  };

  HeaderParamsRequest();

  @override
  String toString() {
    return toMap().toString();
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  Map<String, dynamic> toJson() {
    return {
      'JSON_Data': jsonData,
      'Offset': offset,
      'PageSize': pageSize,
      'SortField': sortField,
      'SortIndex': sortIndex,
      'SortAsc': sortAsc,
      'Table': table,
      'ActionRequest': actionRequest,
      'Lang': lang,
      'Search': search,
      'RealGlobalRequest': realGlobalRequest,
      'RealLocalRequest': realLocalRequest,
      'GlobalRequest': globalRequest,
      'LocalRequest': localRequest,
      'LocalParams': localParams,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! HeaderParamsRequest) return false;

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
}
