import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

class CommmonParamKeyValueGeneric<T> implements CommonParamKeyValueCapable {
  final T key;
  final String value;
  final String description;

  const CommmonParamKeyValueGeneric(
    this.key,
    this.value,
    this.description,
  );

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownItemAsString => description;

  @override
  String get dropDownKey => key.toString();

  @override
  String get dropDownSubTitle => description;

  @override
  String get dropDownTitle => description;

  @override
  String get dropDownValue => key.toString();

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({required String searchText}) {
    throw UnimplementedError();
  }

  @override
  CommonParamKeyValueCapable fromDefault() {
    return CommmonParamKeyValueGeneric(
      "default_key",
      "default_value",
      "Descripción por defecto",
    );
  }

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => "DESACTIVADO";
}
