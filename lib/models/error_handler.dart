class ErrorHandler extends Error {
  int errorCode;
  String? errorDsc;
  dynamic data;
  late bool byDefault;
  String? propertyName;
  String? propertyValue;
  String? className;
  String? functionName;
  StackTrace? stacktrace;
  String messageID;
  dynamic rawData;

  ErrorHandler({
    this.errorCode = 0,
    this.errorDsc,
    this.data,
    this.byDefault = false,
    this.propertyName,
    this.propertyValue,
    this.className,
    this.functionName,
    this.stacktrace,
    this.messageID = "",
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['error_code'] = errorCode;
    map['error_dsc'] = errorDsc;
    map['data'] = data;
    map['by_default'] = byDefault;
    map['propertyName'] = propertyName;
    map['propertyValue'] = propertyValue;
    map['className'] = className;
    map['functionName'] = functionName;
    map['stacktrace'] = stacktrace;
    map['messageID'] = messageID;
    map['rawData'] = rawData;
    return map;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['Error_Code'] = errorCode;
    map['Error_Dsc'] = errorDsc;
    map['Data'] = data;
    map['ByDefault'] = byDefault;
    map['PropertyName'] = propertyName;
    map['PropertyValue'] = propertyValue;
    map['ClassName'] = className;
    map['FunctionName'] = functionName;
    map['Stacktrace'] = stacktrace;
    map['MessageID'] = messageID;
    map['RawData'] = rawData;
    return map;
  }

  String toErrorString() => errorDsc!;

  String toJsonString() {
    return toJson().toString();
  }

  @override
  String toString() {
    // ToDo: implement toString
    return toMap().toString();
  }
}
