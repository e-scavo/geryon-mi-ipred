import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

enum TipoInstalacionModel implements CommonParamKeyValueCapable {
  ftth(
    'FTTH',
    'FTTH',
    'Fiber to the Home (FTTH)',
  ),
  fttb(
    'FTTB',
    'FTTB',
    'Fiber to the Building (FTTB)',
  ),
  wireless(
    'WIRELESS',
    'WIRELESS',
    'Wireless',
  ),
  unknown(
    'Unknown',
    'Desconocido',
    'Desconocido',
  );

  final String key;
  final String value;
  final String description;

  const TipoInstalacionModel(
    this.key,
    this.value,
    this.description,
  );

  /// Devuelve un Map desde el `key` al enum
  static final Map<String, TipoInstalacionModel> mapByKey = {
    for (var tipo in TipoInstalacionModel.values) tipo.key: tipo,
  };

  /// Devuelve el enum correspondiente al key o `unknown` si no lo encuentra
  static TipoInstalacionModel fromKey(String? key) {
    if (key == null) return TipoInstalacionModel.unknown;
    return mapByKey[key] ?? TipoInstalacionModel.unknown;
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
