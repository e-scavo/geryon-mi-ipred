const int vMajor = 1;
const int vMinor = 0;
const int vPatch = 0;
const int vBuild = 86;
const String vCodeName = "gorrión";

const String sAppName = "Mi IP·RED";
const String sTechnicalPackageName = "geryon_web_app_ws_v2";

const String sFullVersion = 'v$vMajor.$vMinor.$vPatch-$vBuild ($vCodeName)';
const String sTitle = sAppName;
const String sWindowTitle = '$sTitle - $sFullVersion';
const String sVersion = '$vMajor.$vMinor.$vPatch-$vBuild ($vCodeName)';
const String sVersionWithTitle = '$sTitle - $sVersion';
const String sVersionWithTitleAndBuild = '$sTitle - $sVersion (Build: $vBuild)';
const String sVersionWithBuild = '$sVersion (Build: $vBuild)';
const String sVersionWithCodeName = '$sVersion ($vCodeName)';
const String sVersionWithCodeNameAndBuild =
    '$sVersion ($vCodeName) (Build: $vBuild)';
const String sVersionWithCodeNameAndTitle =
    '$sTitle - $sVersion ($vCodeName) (Build: $vBuild)';
