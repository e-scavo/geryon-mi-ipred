import 'package:geryon_web_app_ws_v2/models/CommonClaseCpbteVT/model.dart';

class CommonGenericProcedureParamsModel {
  static const String className = "CommonGenericProcedureParamsModel";

  CommonClasesCpbteVT? claseCpbte;
  bool generateSelectItem;
  bool generateNewItem;

  CommonGenericProcedureParamsModel({
    this.claseCpbte,
    this.generateSelectItem = false,
    this.generateNewItem = false,
  });
}
