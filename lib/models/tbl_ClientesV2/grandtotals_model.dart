import 'package:geryon_web_app_ws_v2/models/CommonNumbersModel/number_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class TableClientesV2GrandTotalsModel {
  static const String className = 'TableClientesV2GrandTotalsModel';
  CommonNumbersModel cantTotalClientes;
  CommonNumbersModel cantTotalFilteredClientes;
  CommonNumbersModel cantTotalClientesVOZ;
  CommonNumbersModel cantTotalFilteredClientesVOZ;
  CommonNumbersModel cantTotalClientesDATOS;
  CommonNumbersModel cantTotalFilteredClientesDATOS;
  CommonNumbersModel cantTotalClientesTELEVISION;
  CommonNumbersModel cantTotalFilteredClientesTELEVISION;
  CommonNumbersModel cantTotalBajaClientesPENDIENTE;
  CommonNumbersModel cantTotalFilteredBajaClientesPENDIENTE;
  CommonNumbersModel cantTotalVVTTClientesPENDIENTE;
  CommonNumbersModel cantTotalFilteredVVTTClientesPENDIENTE;
  CommonNumbersModel cantTotalMudanzasClientesPENDIENTE;
  CommonNumbersModel cantTotalFilteredMudanzasClientesPENDIENTE;
  CommonNumbersModel saldoTotalVencido;
  CommonNumbersModel saldoTotalCuentaCorriente;
  CommonNumbersModel saldoTotal;
  CommonNumbersModel totalFilteredRecords;
  CommonNumbersModel totalRecords;

  TableClientesV2GrandTotalsModel._internal({
    required this.cantTotalClientes,
    required this.cantTotalFilteredClientes,
    required this.cantTotalClientesVOZ,
    required this.cantTotalFilteredClientesVOZ,
    required this.cantTotalClientesDATOS,
    required this.cantTotalFilteredClientesDATOS,
    required this.cantTotalClientesTELEVISION,
    required this.cantTotalFilteredClientesTELEVISION,
    required this.cantTotalBajaClientesPENDIENTE,
    required this.cantTotalFilteredBajaClientesPENDIENTE,
    required this.cantTotalVVTTClientesPENDIENTE,
    required this.cantTotalFilteredVVTTClientesPENDIENTE,
    required this.cantTotalMudanzasClientesPENDIENTE,
    required this.cantTotalFilteredMudanzasClientesPENDIENTE,
    required this.saldoTotalVencido,
    required this.saldoTotalCuentaCorriente,
    required this.saldoTotal,
    required this.totalFilteredRecords,
    required this.totalRecords,
  });

  factory TableClientesV2GrandTotalsModel.fromJson(Map<String, dynamic> json) {
    const String functionName = 'fromJson';
    var rCantTotalClientes = CommonNumbersModel.tryParse(
      json['CantTotalClientes'],
      fieldName: 'CantTotalClientes',
    );
    if (rCantTotalClientes.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalClientes.errorCode,
        errorDsc: rCantTotalClientes.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalClientes',
        propertyValue: json['CantTotalClientes'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalClientes = rCantTotalClientes.data;
    var rCantTotalFilteredClientes = CommonNumbersModel.tryParse(
      json['CantTotalFilteredClientes'],
      fieldName: 'CantTotalFilteredClientes',
    );
    if (rCantTotalFilteredClientes.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalFilteredClientes.errorCode,
        errorDsc: rCantTotalFilteredClientes.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalFilteredClientes',
        propertyValue: json['CantTotalFilteredClientes'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalFilteredClientes = rCantTotalFilteredClientes.data;
    var rCantTotalClientesVOZ = CommonNumbersModel.tryParse(
      json['CantTotalClientesVOZ'],
      fieldName: 'CantTotalClientesVOZ',
    );
    if (rCantTotalClientesVOZ.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalClientesVOZ.errorCode,
        errorDsc: rCantTotalClientesVOZ.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalClientesVOZ',
        propertyValue: json['CantTotalClientesVOZ'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalClientesVOZ = rCantTotalClientesVOZ.data;
    var rCantTotalFilteredClientesVOZ = CommonNumbersModel.tryParse(
      json['CantTotalFilteredClientesVOZ'],
      fieldName: 'CantTotalFilteredClientesVOZ',
    );
    if (rCantTotalFilteredClientesVOZ.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalFilteredClientesVOZ.errorCode,
        errorDsc: rCantTotalFilteredClientesVOZ.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalFilteredClientesVOZ',
        propertyValue: json['CantTotalFilteredClientesVOZ'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalFilteredClientesVOZ = rCantTotalFilteredClientesVOZ.data;
    var rCantTotalClientesDATOS = CommonNumbersModel.tryParse(
      json['CantTotalClientesDATOS'],
      fieldName: 'CantTotalClientesDATOS',
    );
    if (rCantTotalClientesDATOS.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalClientesDATOS.errorCode,
        errorDsc: rCantTotalClientesDATOS.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalClientesDATOS',
        propertyValue: json['CantTotalClientesDATOS'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalClientesDATOS = rCantTotalClientesDATOS.data;
    var rCantTotalFilteredClientesDATOS = CommonNumbersModel.tryParse(
      json['CantTotalFilteredClientesDATOS'],
      fieldName: 'CantTotalFilteredClientesDATOS',
    );
    if (rCantTotalFilteredClientesDATOS.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalFilteredClientesDATOS.errorCode,
        errorDsc: rCantTotalFilteredClientesDATOS.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalFilteredClientesDATOS',
        propertyValue: json['CantTotalFilteredClientesDATOS'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalFilteredClientesDATOS = rCantTotalFilteredClientesDATOS.data;
    var rCantTotalClientesTELEVISION = CommonNumbersModel.tryParse(
      json['CantTotalClientesTELEVISION'],
      fieldName: 'CantTotalClientesTELEVISION',
    );
    if (rCantTotalClientesTELEVISION.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalClientesTELEVISION.errorCode,
        errorDsc: rCantTotalClientesTELEVISION.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalClientesTELEVISION',
        propertyValue: json['CantTotalClientesTELEVISION'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalClientesTELEVISION = rCantTotalClientesTELEVISION.data;
    var rCantTotalFilteredClientesTELEVISION = CommonNumbersModel.tryParse(
      json['CantTotalFilteredClientesTELEVISION'],
      fieldName: 'CantTotalFilteredClientesTELEVISION',
    );
    if (rCantTotalFilteredClientesTELEVISION.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalFilteredClientesTELEVISION.errorCode,
        errorDsc: rCantTotalFilteredClientesTELEVISION.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalFilteredClientesTELEVISION',
        propertyValue: json['CantTotalFilteredClientesTELEVISION'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalFilteredClientesTELEVISION =
        rCantTotalFilteredClientesTELEVISION.data;
    var rCantTotalBajaClientesPENDIENTE = CommonNumbersModel.tryParse(
      json['CantTotalBajaClientesPENDIENTE'],
      fieldName: 'CantTotalBajaClientesPENDIENTE',
    );
    if (rCantTotalBajaClientesPENDIENTE.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalBajaClientesPENDIENTE.errorCode,
        errorDsc: rCantTotalBajaClientesPENDIENTE.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalBajaClientesPENDIENTE',
        propertyValue: json['CantTotalBajaClientesPENDIENTE'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalBajaClientesPENDIENTE = rCantTotalBajaClientesPENDIENTE.data;
    var rCantTotalFilteredBajaClientesPENDIENTE = CommonNumbersModel.tryParse(
      json['CantTotalFilteredBajaClientesPENDIENTE'],
      fieldName: 'CantTotalFilteredBajaClientesPENDIENTE',
    );
    if (rCantTotalFilteredBajaClientesPENDIENTE.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalFilteredBajaClientesPENDIENTE.errorCode,
        errorDsc: rCantTotalFilteredBajaClientesPENDIENTE.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalFilteredBajaClientesPENDIENTE',
        propertyValue: json['CantTotalFilteredBajaClientesPENDIENTE'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalFilteredBajaClientesPENDIENTE =
        rCantTotalFilteredBajaClientesPENDIENTE.data;
    var rCantTotalVVTTClientesPENDIENTE = CommonNumbersModel.tryParse(
      json['CantTotalVVTTClientesPENDIENTE'],
      fieldName: 'CantTotalVVTTClientesPENDIENTE',
    );
    if (rCantTotalVVTTClientesPENDIENTE.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalVVTTClientesPENDIENTE.errorCode,
        errorDsc: rCantTotalVVTTClientesPENDIENTE.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalVVTTClientesPENDIENTE',
        propertyValue: json['CantTotalVVTTClientesPENDIENTE'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalVVTTClientesPENDIENTE = rCantTotalVVTTClientesPENDIENTE.data;
    var rCantTotalFilteredVVTTClientesPENDIENTE = CommonNumbersModel.tryParse(
      json['CantTotalFilteredVVTTClientesPENDIENTE'],
      fieldName: 'CantTotalFilteredVVTTClientesPENDIENTE',
    );
    if (rCantTotalFilteredVVTTClientesPENDIENTE.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalFilteredVVTTClientesPENDIENTE.errorCode,
        errorDsc: rCantTotalFilteredVVTTClientesPENDIENTE.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalFilteredVVTTClientesPENDIENTE',
        propertyValue: json['CantTotalFilteredVVTTClientesPENDIENTE'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalFilteredVVTTClientesPENDIENTE =
        rCantTotalFilteredVVTTClientesPENDIENTE.data;
    var rCantTotalMudanzasClientesPENDIENTE = CommonNumbersModel.tryParse(
      json['CantTotalMudanzasClientesPENDIENTE'],
      fieldName: 'CantTotalMudanzasClientesPENDIENTE',
    );
    if (rCantTotalMudanzasClientesPENDIENTE.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalMudanzasClientesPENDIENTE.errorCode,
        errorDsc: rCantTotalMudanzasClientesPENDIENTE.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalMudanzasClientesPENDIENTE',
        propertyValue: json['CantTotalMudanzasClientesPENDIENTE'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalMudanzasClientesPENDIENTE =
        rCantTotalMudanzasClientesPENDIENTE.data;
    var rCantTotalFilteredMudanzasClientesPENDIENTE =
        CommonNumbersModel.tryParse(
      json['CantTotalFilteredMudanzasClientesPENDIENTE'],
      fieldName: 'CantTotalFilteredMudanzasClientesPENDIENTE',
    );
    if (rCantTotalFilteredMudanzasClientesPENDIENTE.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rCantTotalFilteredMudanzasClientesPENDIENTE.errorCode,
        errorDsc: rCantTotalFilteredMudanzasClientesPENDIENTE.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'CantTotalFilteredMudanzasClientesPENDIENTE',
        propertyValue: json['CantTotalFilteredMudanzasClientesPENDIENTE'],
        stacktrace: StackTrace.current,
      );
    }
    var cantTotalFilteredMudanzasClientesPENDIENTE =
        rCantTotalFilteredMudanzasClientesPENDIENTE.data;
    var rSaldoTotalVencido = CommonNumbersModel.tryParse(
      json['SaldoTotalVencido'],
      fieldName: 'SaldoTotalVencido',
    );
    if (rSaldoTotalVencido.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rSaldoTotalVencido.errorCode,
        errorDsc: rSaldoTotalVencido.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'SaldoTotalVencido',
        propertyValue: json['SaldoTotalVencido'],
        stacktrace: StackTrace.current,
      );
    }
    var saldoTotalVencido = rSaldoTotalVencido.data;
    var rSaldoTotalCuentaCorriente = CommonNumbersModel.tryParse(
      json['SaldoTotalCuentaCorriente'],
      fieldName: 'SaldoTotalCuentaCorriente',
    );
    if (rSaldoTotalCuentaCorriente.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rSaldoTotalCuentaCorriente.errorCode,
        errorDsc: rSaldoTotalCuentaCorriente.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'SaldoTotalCuentaCorriente',
        propertyValue: json['SaldoTotalCuentaCorriente'],
        stacktrace: StackTrace.current,
      );
    }
    var saldoTotalCuentaCorriente = rSaldoTotalCuentaCorriente.data;
    var rSaldoTotal = CommonNumbersModel.tryParse(
      json['SaldoTotal'],
      fieldName: 'SaldoTotal',
    );
    if (rSaldoTotal.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rSaldoTotal.errorCode,
        errorDsc: rSaldoTotal.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'SaldoTotal',
        propertyValue: json['SaldoTotal'],
        stacktrace: StackTrace.current,
      );
    }
    var saldoTotal = rSaldoTotal.data;
    var rTotalFilteredRecords = CommonNumbersModel.tryParse(
      json['TotalFilteredRecords'],
      fieldName: 'TotalFilteredRecords',
    );
    if (rTotalFilteredRecords.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rTotalFilteredRecords.errorCode,
        errorDsc: rTotalFilteredRecords.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'TotalFilteredRecords',
        propertyValue: json['TotalFilteredRecords'],
        stacktrace: StackTrace.current,
      );
    }
    var totalFilteredRecords = rTotalFilteredRecords.data;
    var rTotalRecords = CommonNumbersModel.tryParse(
      json['TotalRecords'],
      fieldName: 'TotalRecords',
    );
    if (rTotalRecords.errorCode != 0) {
      throw ErrorHandler(
        errorCode: rTotalRecords.errorCode,
        errorDsc: rTotalRecords.errorDsc,
        className: className,
        functionName: functionName,
        propertyName: 'TotalRecords',
        propertyValue: json['TotalRecords'],
        stacktrace: StackTrace.current,
      );
    }
    var totalRecords = rTotalRecords.data;
    return TableClientesV2GrandTotalsModel._internal(
      cantTotalClientes: cantTotalClientes,
      cantTotalFilteredClientes: cantTotalFilteredClientes,
      cantTotalClientesVOZ: cantTotalClientesVOZ,
      cantTotalFilteredClientesVOZ: cantTotalFilteredClientesVOZ,
      cantTotalClientesDATOS: cantTotalClientesDATOS,
      cantTotalFilteredClientesDATOS: cantTotalFilteredClientesDATOS,
      cantTotalClientesTELEVISION: cantTotalClientesTELEVISION,
      cantTotalFilteredClientesTELEVISION: cantTotalFilteredClientesTELEVISION,
      cantTotalBajaClientesPENDIENTE: cantTotalBajaClientesPENDIENTE,
      cantTotalFilteredBajaClientesPENDIENTE:
          cantTotalFilteredBajaClientesPENDIENTE,
      cantTotalVVTTClientesPENDIENTE: cantTotalVVTTClientesPENDIENTE,
      cantTotalFilteredVVTTClientesPENDIENTE:
          cantTotalFilteredVVTTClientesPENDIENTE,
      cantTotalMudanzasClientesPENDIENTE: cantTotalMudanzasClientesPENDIENTE,
      cantTotalFilteredMudanzasClientesPENDIENTE:
          cantTotalFilteredMudanzasClientesPENDIENTE,
      saldoTotalVencido: saldoTotalVencido,
      saldoTotalCuentaCorriente: saldoTotalCuentaCorriente,
      saldoTotal: saldoTotal,
      totalFilteredRecords: totalFilteredRecords,
      totalRecords: totalRecords,
    );
  }

  factory TableClientesV2GrandTotalsModel.fromDefault() {
    const defaultValue = "-9999999";
    final defaultMap = <String, dynamic>{
      "cantTotalClientes": defaultValue,
      "cantTotalFilteredClientes": defaultValue,
      "cantTotalClientesVOZ": defaultValue,
      "cantTotalFilteredClientesVOZ": defaultValue,
      "cantTotalClientesDATOS": defaultValue,
      "cantTotalFilteredClientesDATOS": defaultValue,
      "cantTotalClientesTELEVISION": defaultValue,
      "cantTotalFilteredClientesTELEVISION": defaultValue,
      "cantTotalBajaClientesPENDIENTE": defaultValue,
      "cantTotalFilteredBajaClientesPENDIENTE": defaultValue,
      "cantTotalVVTTClientesPENDIENTE": defaultValue,
      "cantTotalFilteredVVTTClientesPENDIENTE": defaultValue,
      "cantTotalMudanzasClientesPENDIENTE": defaultValue,
      "cantTotalFilteredMudanzasClientesPENDIENTE": defaultValue,
      "saldoTotalVencido": defaultValue,
      "saldoTotalCuentaCorriente": defaultValue,
      "saldoTotal": defaultValue,
      "TotalFilteredRecords": defaultValue,
      "TotalRecords": defaultValue,
    };

    return TableClientesV2GrandTotalsModel.fromJson(defaultMap);
  }
  Map<String, dynamic> toJson() {
    return {
      "CantTotalClientes": cantTotalClientes,
      "CantTotalFilteredClientes": cantTotalFilteredClientes,
      "CantTotalClientesVOZ": cantTotalClientesVOZ,
      "CantTotalFilteredClientesVOZ": cantTotalFilteredClientesVOZ,
      "CantTotalClientesDATOS": cantTotalClientesDATOS,
      "CantTotalFilteredClientesDATOS": cantTotalFilteredClientesDATOS,
      "CantTotalClientesTELEVISION": cantTotalClientesTELEVISION,
      "CantTotalFilteredClientesTELEVISION":
          cantTotalFilteredClientesTELEVISION,
      "CantTotalBajaClientesPENDIENTE": cantTotalBajaClientesPENDIENTE,
      "CantTotalFilteredBajaClientesPENDIENTE":
          cantTotalFilteredBajaClientesPENDIENTE,
      "CantTotalVVTTClientesPENDIENTE": cantTotalVVTTClientesPENDIENTE,
      "CantTotalFilteredVVTTClientesPENDIENTE":
          cantTotalFilteredVVTTClientesPENDIENTE,
      "CantTotalMudanzasClientesPENDIENTE": cantTotalMudanzasClientesPENDIENTE,
      "CantTotalFilteredMudanzasClientesPENDIENTE":
          cantTotalFilteredMudanzasClientesPENDIENTE,
      "SaldoTotalVencido": saldoTotalVencido,
      "SaldoTotalCuentaCorriente": saldoTotalCuentaCorriente,
      "SaldoTotal": saldoTotal,
      "TotalFilteredRecords": totalFilteredRecords,
      "TotalRecords": totalRecords,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "cantTotalClientes": cantTotalClientes,
      "cantTotalFilteredClientes": cantTotalFilteredClientes,
      "cantTotalClientesVOZ": cantTotalClientesVOZ,
      "cantTotalFilteredClientesVOZ": cantTotalFilteredClientesVOZ,
      "cantTotalClientesDATOS": cantTotalClientesDATOS,
      "cantTotalFilteredClientesDATOS": cantTotalFilteredClientesDATOS,
      "cantTotalClientesTELEVISION": cantTotalClientesTELEVISION,
      "cantTotalFilteredClientesTELEVISION":
          cantTotalFilteredClientesTELEVISION,
      "cantTotalBajaClientesPENDIENTE": cantTotalBajaClientesPENDIENTE,
      "cantTotalFilteredBajaClientesPENDIENTE":
          cantTotalFilteredBajaClientesPENDIENTE,
      "cantTotalVVTTClientesPENDIENTE": cantTotalVVTTClientesPENDIENTE,
      "cantTotalFilteredVVTTClientesPENDIENTE":
          cantTotalFilteredVVTTClientesPENDIENTE,
      "cantTotalMudanzasClientesPENDIENTE": cantTotalMudanzasClientesPENDIENTE,
      "cantTotalFilteredMudanzasClientesPENDIENTE":
          cantTotalFilteredMudanzasClientesPENDIENTE,
      "saldoTotalVencido": saldoTotalVencido,
      "saldoTotalCuentaCorriente": saldoTotalCuentaCorriente,
      "saldoTotal": saldoTotal,
      "totalFilteredRecords": totalFilteredRecords,
      "totalRecords": totalRecords,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    final thisMap = toMap();
    final otherMap = (other as TableClientesV2GrandTotalsModel).toMap();

    for (final key in thisMap.keys) {
      if (thisMap[key] != otherMap[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final map = toMap();
    return Object.hashAll(map.entries.map((e) => Object.hash(e.key, e.value)));
  }
}
