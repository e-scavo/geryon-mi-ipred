import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/onu_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/pon_model.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/tipo_nas.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_NAS/type_vendors.dart';

class ProcedureParamsModel {
  VendorTypeModel vendorType = VendorTypeModel.unknown;
  TipoNASModel tipoNAS = TipoNASModel.unknown;
  TableEmpresaModel empresa = TableEmpresaModel.fromDefault();
  late TableNASModel nas;
  late PONModel pon;
  late ONUModel onu;

  String searchBy = '';
  ProcedureParamsModel() {
    nas = TableNASModel.fromDefault(
      pEmpresa: empresa,
    );
    pon = PONModel.fromDefault(
      pNASId: nas,
    );
    onu = ONUModel.fromDefault(
      pPONId: pon,
    );
  }
}
