import 'package:geryon_web_app_ws_v2/models/CommonParamKeyValue/common_param_key_value.dart';

class TableEmpresaModel implements CommonParamKeyValueCapable {
  int codEmp;
  String razonSocial;
  String cuit;
  String cuitF;
  String domicilio;
  String nroPuerta;
  String piso;
  String depto;
  int codCdad;
  String descripcionCodCdad;
  String image;
  String telefono;
  String email;
  String website;
  String observaciones;
  int codPais;
  String descripcionCodPais;
  String iibb;
  String fechaInicioActividadesCLA;
  String fechaInicioActividadesSQL;
  String fechaInicioActividadesES;
  String fPagoBancoCredicoop;
  String fPagoBancoDineroMail;
  String fPagoBancoRapiPago;
  String fPagoBancoPagoFacil;
  String fPagoBancoCobroDigital;
  String generarUsuarioCon;
  String razonSocialSoloTexto;
  String codCatIVA;
  String descripcionCodCatIVA;
  int codPcia;
  String descripcionCodPcia;
  String environment;

  String fromType;

  TableEmpresaModel._internal({
    required this.codEmp,
    required this.razonSocial,
    required this.cuit,
    required this.cuitF,
    required this.domicilio,
    required this.nroPuerta,
    required this.piso,
    required this.depto,
    required this.codCdad,
    required this.descripcionCodCdad,
    required this.image,
    required this.telefono,
    required this.email,
    required this.website,
    required this.observaciones,
    required this.codPais,
    required this.descripcionCodPais,
    required this.iibb,
    required this.fechaInicioActividadesCLA,
    required this.fechaInicioActividadesSQL,
    required this.fechaInicioActividadesES,
    required this.fPagoBancoCredicoop,
    required this.fPagoBancoDineroMail,
    required this.fPagoBancoRapiPago,
    required this.fPagoBancoPagoFacil,
    required this.fPagoBancoCobroDigital,
    required this.generarUsuarioCon,
    required this.razonSocialSoloTexto,
    required this.codCatIVA,
    required this.descripcionCodCatIVA,
    required this.codPcia,
    required this.descripcionCodPcia,
    required this.environment,
    required this.fromType,
  });
  factory TableEmpresaModel.fromNormal({
    required int codEmp,
    required String razonSocial,
    required String cuit,
    required String cuitF,
    required String domicilio,
    required String nroPuerta,
    required String piso,
    required String depto,
    required int codCdad,
    required String descripcionCodCdad,
    required String image,
    required String telefono,
    required String email,
    required String website,
    required String observaciones,
    required int codPais,
    required String descripcionCodPais,
    required String iibb,
    required String fechaInicioActividadesCLA,
    required String fechaInicioActividadesSQL,
    required String fechaInicioActividadesES,
    required String fPagoBancoCredicoop,
    required String fPagoBancoDineroMail,
    required String fPagoBancoRapiPago,
    required String fPagoBancoPagoFacil,
    required String fPagoBancoCobroDigital,
    required String generarUsuarioCon,
    required String razonSocialSoloTexto,
    required String codCatIVA,
    required String descripcionCodCatIVA,
    required int codPcia,
    required String descripcionCodPcia,
    required String environment,
  }) {
    String fromType = 'fromNormal';
    return TableEmpresaModel._internal(
      codEmp: codEmp,
      razonSocial: razonSocial,
      cuit: cuit,
      cuitF: cuitF,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      image: image,
      telefono: telefono,
      email: email,
      website: website,
      observaciones: observaciones,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      iibb: iibb,
      fechaInicioActividadesCLA: fechaInicioActividadesCLA,
      fechaInicioActividadesSQL: fechaInicioActividadesSQL,
      fechaInicioActividadesES: fechaInicioActividadesES,
      fPagoBancoCredicoop: fPagoBancoCredicoop,
      fPagoBancoDineroMail: fPagoBancoDineroMail,
      fPagoBancoRapiPago: fPagoBancoRapiPago,
      fPagoBancoPagoFacil: fPagoBancoPagoFacil,
      fPagoBancoCobroDigital: fPagoBancoCobroDigital,
      generarUsuarioCon: generarUsuarioCon,
      razonSocialSoloTexto: razonSocialSoloTexto,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      codPcia: codPais,
      descripcionCodPcia: descripcionCodPcia,
      environment: environment,
      fromType: fromType,
    );
  }
  factory TableEmpresaModel.fromAll() {
    /// Change this!!
    const int codEmp = 1;
    const String razonSocial = "TODAS LAS EMPRESAS";
    const String cuit = "";
    const String cuitF = "";
    const String domicilio = "";
    const String nroPuerta = "";
    const String piso = "";
    const String depto = "";
    const int codCdad = -1;
    const String descripcionCodCdad = "";
    const String image = "";
    const String telefono = "";
    const String email = "";
    const String website = "";
    const String observaciones = "";
    const int codPais = -1;
    const String descripcionCodPais = "";
    const String iibb = "";
    const String fechaInicioActividadesCLA = "";
    const String fechaInicioActividadesSQL = "";
    const String fechaInicioActividadesES = "";
    const String fPagoBancoCredicoop = "";
    const String fPagoBancoDineroMail = "";
    const String fPagoBancoRapiPago = "";
    const String fPagoBancoPagoFacil = "";
    const String fPagoBancoCobroDigital = "";
    const String generarUsuarioCon = "";
    const String razonSocialSoloTexto = "";
    const String codCatIVA = "";
    const String descripcionCodCatIVA = "";
    const int codPcia = -1;
    const String descripcionCodPcia = "";
    const environment = "default";
    String fromType = 'fromAll';
    return TableEmpresaModel._internal(
      codEmp: codEmp,
      razonSocial: razonSocial,
      cuit: cuit,
      cuitF: cuitF,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      image: image,
      telefono: telefono,
      email: email,
      website: website,
      observaciones: observaciones,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      iibb: iibb,
      fechaInicioActividadesCLA: fechaInicioActividadesCLA,
      fechaInicioActividadesSQL: fechaInicioActividadesSQL,
      fechaInicioActividadesES: fechaInicioActividadesES,
      fPagoBancoCredicoop: fPagoBancoCredicoop,
      fPagoBancoDineroMail: fPagoBancoDineroMail,
      fPagoBancoRapiPago: fPagoBancoRapiPago,
      fPagoBancoPagoFacil: fPagoBancoPagoFacil,
      fPagoBancoCobroDigital: fPagoBancoCobroDigital,
      generarUsuarioCon: generarUsuarioCon,
      razonSocialSoloTexto: razonSocialSoloTexto,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      environment: environment,
      fromType: fromType,
    );
  }

