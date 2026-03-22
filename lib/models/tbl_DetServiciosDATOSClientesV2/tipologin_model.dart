import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

enum TipoLoginModel implements CommonParamKeyValueCapable {
  pppoe(
    'PPPoE',
    'PPPoE',
    'Protocolo de Punto a Punto sobre Ethernet',
  ),
  dhcp(
    'DHCP',
    'DHCP',
    'Protocolo de Configuración Dinámica de Host',
  ),
  unknown(
    'Unknown',
    'Desconocido',
    'Desconocido',
  );

  final String key;
  final String value;
  final String description;

  const TipoLoginModel(
    this.key,
    this.value,
    this.description,
  );

  /// Devuelve un Map desde el `key` al enum
  static final Map<String, TipoLoginModel> mapByKey = {
    for (var tipo in TipoLoginModel.values) tipo.key: tipo,
  };

  /// Devuelve un Map desde el `value` al enum
  static final Map<String, TipoLoginModel> mapByValue = {
    for (var tipo in TipoLoginModel.values) tipo.value: tipo,
  };

  /// Devuelve el enum correspondiente al key o `unknown` si no lo encuentra
  static TipoLoginModel fromKey(String? key) {
    if (key == null) return TipoLoginModel.unknown;
    return mapByKey[key] ?? TipoLoginModel.unknown;
  }

  /// Devuelve el enum correspondiente al value o `unknown` si no lo encuentra
  static TipoLoginModel fromValue(String? value) {
    if (value == null) return TipoLoginModel.unknown;
    return mapByValue[value] ?? TipoLoginModel.unknown;
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
