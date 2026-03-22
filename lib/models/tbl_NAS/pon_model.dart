import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/model.dart';

class PONModel implements CommonParamKeyValueCapable {
  TableNASModel nasID;
  String gponString = "GPON";
  int slot;
  int id;
  String name = "";
  String description;

  PONModel._internal({
    required this.nasID,
    required this.slot,
    required this.id,
    required this.description,
  }) {
    name = "$gponString$slot/$id";
  }

  factory PONModel.fromJson({
    required Map<String, dynamic> map,
  }) {
    var nasID = map['NASID'];
    TableNASModel nas = TableNASModel.fromKey(
      id: nasID,
      nasName: map['NASName'] ?? "",
      shortName: map['NASShortName'] ?? "",
      pEmpresa: TableEmpresaModel.fromDefault(),
    );
    var slot = map['Slot'] ?? 0;
    var port = map['Port'] ?? 0;
    var name = map['Name'] ?? "";
    return PONModel._internal(
      nasID: nas,
      slot: slot,
      id: port,
      description: name,
    );
  }

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownItemAsString => description;

  @override
  String get dropDownKey => id.toString();

  @override
  String get dropDownSubTitle => description;

  @override
  String get dropDownTitle => description;

  @override
  String get dropDownValue => description;

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({required String searchText}) {
    throw UnimplementedError();
  }

  @override
  CommonParamKeyValueCapable fromDefault() {
    throw UnimplementedError();
  }

  factory PONModel.fromDefault({
    required TableNASModel pNASId,
  }) {
    var slot = -1;
    var id = -1;
    var description = "PON por defecto";
    return PONModel._internal(
      nasID: pNASId,
      slot: slot,
      id: id,
      description: description,
    );
  }
  factory PONModel.fromSelectRecord({
    required TableNASModel pNASId,
  }) {
    var rObject = PONModel.fromDefault(
      pNASId: pNASId,
    );
    rObject.slot = 0; // Default slot for new records
    rObject.id = 0; // Default ID for new records
    rObject.description = 'SELECIONE UN PON';

    return rObject;
  }

  factory PONModel.fromKey({
    required TableNASModel pNASId,
    required int slot,
    required int id,
    String description = "",
  }) {
    var description = "PON desde KEY: $slot/$id";

    return PONModel._internal(
      nasID: pNASId,
      slot: slot,
      id: id,
      description: description,
    );
  }
  factory PONModel.fromError({
    required TableNASModel pNASId,
    required String pFilter,
  }) {
    var rObject = PONModel.fromDefault(
      pNASId: pNASId,
    );
    rObject.slot = -2;
    rObject.id = -2;
    rObject.name = "Error recibido";
    return rObject;
  }

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => "DESACTIVADO";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! PONModel) return false;

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

  Map<String, dynamic> toMap() {
    return {
      'nasID': nasID.toMap(),
      'gponString': gponString,
      'slot': slot,
      'id': id,
      'name': name,
      'description': description,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'NASID': nasID.toJson(),
      'GPONString': gponString,
      'Slot': slot,
      'ID': id,
      'Name': name,
      'Description': description,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
