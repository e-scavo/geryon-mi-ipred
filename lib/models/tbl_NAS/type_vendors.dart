import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

enum VendorTypeModel implements CommonParamKeyValueCapable {
  mikrotik(
    'mikrotik',
    'Mikrotik',
    'Router Mikrotik',
  ),
  vsol(
    'vsol',
    'V-Solution',
    'OLT V-Solution',
  ),
  unknown(
    'Unknown',
    'Desconocido',
    'Desconocido',
  );

  final String key;
  final String value;
  final String description;

  const VendorTypeModel(
    this.key,
    this.value,
    this.description,
  );

  /// Devuelve un Map desde el `key` al enum
  static final Map<String, VendorTypeModel> mapByKey = {
    for (var tipo in VendorTypeModel.values) tipo.key: tipo,
  };

  /// Devuelve el enum correspondiente al key o `unknown` si no lo encuentra
  static VendorTypeModel fromKey(String? key) {
    if (key == null) return VendorTypeModel.unknown;
    return mapByKey[key] ?? VendorTypeModel.unknown;
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