  factory TableEmpresaModel.fromZero() {
    const int codEmp = 0;
    const String razonSocial = "SELECCIONE UNA EMPRESA";
    const String cuit = "";
    const String cuitF = "";
    const String domicilio = "";
    const String nroPuerta = "";
    const String piso = "";
    const String depto = "";
    const int codCdad = -1;
    const String descripcionCodCdad = "";
    const String image = "";
    const String telefono = "";
    const String email = "";
    const String website = "";
    const String observaciones = "";
    const int codPais = -1;
    const String descripcionCodPais = "";
    const String iibb = "";
    const String fechaInicioActividadesCLA = "";
    const String fechaInicioActividadesSQL = "";
    const String fechaInicioActividadesES = "";
    const String fPagoBancoCredicoop = "";
    const String fPagoBancoDineroMail = "";
    const String fPagoBancoRapiPago = "";
    const String fPagoBancoPagoFacil = "";
    const String fPagoBancoCobroDigital = "";
    const String generarUsuarioCon = "";
    const String razonSocialSoloTexto = "";
    const String codCatIVA = "";
    const String descripcionCodCatIVA = "";
    const int codPcia = -1;
    const String descripcionCodPcia = "";
    const environment = "default";
    String fromType = 'fromZero';
    return TableEmpresaModel._internal(
      codEmp: codEmp,
      razonSocial: razonSocial,
      cuit: cuit,
      cuitF: cuitF,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      image: image,
      telefono: telefono,
      email: email,
      website: website,
      observaciones: observaciones,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      iibb: iibb,
      fechaInicioActividadesCLA: fechaInicioActividadesCLA,
      fechaInicioActividadesSQL: fechaInicioActividadesSQL,
      fechaInicioActividadesES: fechaInicioActividadesES,
      fPagoBancoCredicoop: fPagoBancoCredicoop,
      fPagoBancoDineroMail: fPagoBancoDineroMail,
      fPagoBancoRapiPago: fPagoBancoRapiPago,
      fPagoBancoPagoFacil: fPagoBancoPagoFacil,
      fPagoBancoCobroDigital: fPagoBancoCobroDigital,
      generarUsuarioCon: generarUsuarioCon,
      razonSocialSoloTexto: razonSocialSoloTexto,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      environment: environment,
      fromType: fromType,
    );
  }

