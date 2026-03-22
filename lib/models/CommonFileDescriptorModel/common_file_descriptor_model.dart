import 'package:geryon_web_app_ws_v2/models/CommonFileDescriptorModel/common_file_descriptor_metadata_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonFileDescriptorModel {
  static const className = "CommonFileDescriptorModel";
  int id;
  int emailID;
  String fileName;
  String filePath;
  String fileNameOnDisk;
  String mimeType;
  String dataInBase64;
  int size;
  CommonFileDescriptorMetaDataModel metaData;
  String fromType;

  CommonFileDescriptorModel._internal({
    required this.id,
    required this.emailID,
    required this.fileName,
    required this.filePath,
    required this.fileNameOnDisk,
    required this.mimeType,
    required this.dataInBase64,
    required this.size,
    required this.metaData,
    required this.fromType,
  });

  factory CommonFileDescriptorModel.fromDefault() {
    int id = -1;
    int emailID = -1;
    String fileName = "";
    String filePath = "";
    String fileNameOnDisk = "";
    String mimeType = "";
    String dataInBase64 = "";
    int size = 0;
    CommonFileDescriptorMetaDataModel metaData =
        CommonFileDescriptorMetaDataModel.fromDefault();
    String fromType = "Default";
    return CommonFileDescriptorModel._internal(
      id: id,
      emailID: emailID,
      fileName: fileName,
      filePath: filePath,
      fileNameOnDisk: fileNameOnDisk,
      mimeType: mimeType,
      dataInBase64: dataInBase64,
      size: size,
      metaData: metaData,
      fromType: fromType,
    );
  }

  factory CommonFileDescriptorModel.fromJson(Map<String, dynamic> map) {
    const functionName = "fromJson";
    var orig = CommonFileDescriptorModel.fromDefault();
    if (map["ID"] is! int) {
      throw ErrorHandler(
        errorCode: 9800,
        errorDsc: '''El campo `ID` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["ID"].runtimeType}]''',
        propertyName: "ID",
        propertyValue: map["ID"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.id = map["ID"];

    if (map["EmailID"] is! int) {
      throw ErrorHandler(
        errorCode: 9801,
        errorDsc: '''El campo `EmailID` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["EmailID"].runtimeType}]''',
        propertyName: "EmailID",
        propertyValue: map["EmailID"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.emailID = map["EmailID"];

    if (map["FileName"] is! String) {
      throw ErrorHandler(
        errorCode: 9803,
        errorDsc: '''El campo `FileName` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["FileName"].runtimeType}]''',
        propertyName: "FileName",
        propertyValue: map["FileName"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.fileName = map["FileName"];

    if (map["FilePath"] is! String) {
      throw ErrorHandler(
        errorCode: 9807,
        errorDsc: '''El campo `FilePath` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["FilePath"].runtimeType}]''',
        propertyName: "FilePath",
        propertyValue: map["FilePath"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.filePath = map["FilePath"];

    if (map["MIMEType"] is! String) {
      throw ErrorHandler(
        errorCode: 9804,
        errorDsc: '''El campo `MIMEType` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["MIMEType"].runtimeType}]''',
        propertyName: "MIMEType",
        propertyValue: map["MIMEType"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.mimeType = map["MIMEType"];

    if (map["Data"] is! String) {
      throw ErrorHandler(
        errorCode: 9805,
        errorDsc: '''El campo `Data` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["Data"].runtimeType}]''',
        propertyName: "Data",
        propertyValue: map["Data"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.dataInBase64 = map["Data"];

    if (map["Size"] is! int) {
      throw ErrorHandler(
        errorCode: 9806,
        errorDsc: '''El campo `Size` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["Size"].runtimeType}]''',
        propertyName: "Size",
        propertyValue: map["Size"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.size = map["Size"];
    if (map["MetaData"] is Map<String, dynamic>) {
      var metaData =
          CommonFileDescriptorMetaDataModel.fromJson(map["MetaData"]);
      orig.metaData = metaData;
    }

    orig.fromType = "Json";
    return orig;
  }

  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "EmailID": emailID,
      "FileName": fileName,
      "FilePath": filePath,
      "FileNameOnDisk": fileNameOnDisk,
      "MIMEType": mimeType,
      "DataInBase64": dataInBase64,
      "Size": size,
      "MetaData": metaData,
      "FromType": fromType,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonFileDescriptorModel) return false;

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
