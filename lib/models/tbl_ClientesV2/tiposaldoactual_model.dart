import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

enum TipoSaldoActualModel implements CommonParamKeyValueCapable {
  todos(
    'Todos',
    'Todos',
    'Todos los tipos de saldo actual',
  ),
  mayor(
    'Mayor',
    'Mayor a',
    'Mayor al saldo ...',
  ),
  menor(
    'Menor',
    'Menor a',
    'Menor al saldo ...',
  ),
  igual(
    'Igual',
    'Igual a',
    'Igual al saldo ...',
  ),
  diferente(
    'Diferente',
    'Diferente a',
    'Diferente al saldo ...',
  ),
  mayorIgual(
    'MayorIgual',
    'Mayor o igual a',
    'Mayor o igual al saldo ...',
  ),
  menorIgual(
    'MenorIgual',
    'Menor o igual a',
    'Menor o igual al saldo ...',
  ),
  unknown(
    'Unknown',
    'Desconocido',
    'Desconocido',
  );

  final String key;
  final String value;
  final String description;

  const TipoSaldoActualModel(
    this.key,
    this.value,
    this.description,
  );

  /// Devuelve un Map desde el `key` al enum
  static final Map<String, TipoSaldoActualModel> mapByKey = {
    for (var tipo in TipoSaldoActualModel.values) tipo.key: tipo,
  };

  /// Devuelve un Map desde el `value` al enum
  static final Map<String, TipoSaldoActualModel> mapByValue = {
    for (var tipo in TipoSaldoActualModel.values) tipo.value: tipo,
  };

  /// Devuelve el enum correspondiente al key o `unknown` si no lo encuentra
  static TipoSaldoActualModel fromKey(String? key) {
    if (key == null) return TipoSaldoActualModel.unknown;
    return mapByKey[key] ?? TipoSaldoActualModel.unknown;
  }

  /// Devuelve el enum correspondiente al value o `unknown` si no lo encuentra
  static TipoSaldoActualModel fromValue(String? value) {
    if (value == null) return TipoSaldoActualModel.unknown;
    return mapByValue[value] ?? TipoSaldoActualModel.unknown;
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
