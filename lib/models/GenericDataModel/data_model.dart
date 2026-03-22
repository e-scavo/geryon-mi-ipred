import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDataModel/data_model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonModel/model.dart';

class GenericDataModel<T extends CommonModel<T>> extends CommonDataModel<T> {
  /// Init Class
  ///
  ///
  static final String _className = 'GenericDataModel';
  static final String aClassName = '.::$_className::';
  late String threadID;
  GenericDataModel({
    required super.wRef,
    required super.debug,
    String threadID = "",
  }) {
    if (threadID.isNotEmpty) {
      this.threadID = threadID;
      // } else {
      //   this.threadID = aClassName + DateTime.now().toString();
    }
  }

  /// This process returns true if there are changes in the whole record of the current CRUD action.
  ///
  bool didWeChange() {
    //ToDo: Analize and FixIt
    return true;
  }

  @override
  ConstRequests pGlobalRequest = ConstRequests.unknown;

  @override
  ConstRequests pLocalRequest = ConstRequests.unknown;

  @override
  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();

    // String functionName = '$runtimeType';
    // throw ErrorHandler(
    //   errorCode: 666,
    //   errorDsc: 'Función $functionName no definida.',
    //   className: _className,
    //   functionName: functionName,
    //   propertyName: '<desconocida>',
    //   propertyValue: 'desconocido>',
    //   stacktrace: StackTrace.current,
    // );
  }
}
