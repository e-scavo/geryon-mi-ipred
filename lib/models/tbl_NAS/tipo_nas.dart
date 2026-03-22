import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

enum TipoNASModel implements CommonParamKeyValueCapable {
  olt(
    'OLT',
    'OLT',
    'OLT (Optical Line Terminal)',
  ),
  nas(
    'NAS',
    'NAS',
    'NAS (Network Authentication Service)',
  ),
  unknown(
    'Unknown',
    'Desconocido',
    'Desconocido',
  );

  final String key;
  final String value;
  final String description;

  const TipoNASModel(
    this.key,
    this.value,
    this.description,
  );

  /// Devuelve un Map desde el `key` al enum
  static final Map<String, TipoNASModel> mapByKey = {
    for (var tipo in TipoNASModel.values) tipo.key: tipo,
  };

  /// Devuelve el enum correspondiente al key o `unknown` si no lo encuentra
  static TipoNASModel fromKey(String? key) {
    if (key == null) return TipoNASModel.unknown;
    return mapByKey[key] ?? TipoNASModel.unknown;
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
