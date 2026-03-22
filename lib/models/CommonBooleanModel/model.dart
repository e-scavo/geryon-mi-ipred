import 'dart:developer' as developer;

import 'package:xml/xml.dart';

// Response class to encapsulate the response structure
class Response {
  int errorCode;
  String errorDsc;
  int errorCodeRaw;
  String errorDscRaw;
  CommonBooleanModel data;

  Response({
    required this.errorCode,
    required this.errorDsc,
    required this.errorCodeRaw,
    required this.errorDscRaw,
    required this.data,
  });
}

// CommonBooleanModel class to encapsulate CommonBooleanModel manipulation
class CommonBooleanModel {
  static const String className = 'CommonBooleanModel';
  bool value;
  String fieldName;
  bool isNull;
  Marshaller xmlMarshaller;
  Marshaller jsonMarshaller;
  Marshaller mapStructureMarshaller;

  CommonBooleanModel({
    required this.value,
    required this.fieldName,
    required this.isNull,
    Marshaller? xmlMarshaller,
    Marshaller? jsonMarshaller,
    Marshaller? mapStructureMarshaller,
  })  : xmlMarshaller = xmlMarshaller ?? Marshaller(),
        jsonMarshaller = jsonMarshaller ?? Marshaller(),
        mapStructureMarshaller = mapStructureMarshaller ?? Marshaller();

  @override
  String toString() {
    return asString();
  }

  // AsMySQLValue returns the CommonBooleanModel as a MySQL-compatible integer (1 or 0)
  int asMySQLValue() {
    return value ? 1 : 0;
  }

  // AsString returns the CommonBooleanModel as "true" or "false"
  String asString() {
    return value ? "true" : "false";
  }

  // AsStringSINO returns the CommonBooleanModel as "SI" or "NO"
  String asStringSINO() {
    return value ? "SI" : "NO";
  }

  // AsBool returns the CommonBooleanModel as true or false
  bool asBool() {
    return value;
  }

  // Equals returns true if this CommonBooleanModel is equal to another
  bool equals(CommonBooleanModel n) {
    return value == n.value;
  }

  // Get returns the CommonBooleanModel value
  bool getValue() {
    return value;
  }

  // Set assigns a new value to the CommonBooleanModel
  void setValue(bool b) {
    value = b;
  }

  // Custom JSON serialization
  Map<String, dynamic> toJson() {
    //return {'encoded_value': "Prefix_${asString()}"};
    /*
      Marshaller xmlMarshaller;
  Marshaller jsonMarshaller;
  Marshaller mapStructureMarshaller;

    */
    return {
      'Value': value,
      'FieldName': fieldName,
      'IsNull': isNull,
      'XMLMarshaller': xmlMarshaller,
      'JSONMarshaller': jsonMarshaller,
      'MapStructureMarshaller': mapStructureMarshaller,
    };
  }

  // Custom JSON deserialization
  factory CommonBooleanModel.fromJson(Map<String, dynamic> json) {
    String encodedValue = json['encoded_value'] ?? '';
    return CommonBooleanModel(
      value: parse(encodedValue.replaceFirst('Prefix_', '')).data.value,
      fieldName: '',
      isNull: false,
    );
  }

  // Custom XML serialization
  String toXml() {
    final builder = XmlBuilder();
    builder.element('CommonBooleanModel', nest: asString());
    return builder.buildDocument().toXmlString();
  }

  // Custom XML deserialization
  factory CommonBooleanModel.fromXml(String xml) {
    final document = XmlDocument.parse(xml);
    final content = document.rootElement.text;
    return parse(content).data;
  }

  // Parse a string into a CommonBooleanModel instance and Response
  static Response parse(
    dynamic b, {
    String fieldName = "",
  }) {
    const String functionName = 'parse';
    if (b.runtimeType == bool) {
      return Response(
        errorCode: 0,
        errorDsc: '',
        errorCodeRaw: 0,
        errorDscRaw: '',
        data: CommonBooleanModel(
          value: b,
          fieldName: fieldName,
          isNull: false,
        ),
      );
    }
    if (b is CommonBooleanModel) {
      return Response(
        errorCode: 0,
        errorDsc: '',
        errorCodeRaw: 0,
        errorDscRaw: '',
        data: CommonBooleanModel(
          value: b.value,
          fieldName: b.fieldName,
          isNull: b.isNull,
        ),
      );
    }
    developer
        .log('$className - $functionName - [fieldName]:$fieldName - [data]:$b');
    developer.log(
        '$className - $functionName - [fieldName]:$fieldName - [data]:${b.runtimeType}');
    if (b is List<dynamic>) {
      return Response(
        errorCode: 0,
        errorDsc: '',
        errorCodeRaw: 0,
        errorDscRaw: '',
        data: CommonBooleanModel(
          value: false,
          fieldName: fieldName,
          isNull: true,
        ),
      );
    }
    b = b.trim().toLowerCase();

    if (arrayOfTRUEs.contains(b)) {
      return Response(
        errorCode: 0,
        errorDsc: '',
        errorCodeRaw: 0,
        errorDscRaw: '',
        data: CommonBooleanModel(
          value: true,
          fieldName: fieldName,
          isNull: false,
        ),
      );
    } else if (arrayOfFALSEs.contains(b)) {
      return Response(
        errorCode: 0,
        errorDsc: '',
        errorCodeRaw: 0,
        errorDscRaw: '',
        data: CommonBooleanModel(
          value: false,
          fieldName: fieldName,
          isNull: false,
        ),
      );
    } else {
      return Response(
        errorCode: 100,
        errorDsc: 'Could not determine the value [$b] as a CommonBooleanModel.',
        errorCodeRaw: 0,
        errorDscRaw: '',
        data: CommonBooleanModel(
          value: false,
          fieldName: fieldName,
          isNull: false,
        ),
      );
    }
  }

  // Factory method to create a new CommonBooleanModel instance with default value
  static CommonBooleanModel newBoolean() {
    return parse("false").data;
  }

  static CommonBooleanModel newFalse() {
    return parse("false").data;
  }

  static CommonBooleanModel newTrue() {
    return parse("true").data;
  }
}

// Marshaller class to encapsulate formatting details
class Marshaller {
  String format;

  Marshaller({this.format = ''});

  Map<String, dynamic> toJson() {
    return {
      "Format": format,
    };
  }
}

const List<String> arrayOfTRUEs = ['1', 'true', 't', 'yes', 'si'];
const List<String> arrayOfFALSEs = ['0', 'false', 'f', 'no', '', 'null'];
