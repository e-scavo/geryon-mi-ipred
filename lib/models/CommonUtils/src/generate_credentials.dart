part of '../common_utils.dart';

class UtilsCredentials {
  final String tipoLogin;
  final String username;
  final String password;
  final String wiFiSSID;
  final String wiFiPassword;

  UtilsCredentials({
    required this.tipoLogin,
    required this.username,
    required this.password,
    required this.wiFiSSID,
    required this.wiFiPassword,
  });
}

/// Returns the credentials for the specific key,value
///
UtilsCredentials generateCredentials({
  String tipoServicio = "HOGAR",
  required TableEmpresaModel pEmpresa,
  required TableClienteV2Model pCliente,
  required TablePaisModel pPais,
  required TableProvinciaModel pProvincia,
  required TableCiudadModel pCiudad,
  required TableDetBarrioCiudadModel pDetBarrioCiudad,
  required int pNroServicio,
}) {
  var tipoLogin = "PPPoE";
  var username = "c";
  username += pCliente.codClie.toString().padLeft(6, '0');
  username += '-';
  username += pNroServicio.toString();
  username += '@';
  username += pCiudad.descripcion.trim().replaceAll(" ", "").toLowerCase();
  //username += pEmpresa.razonSocialSoloTexto;
  username += '-';
  username += "ipred";
  var password = "ipred";
  //var wiFiSSID = pEmpresa.razonSocialSoloTexto.toUpperCase();
  var wiFiSSID = "IPRED";
  wiFiSSID += '-Fibra-Oprica-C';
  wiFiSSID += pCliente.codClie.toString().padLeft(6, '0');

  var wiFiPassword = "";
  var initPass = pCliente.nroDoc
      .trim()
      .replaceAll(" ", "")
      .replaceAll(".", "")
      .toLowerCase()
      .padLeft(8, '0');
  var q = initPass.length - 1;
  for (var i = q; i >= 0; i--) {
    wiFiPassword += initPass[i];
  }

  return UtilsCredentials(
    tipoLogin: tipoLogin,
    username: username,
    password: password,
    wiFiSSID: wiFiSSID,
    wiFiPassword: wiFiPassword,
  );
}