  factory TableEmpresaModel.fromDefault() {
    const int codEmp = -1;
    const String razonSocial = "Empresa Default";
    const String cuit = "";
    const String cuitF = "";
    const String domicilio = "";
    const String nroPuerta = "";
    const String piso = "";
    const String depto = "";
    const int codCdad = -1;
    const String descripcionCodCdad = "";
    const String image = "";
    const String telefono = "";
    const String email = "";
    const String website = "";
    const String observaciones = "";
    const int codPais = -1;
    const String descripcionCodPais = "";
    const String iibb = "";
    const String fechaInicioActividadesCLA = "";
    const String fechaInicioActividadesSQL = "";
    const String fechaInicioActividadesES = "";
    const String fPagoBancoCredicoop = "";
    const String fPagoBancoDineroMail = "";
    const String fPagoBancoRapiPago = "";
    const String fPagoBancoPagoFacil = "";
    const String fPagoBancoCobroDigital = "";
    const String generarUsuarioCon = "";
    const String razonSocialSoloTexto = "";
    const String codCatIVA = "";
    const String descripcionCodCatIVA = "";
    const int codPcia = -1;
    const String descripcionCodPcia = "";
    const environment = "default";
    String fromType = 'fromDefault';
    return TableEmpresaModel._internal(
      codEmp: codEmp,
      razonSocial: razonSocial,
      cuit: cuit,
      cuitF: cuitF,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      image: image,
      telefono: telefono,
      email: email,
      website: website,
      observaciones: observaciones,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      iibb: iibb,
      fechaInicioActividadesCLA: fechaInicioActividadesCLA,
      fechaInicioActividadesSQL: fechaInicioActividadesSQL,
      fechaInicioActividadesES: fechaInicioActividadesES,
      fPagoBancoCredicoop: fPagoBancoCredicoop,
      fPagoBancoDineroMail: fPagoBancoDineroMail,
      fPagoBancoRapiPago: fPagoBancoRapiPago,
      fPagoBancoPagoFacil: fPagoBancoPagoFacil,
      fPagoBancoCobroDigital: fPagoBancoCobroDigital,
      generarUsuarioCon: generarUsuarioCon,
      razonSocialSoloTexto: razonSocialSoloTexto,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      environment: environment,
      fromType: fromType,
    );
  }

