import 'dart:io';

void main(List<String> args) async {
  final target = args.isNotEmpty ? args[0].toLowerCase() : 'all';

  final versionFile = File('lib/config/version.dart');
  final versionFileContent = await versionFile.readAsString();

  final pubspecFile = File('pubspec.yaml');
  final content = await pubspecFile.readAsString();

  const String cCodeName = "gorrión";

  final vMajorRegExp = RegExp(r'const\s+int\s+vMajor\s*=\s*(\d+);');
  final vMinorRegExp = RegExp(r'const\s+int\s+vMinor\s*=\s*(\d+);');
  final vPatchRegExp = RegExp(r'const\s+int\s+vPatch\s*=\s*(\d+);');
  final vBuildRegExp = RegExp(r'const\s+int\s+vBuild\s*=\s*(\d+);');
  final vCodeNameRegExp =
      RegExp(r'const\s+String\s+vCodeName\s*=\s*"([^"]+)";');

  final vMajorMatch = vMajorRegExp.firstMatch(versionFileContent);
  final vMinorMatch = vMinorRegExp.firstMatch(versionFileContent);
  final vPatchMatch = vPatchRegExp.firstMatch(versionFileContent);
  final vBuildMatch = vBuildRegExp.firstMatch(versionFileContent);
  final vCodeNameMatch = vCodeNameRegExp.firstMatch(versionFileContent);

  if ([vMajorMatch, vMinorMatch, vPatchMatch, vBuildMatch, vCodeNameMatch]
      .contains(null)) {
    print('❌ No se pudieron encontrar las versiones en version.dart');
    return;
  }

  final versionRegExp = RegExp(r'version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)');
  final versionMSIXRegExp =
      RegExp(r'msix_version:\s*(\d+)\.(\d+)\.(\d+)\.(\d+)');

  final match = versionRegExp.firstMatch(content);
  if (match == null) {
    print('❌ No se encontró el campo version: en pubspec.yaml');
    return;
  }

  final major = int.parse(match.group(1)!);
  final minor = int.parse(match.group(2)!);
  final patch = int.parse(match.group(3)!);
  final build = int.parse(match.group(4)!) + 1;

  final newVersionLine = 'version: $major.$minor.$patch+$build';
  final newMSIXLine = 'msix_version: $major.$minor.$patch.$build';

  final newVMajor = 'const int vMajor = $major;';
  final newVMinor = 'const int vMinor = $minor;';
  final newVPatch = 'const int vPatch = $patch;';
  final newVBuild = 'const int vBuild = $build;';
  final newVCodeName = 'const String vCodeName = "$cCodeName";';

  // Actualizar pubspec.yaml
  String newPubspecContent = content.replaceAll(versionRegExp, newVersionLine);
  if (target == 'desktop' || target == 'all') {
    newPubspecContent =
        newPubspecContent.replaceAll(versionMSIXRegExp, newMSIXLine);
  }
  await pubspecFile.writeAsString(newPubspecContent);

  // Actualizar version.dart
  String newVersionFileContent = versionFileContent
      .replaceAll(vMajorRegExp, newVMajor)
      .replaceAll(vMinorRegExp, newVMinor)
      .replaceAll(vPatchRegExp, newVPatch)
      .replaceAll(vBuildRegExp, newVBuild)
      .replaceAll(vCodeNameRegExp, newVCodeName);

  await versionFile.writeAsString(newVersionFileContent);

  print(
      '✅ Versión actualizada a $major.$minor.$patch+$build para destino: $target');
}
