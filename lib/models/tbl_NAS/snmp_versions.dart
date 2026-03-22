import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

enum SNMPVersionsModel implements CommonParamKeyValueCapable {
  snmpV1(
    'SNMPv1',
    'SNMPv1',
    'Simple Network Management Protocol Version 1',
  ),
  snmpV2c(
    'SNMPv2c',
    'SNMPv2c',
    'Simple Network Management Protocol Version 2c',
  ),
  unknown(
    'Unknown',
    'Desconocido',
    'Desconocido',
  );

  final String key;
  final String value;
  final String description;

  const SNMPVersionsModel(
    this.key,
    this.value,
    this.description,
  );

  /// Devuelve un Map desde el `key` al enum
  static final Map<String, SNMPVersionsModel> mapByKey = {
    for (var tipo in SNMPVersionsModel.values) tipo.key: tipo,
  };

  /// Devuelve el enum correspondiente al key o `unknown` si no lo encuentra
  static SNMPVersionsModel fromKey(String? key) {
    if (key == null) return SNMPVersionsModel.unknown;
    return mapByKey[key] ?? SNMPVersionsModel.unknown;
  }

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownItemAsString => description;

  @override
  String get dropDownKey => key;

  @override
  String get dropDownSubTitle => description;

  @override
  String get dropDownTitle => description;

  @override
  String get dropDownValue => key;

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({required String searchText}) {
    throw UnimplementedError();
  }

  @override
  CommonParamKeyValueCapable fromDefault() {
    throw UnimplementedError();
  }

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => "DESACTIVADO";
}