  /// Create an object from Key (basic)
  /// Environment
  factory TableEmpresaModel.fromKey({
    required int pCodEmp,
    required String pRazonSocial,
    required String pEnvironment,
  }) {
    int codEmp = pCodEmp;
    String razonSocial = pRazonSocial;
    const String cuit = "";
    const String cuitF = "";
    const String domicilio = "";
    const String nroPuerta = "";
    const String piso = "";
    const String depto = "";
    const int codCdad = -1;
    const String descripcionCodCdad = "";
    const String image = "";
    const String telefono = "";
    const String email = "";
    const String website = "";
    const String observaciones = "";
    const int codPais = -1;
    const String descripcionCodPais = "";
    const String iibb = "";
    const String fechaInicioActividadesCLA = "";
    const String fechaInicioActividadesSQL = "";
    const String fechaInicioActividadesES = "";
    const String fPagoBancoCredicoop = "";
    const String fPagoBancoDineroMail = "";
    const String fPagoBancoRapiPago = "";
    const String fPagoBancoPagoFacil = "";
    const String fPagoBancoCobroDigital = "";
    const String generarUsuarioCon = "";
    const String razonSocialSoloTexto = "";
    const String codCatIVA = "";
    const String descripcionCodCatIVA = "";
    const int codPcia = -1;
    const String descripcionCodPcia = "";
    String environment = pEnvironment;
    String fromType = 'fromKey';
    return TableEmpresaModel._internal(
      codEmp: codEmp,
      razonSocial: razonSocial,
      cuit: cuit,
      cuitF: cuitF,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      image: image,
      telefono: telefono,
      email: email,
      website: website,
      observaciones: observaciones,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      iibb: iibb,
      fechaInicioActividadesCLA: fechaInicioActividadesCLA,
      fechaInicioActividadesSQL: fechaInicioActividadesSQL,
      fechaInicioActividadesES: fechaInicioActividadesES,
      fPagoBancoCredicoop: fPagoBancoCredicoop,
      fPagoBancoDineroMail: fPagoBancoDineroMail,
      fPagoBancoRapiPago: fPagoBancoRapiPago,
      fPagoBancoPagoFacil: fPagoBancoPagoFacil,
      fPagoBancoCobroDigital: fPagoBancoCobroDigital,
      generarUsuarioCon: generarUsuarioCon,
      razonSocialSoloTexto: razonSocialSoloTexto,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      environment: environment,
      fromType: fromType,
    );
  }

  factory TableEmpresaModel.fromJson(Map<String, dynamic> map) {
    int codEmp = int.parse(map["CodEmp"].toString());
    String razonSocial = map["RazonSocial"];
    String cuit = map["CUIT"];
    String cuitF = map["CUIT_F"];
    String domicilio = map["Domicilio"];
    String nroPuerta = map["NroPuerta"];
    String piso = map["Piso"];
    String depto = map["Depto"];
    int codCdad = int.parse(map["CodCdad"].toString());
    String descripcionCodCdad = map["DescripcionCodCdad"];
    String image = map["Image"];
    String telefono = map["Telefono"];
    String email = map["EMail"];
    String website = map["Website"];
    String observaciones = map["Observaciones"];
    int codPais = int.parse(map["CodPais"].toString());
    String descripcionCodPais = map["DescripcionCodPais"];
    String iibb = map["IIBB"];
    String fechaInicioActividadesCLA = map["FechaInicioActividadesCLA"];
    String fechaInicioActividadesSQL = map["FechaInicioActividadesSQL"];
    String fechaInicioActividadesES = map["FechaInicioActividades_ES"];
    String fPagoBancoCredicoop = map["FPagoBancoCredicoop"];
    String fPagoBancoDineroMail = map["FPagoBancoDineroMail"];
    String fPagoBancoRapiPago = map["FPagoBancoRapiPago"];
    String fPagoBancoPagoFacil = map["FPagoBancoPagoFacil"];
    String fPagoBancoCobroDigital = map["FPagoBancoCobroDigital"];
    String generarUsuarioCon = map["GenerarUsuarioCon"];
    String razonSocialSoloTexto = map["RazonSocialSoloTexto"];
    String codCatIVA = map["CodCatIVA"];
    String descripcionCodCatIVA = map["DescripcionCodCatIVA"];
    int codPcia = int.parse(map["CodPcia"].toString());
    String descripcionCodPcia = map["DescripcionCodPcia"];
    String environment = map["Environment"];
    String fromType = 'fromJson';
    return TableEmpresaModel._internal(
      codEmp: codEmp,
      razonSocial: razonSocial,
      cuit: cuit,
      cuitF: cuitF,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      image: image,
      telefono: telefono,
      email: email,
      website: website,
      observaciones: observaciones,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      iibb: iibb,
      fechaInicioActividadesCLA: fechaInicioActividadesCLA,
      fechaInicioActividadesSQL: fechaInicioActividadesSQL,
      fechaInicioActividadesES: fechaInicioActividadesES,
      fPagoBancoCredicoop: fPagoBancoCredicoop,
      fPagoBancoDineroMail: fPagoBancoDineroMail,
      fPagoBancoRapiPago: fPagoBancoRapiPago,
      fPagoBancoPagoFacil: fPagoBancoPagoFacil,
      fPagoBancoCobroDigital: fPagoBancoCobroDigital,
      generarUsuarioCon: generarUsuarioCon,
      razonSocialSoloTexto: razonSocialSoloTexto,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      environment: environment,
      fromType: fromType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CodEmp": codEmp,
      "RazonSocial": razonSocial,
      "CUIT": cuit,
      "CUITF": cuitF,
      "Domicilio": domicilio,
      "NroPuerta": nroPuerta,
      "Piso": piso,
      "Depto": depto,
      "CodCdad": codCdad,
      "DescripcionCodCdad": descripcionCodCdad,
      "Image": image,
      "Telefono": telefono,
      "EMail": email,
      "Website": website,
      "Observaciones": observaciones,
      "CodPais": codPais,
      "DescripcionCodPais": descripcionCodPais,
      "IIBB": iibb,
      "FechaInicioActividadesCLA": fechaInicioActividadesCLA,
      "FechaInicioActividadesSQL": fechaInicioActividadesSQL,
      "FechaInicioActividadesES": fechaInicioActividadesES,
      "FPagoBancoCredicoop": fPagoBancoCredicoop,
      "FPagoBancoDineroMail": fPagoBancoDineroMail,
      "FPagoBancoRapiPago": fPagoBancoRapiPago,
      "FPagoBancoPagoFacil": fPagoBancoPagoFacil,
      "FPagoBancoCobroDigital": fPagoBancoCobroDigital,
      "GenerarUsuarioCon": generarUsuarioCon,
      "RazonSocialSoloTexto": razonSocialSoloTexto,
      "CodCatIVA": codCatIVA,
      "DescripcionCodCatIVA": descripcionCodCatIVA,
      "CodPcia": codPcia,
      "DescripcionCodPcia": descripcionCodPcia,
      "Environment": environment,
      'FromType': fromType,
    };
  }

