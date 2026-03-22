const int vMajor = 1;
const int vMinor = 0;
const int vPatch = 0;
const int vBuild = 81;
const String vCodeName = "gorrión";
const String sFullVersion = 'v$vMajor.$vMinor.$vPatch-$vBuild ($vCodeName)';
const String sTitle = "GERYON Software";
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
