import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';

class AdditionalParams {
  String actionRequest;
  CommonDateModel periodoFacturacion;
  CommonDateModel fechaEnvioMails;
  CommonDateModel periodoInstalaciones;
  String tipoFacturacion;
  String tipoRegistracion;
  int codEmp;
  String tipoCliente;
  int codClie;
  int nroCpbte;
  CommonDateModel? fromDate;
  CommonDateModel? toDate;

  AdditionalParams({
    required this.actionRequest,
    required this.periodoFacturacion,
    required this.fechaEnvioMails,
    required this.periodoInstalaciones,
    required this.tipoFacturacion,
    required this.tipoRegistracion,
    required this.codEmp,
    required this.tipoCliente,
    required this.codClie,
    required this.nroCpbte,
    this.fromDate,
    this.toDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "ActionRequest": actionRequest,
      "PeriodoFacturacion": periodoFacturacion,
      "FechaEnvioMails": fechaEnvioMails,
      'PeriodoInstalaciones': periodoInstalaciones,
      "TipoFacturacion": tipoFacturacion,
      "TipoRegistracion": tipoRegistracion,
      "CodEmp": codEmp,
      "TipoCliente": tipoCliente,
      "CodClie": codClie,
      "NroCpbte": nroCpbte,
      "FromDate": fromDate,
      "ToDate": toDate,
    };
  }

  fromMap(Map<String, dynamic> map) {
    actionRequest = map["ActionRequest"];
    periodoFacturacion = CommonDateModel.fromString(map["ActionRequest"]);
    fechaEnvioMails = CommonDateModel.fromString(map["FechaEnvioMails"]);
    periodoInstalaciones =
        CommonDateModel.fromString(map["PeriodoInstalaciones"]);
    tipoFacturacion = map["TipoFacturacion"];
    tipoRegistracion = map["TipoRegistracion"];
    codEmp = map["CodEmp"];
    tipoCliente = map["TipoCliente"];
    codClie = map["CodClie"];
    nroCpbte = map["NroCpbte"];
    fromDate = map["FromDate"] == null
        ? null
        : CommonDateModel.fromString(map["FromDate"]);
    toDate = map["ToDate"] == null
        ? null
        : CommonDateModel.fromString(map["ToDate"]);
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