  factory TableEmpresaModel.fromMap(Map<String, dynamic> map) {
    int codEmp = map["codEmp"];
    String razonSocial = map["razonSocial"];
    String cuit = map["cuit"];
    String cuitF = map["cuitF"];
    String domicilio = map["domicilio"];
    String nroPuerta = map["nroPuerta"];
    String piso = map["piso"];
    String depto = map["depto"];
    int codCdad = int.parse(map["codCdad"].toString());
    String descripcionCodCdad = map["descripcionCodCdad"];
    String image = map["image"];
    String telefono = map["telefono"];
    String email = map["email"];
    String website = map["website"];
    String observaciones = map["observaciones"];
    int codPais = int.parse(map["codPais"].toString());
    String descripcionCodPais = map["descripcionCodPais"];
    String iibb = map["iibb"];
    String fechaInicioActividadesCLA = map["fechaInicioActividadesCLA"];
    String fechaInicioActividadesSQL = map["fechaInicioActividadesSQL"];
    String fechaInicioActividadesES = map["fechaInicioActividadesES"];
    String fPagoBancoCredicoop = map["fPagoBancoCredicoop"];
    String fPagoBancoDineroMail = map["fPagoBancoDineroMail"];
    String fPagoBancoRapiPago = map["fPagoBancoRapiPago"];
    String fPagoBancoPagoFacil = map["fPagoBancoPagoFacil"];
    String fPagoBancoCobroDigital = map["fPagoBancoCobroDigital"];
    String generarUsuarioCon = map["generarUsuarioCon"];
    String razonSocialSoloTexto = map["razonSocialSoloTexto"];
    String codCatIVA = map["codCatIVA"];
    String descripcionCodCatIVA = map["descripcionCodCatIVA"];
    int codPcia = int.parse(map["codPcia"].toString());
    String descripcionCodPcia = map["descripcionCodPcia"];
    String environment = map["environment"];
    String fromType = map["fromType"];
    return TableEmpresaModel._internal(
      codEmp: codEmp,
      razonSocial: razonSocial,
      cuit: cuit,
      cuitF: cuitF,
      domicilio: domicilio,
      nroPuerta: nroPuerta,
      piso: piso,
      depto: depto,
      codCdad: codCdad,
      descripcionCodCdad: descripcionCodCdad,
      image: image,
      telefono: telefono,
      email: email,
      website: website,
      observaciones: observaciones,
      codPais: codPais,
      descripcionCodPais: descripcionCodPais,
      iibb: iibb,
      fechaInicioActividadesCLA: fechaInicioActividadesCLA,
      fechaInicioActividadesSQL: fechaInicioActividadesSQL,
      fechaInicioActividadesES: fechaInicioActividadesES,
      fPagoBancoCredicoop: fPagoBancoCredicoop,
      fPagoBancoDineroMail: fPagoBancoDineroMail,
      fPagoBancoRapiPago: fPagoBancoRapiPago,
      fPagoBancoPagoFacil: fPagoBancoPagoFacil,
      fPagoBancoCobroDigital: fPagoBancoCobroDigital,
      generarUsuarioCon: generarUsuarioCon,
      razonSocialSoloTexto: razonSocialSoloTexto,
      codCatIVA: codCatIVA,
      descripcionCodCatIVA: descripcionCodCatIVA,
      codPcia: codPcia,
      descripcionCodPcia: descripcionCodPcia,
      environment: environment,
      fromType: fromType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "codEmp": codEmp,
      "razonSocial": razonSocial,
      "cuit": cuit,
      "cuitF": cuitF,
      "domicilio": domicilio,
      "nroPuerta": nroPuerta,
      "piso": piso,
      "depto": depto,
      "codCdad": codCdad,
      "descripcionCodCdad": descripcionCodCdad,
      "image": image,
      "telefono": telefono,
      "email": email,
      "website": website,
      "observaciones": observaciones,
      "codPais": codPais,
      "descripcionCodPais": descripcionCodPais,
      "iibb": iibb,
      "fechaInicioActividadesCLA": fechaInicioActividadesCLA,
      "fechaInicioActividadesSQL": fechaInicioActividadesSQL,
      "fechaInicioActividadesES": fechaInicioActividadesES,
      "fPagoBancoCredicoop": fPagoBancoCredicoop,
      "fPagoBancoDineroMail": fPagoBancoDineroMail,
      "fPagoBancoRapiPago": fPagoBancoRapiPago,
      "fPagoBancoPagoFacil": fPagoBancoPagoFacil,
      "fPagoBancoCobroDigital": fPagoBancoCobroDigital,
      "generarUsuarioCon": generarUsuarioCon,
      "razonSocialSoloTexto": razonSocialSoloTexto,
      "codCatIVA": codCatIVA,
      "descripcionCodCatIVA": descripcionCodCatIVA,
      "codPcia": codPcia,
      "descripcionCodPcia": descripcionCodPcia,
      "environment": environment,
      'fromType': fromType,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableEmpresaModel &&
          runtimeType == other.runtimeType &&
          codEmp == other.codEmp &&
          environment == other.environment);

  @override
  int get hashCode => codEmp.hashCode + environment.hashCode;

  @override
  String get dropDownAvatar => image;

  @override
  String get dropDownItemAsString =>
      '${codPais.toString().padLeft(5, '0')} - $razonSocial';

  @override
  String get dropDownKey => codEmp.toString();

  @override
  String get dropDownSubTitle => razonSocial.toString();

  @override
  String get dropDownTitle => razonSocial.toString();

  @override
  String get dropDownValue => razonSocial.toString();

  @override
  bool get isDisabled => false;

  @override
  String get textOnDisabled => "";

  @override
  Future<List<CommonParamKeyValue<CommonParamKeyValueCapable>>>
      filterSearchFromDropDown({required String searchText}) {
    throw UnimplementedError();
  }

  @override
  CommonParamKeyValueCapable fromDefault() {
    throw UnimplementedError();
  }
}
