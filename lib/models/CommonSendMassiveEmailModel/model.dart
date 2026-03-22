import 'package:geryon_web_app_ws_v2/models/CommonDateModel/common_date_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonNumbersModel/number_model.dart';

class CommonSendMassiveEmailModel {
  int codEmp;
  int nroCpbte;
  String tipoCliente;
  int codClie;
  String razonSocial;
  int mailSentCount;
  CommonDateModel mailSentLastTime;
  CommonNumbersModel saldoActual;
  CommonDateModel periodoFacturacion;
  String tipoFacturacion;
  String tipoRegistracion;

  CommonSendMassiveEmailModel._internal({
    required this.codEmp,
    required this.nroCpbte,
    required this.tipoCliente,
    required this.codClie,
    required this.razonSocial,
    required this.mailSentCount,
    required this.mailSentLastTime,
    required this.saldoActual,
    required this.periodoFacturacion,
    required this.tipoFacturacion,
    required this.tipoRegistracion,
  });

  factory CommonSendMassiveEmailModel.fromMap(Map<String, dynamic> map) {
    int codEmp = -1;
    if (map["CodEmp"] != null) {
      codEmp = map["CodEmp"];
    }
    int nroCpbte = -1;
    if (map["NroCpbte"] != null) {
      nroCpbte = map["NroCpbte"];
    }
    String tipoCliente = "";
    if (map["TipoCliente"] != null) {
      tipoCliente = map["TipoCliente"];
    }
    int codClie = -1;
    if (map["CodClie"] != null) {
      codClie = map["CodClie"];
    }
    String razonSocial = "";
    if (map["RazonSocial"] != null) {
      razonSocial = map["RazonSocial"];
    }
    int mailSentCount = -1;
    if (map["MailSentCount"] != null) {
      mailSentCount = map["MailSentCount"];
    }
    CommonDateModel mailSentLastTime = CommonDateModel.fromNow();
    if (map["MailSentLastTime"] != null) {
      mailSentLastTime = CommonDateModel.parse(map["MailSentLastTime"]);
    }
    CommonNumbersModel saldoActual = CommonNumbersModel.newNumbers();
    if (map["SaldoActual"] != null) {
      //saldoActual = CommonNumbersModel.parseFromMap(map["SaldoActual"]).data;
      saldoActual = CommonNumbersModel.tryParse(map["SaldoActual"]).data;
    }
    CommonDateModel periodoFacturacion = CommonDateModel.fromNow();
    String tipoFacturacion = "";
    String tipoRegistracion = "";
    return CommonSendMassiveEmailModel._internal(
      codEmp: codEmp,
      nroCpbte: nroCpbte,
      tipoCliente: tipoCliente,
      codClie: codClie,
      razonSocial: razonSocial,
      mailSentCount: mailSentCount,
      mailSentLastTime: mailSentLastTime,
      saldoActual: saldoActual,
      periodoFacturacion: periodoFacturacion,
      tipoFacturacion: tipoFacturacion,
      tipoRegistracion: tipoRegistracion,
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "CodEmp": codEmp,
      "NroCpbte": nroCpbte,
      "TipoCliente": tipoCliente,
      "CodClie": codClie,
      "RazonSocial": razonSocial,
      "MailSentCount": mailSentCount,
      "MailSentLastTime": mailSentLastTime,
      "SaldoActual": saldoActual,
    };
  }
}
