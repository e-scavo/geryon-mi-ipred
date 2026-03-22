import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/pon_model.dart';

class ONUModel implements CommonParamKeyValueCapable {
  TableNASModel nasID;
  PONModel ponID;
  int index;
  String adminState;
  String omccState;
  String phaseState;
  String serialNumber;
  String ip;
  String mac;
  String model;
  String profile;
  String profileName;
  String profileType;
  String profileTypeName;
  String profileTypeDescription;

  ONUModel._internal({
    required this.nasID,
    required this.ponID,
    required this.index,
    required this.adminState,
    required this.omccState,
    required this.phaseState,
    required this.serialNumber,
    required this.ip,
    required this.mac,
    required this.model,
    required this.profile,
    required this.profileName,
    required this.profileType,
    required this.profileTypeName,
    required this.profileTypeDescription,
  });

  factory ONUModel.fromJson({
    required Map<String, dynamic> map,
  }) {
    var nasID = map['NASID'];
    TableNASModel nas = TableNASModel.fromKey(
      id: nasID,
      nasName: map['NASName'] ?? "",
      shortName: map['NASShortName'] ?? "",
      pEmpresa: TableEmpresaModel.fromDefault(),
    );
    var ponID = PONModel.fromJson(map: map);
    var index = map['Index'] ?? 0;
    var adminState = map['AdminState'] ?? "Desconocido";
    var omccState = map['OMCCState'] ?? "Desconocido";
    var phaseState = map['PhaseState'] ?? "Desconocido";
    var serialNumber = map['SerialNumber'] ?? "Desconocido";
    var ip = map['IP'] ?? "";
    var mac = map['MAC'] ?? "00:00:00:00:00";
    var model = map['Model'] ?? "Desconocido";
    var profile = map['Profile'] ?? "Desconocido";
    var profileName = map['ProfileName'] ?? "Desconocido";
    var profileType = map['ProfileType'] ?? "Desconocido";
    var profileTypeName = map['ProfileTypeName'] ?? "Desconocido";
    var profileTypeDescription = map['ProfileTypeDescription'] ?? "Desconocido";

    return ONUModel._internal(
      nasID: nas,
      ponID: ponID,
      index: index,
      adminState: adminState,
      omccState: omccState,
      phaseState: phaseState,
      serialNumber: serialNumber,
      ip: ip,
      mac: mac,
      model: model,
      profile: profile,
      profileName: profileName,
      profileType: profileType,
      profileTypeName: profileTypeName,
      profileTypeDescription: profileTypeDescription,
    );
  }

  @override
  String get dropDownAvatar => "";

  @override
  String get dropDownItemAsString => "1-";

  @override
  String get dropDownKey => index.toString();

  @override
  String get dropDownSubTitle {
    var serial = serialNumber.isNotEmpty ? 'SN: $serialNumber' : 'No Serial';
    return serial;
  }

  @override
  String get dropDownTitle {
    // This is a placeholder for the title, you can customize it as needed
    // For example, you might want to return the serial number or model
    var idx = 'ID: ${index.toString().padLeft(3, '0')}';
    return idx;
  }

  @override
  String get dropDownValue {
    switch (index) {
      case -1:
        return "Error: No se pudo cargar el PON";
      case -2:
        return "Error: No se pudo cargar el PON";
      case 0:
        return "SELECCIONE UNA ONU";

      default:
        return "ONU $index";
    }
  }

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({required String searchText}) {
    throw UnimplementedError();
  }

  @override
  CommonParamKeyValueCapable fromDefault() {
    throw UnimplementedError();
  }

  factory ONUModel.fromDefault({
    required PONModel pPONId,
  }) {
    var nasID = pPONId.nasID;
    var ponID = pPONId;
    var index = 0;
    var adminState = "Desconocido";
    var omccState = "Desconocido";
    var phaseState = "Desconocido";
    var serialNumber = "Desconocido";
    var ip = "";
    var mac = "00:00:00:00:00";
    var model = "Desconocido";
    var profile = "Desconocido";
    var profileName = "Desconocido";
    var profileType = "Desconocido";
    var profileTypeName = "Desconocido";
    var profileTypeDescription = "Desconocido";
    return ONUModel._internal(
      nasID: nasID,
      ponID: ponID,
      index: index,
      adminState: adminState,
      omccState: omccState,
      phaseState: phaseState,
      serialNumber: serialNumber,
      ip: ip,
      mac: mac,
      model: model,
      profile: profile,
      profileName: profileName,
      profileType: profileType,
      profileTypeName: profileTypeName,
      profileTypeDescription: profileTypeDescription,
    );
  }
  factory ONUModel.fromSelectRecord({
    required PONModel pPONId,
  }) {
    var rObject = ONUModel.fromDefault(
      pPONId: pPONId,
    );
    return rObject;
  }
  factory ONUModel.fromKey({
    required PONModel pPONId,
    required int pIndex,
  }) {
    var nasID = pPONId.nasID;
    var ponID = pPONId;
    var index = pIndex;
    var adminState = "Desconocido";
    var omccState = "Desconocido";
    var phaseState = "Desconocido";
    var serialNumber = "Desconocido";
    var ip = "";
    var mac = "00:00:00:00:00";
    var model = "Desconocido";
    var profile = "Desconocido";
    var profileName = "Desconocido";
    var profileType = "Desconocido";
    var profileTypeName = "Desconocido";
    var profileTypeDescription = "Desconocido";
    return ONUModel._internal(
      nasID: nasID,
      ponID: ponID,
      index: index,
      adminState: adminState,
      omccState: omccState,
      phaseState: phaseState,
      serialNumber: serialNumber,
      ip: ip,
      mac: mac,
      model: model,
      profile: profile,
      profileName: profileName,
      profileType: profileType,
      profileTypeName: profileTypeName,
      profileTypeDescription: profileTypeDescription,
    );
  }
  factory ONUModel.fromError({
    required PONModel pPONId,
    required String pFilter,
  }) {
    var rObject = ONUModel.fromDefault(
      pPONId: pPONId,
    );
    rObject.index = -2;
    return rObject;
  }

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => "DESACTIVADO";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! ONUModel) return false;

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
      'nasID': nasID,
      'ponID': ponID,
      'index': index,
      'adminState': adminState,
      'omccState': omccState,
      'phaseState': phaseState,
      'serialNumber': serialNumber,
      'ip': ip,
      'mac': mac,
      'model': model,
      'profile': profile,
      'profileName': profileName,
      'profileType': profileType,
      'profileTypeName': profileTypeName,
      'profileTypeDescription': profileTypeDescription,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'NASID': nasID,
      'PONID': ponID,
      'Index': index,
      'AdminState': adminState,
      'OMCCState': omccState,
      'PhaseState': phaseState,
      'SerialNumber': serialNumber,
      'IP': ip,
      'MAC': mac,
      'Model': model,
      'Profile': profile,
      'ProfileName': profileName,
      'ProfileType': profileType,
      'ProfileTypeName': profileTypeName,
      'ProfileTypeDescription': profileTypeDescription,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
