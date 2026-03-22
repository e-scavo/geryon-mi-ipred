import 'package:geryon_web_app_ws_v2/config/version.dart';

class AppVersionModel {
  final int vMajor;
  final int vMinor;
  final int vPatch;
  final int vBuild;
  final String vCodeName;
  final String type;
  late final String sFullVersion;

  AppVersionModel({
    required this.vMajor,
    required this.vMinor,
    required this.vPatch,
    required this.vBuild,
    required this.vCodeName,
    required this.type,
  }) {
    sFullVersion = 'v$vMajor.$vMinor.$vPatch-$vBuild ($vCodeName)';
  }

  factory AppVersionModel.fromMap(Map<String, dynamic> map) {
    var vMajor = map['vMajor'] ?? -1;
    var vMinor = map['vMinor'] ?? -1;
    var vPatch = map['vPatch'] ?? -1;
    var vBuild = map['vBuild'] ?? -1;
    var type = map['Type'] ?? 'Unknown';
    var vCodeName = map['vCodeName'] ?? 'Unknown';
    return AppVersionModel(
      vMajor: vMajor,
      vMinor: vMinor,
      vPatch: vPatch,
      vBuild: vBuild,
      vCodeName: vCodeName,
      type: type,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'vMajor': vMajor,
      'vMinor': vMinor,
      'vPatch': vPatch,
      'vBuild': vBuild,
      'vCodeName': vCodeName,
      'type': type,
      'sFullVersion': sFullVersion,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! AppVersionModel) return false;

    Map<String, dynamic> thisMap = toMap();
    Map<String, dynamic> otherMap = other.toMap();

    for (String key in thisMap.keys) {
      if (thisMap[key].runtimeType != otherMap[key].runtimeType) {
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
}

AppVersionModel gAppVersion = AppVersionModel(
  vMajor: vMajor,
  vMinor: vMinor,
  vPatch: vPatch,
  vBuild: vBuild,
  vCodeName: vCodeName,
  type: 'web',
);
