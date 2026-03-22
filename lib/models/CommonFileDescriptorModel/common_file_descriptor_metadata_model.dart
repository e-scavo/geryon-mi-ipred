import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class CommonFileDescriptorMetaDataModel {
  static const className = "CommonFileDescriptorMetaDataModel";
  String claseCpbte;
  int nroCpbte;
  String tipoCliente;
  int codClie;
  String fromType;

  CommonFileDescriptorMetaDataModel._internal({
    required this.claseCpbte,
    required this.nroCpbte,
    required this.tipoCliente,
    required this.codClie,
    required this.fromType,
  });

  factory CommonFileDescriptorMetaDataModel.fromDefault() {
    String claseCpbte = "";
    int nroCpbte = -1;
    String tipoCliente = "";
    int codClie = -1;
    String fromType = "Default";
    return CommonFileDescriptorMetaDataModel._internal(
      claseCpbte: claseCpbte,
      nroCpbte: nroCpbte,
      tipoCliente: tipoCliente,
      codClie: codClie,
      fromType: fromType,
    );
  }

  factory CommonFileDescriptorMetaDataModel.fromJson(Map<String, dynamic> map) {
    const functionName = "fromJson";
    var orig = CommonFileDescriptorMetaDataModel.fromDefault();

    if (map["ClaseCpbte"] is! String) {
      throw ErrorHandler(
        errorCode: 9803,
        errorDsc: '''El campo `ClaseCpbte` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["ClaseCpbte"].runtimeType}]''',
        propertyName: "ClaseCpbte",
        propertyValue: map["ClaseCpbte"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.claseCpbte = map["ClaseCpbte"];

    if (int.tryParse(map["NroCpbte"].toString()) == null) {
      throw ErrorHandler(
        errorCode: 9800,
        errorDsc: '''El campo `NroCpbte` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["NroCpbte"].runtimeType}]''',
        propertyName: "NroCpbte",
        propertyValue: map["NroCpbte"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.nroCpbte = int.parse(map["NroCpbte"].toString());

    if (map["TipoCliente"] is! String) {
      throw ErrorHandler(
        errorCode: 9807,
        errorDsc: '''El campo `TipoCliente` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["TipoCliente"].runtimeType}]''',
        propertyName: "TipoCliente",
        propertyValue: map["TipoCliente"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.tipoCliente = map["TipoCliente"];

    if (int.tryParse(map["CodClie"].toString()) == null) {
      throw ErrorHandler(
        errorCode: 9801,
        errorDsc: '''El campo `CodClie` es inválido.
        Esperábamos un tipo de datos [int] y recibimos [${map["CodClie"].runtimeType}]''',
        propertyName: "CodClie",
        propertyValue: map["CodClie"],
        functionName: functionName,
        className: className,
        stacktrace: StackTrace.current,
      );
    }
    orig.codClie = int.parse(map["CodClie"].toString());

    orig.fromType = "Json";
    return orig;
  }

  Map<String, dynamic> toMap() {
    return {
      "ClaseCpbte": claseCpbte,
      "NroCpbte": nroCpbte,
      "TipoCliente": tipoCliente,
      "CodClie": codClie,
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

    if (other is! CommonFileDescriptorMetaDataModel) return false;

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
