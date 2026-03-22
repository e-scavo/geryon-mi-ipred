import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names_values.dart';

class CommonFieldNames<T> {
  //late List<Map<String, String>> _fieldnames;
  //late List<Map<String, CommonFieldNamesValues>> _fieldnames;
  late Map<int, String> _columns;
  late List<CommonFieldNamesValues> _fieldnames;
  final Map<CommonFieldNamesValues, CommonCopyToClipboard>
      _copyToClipboardFunctions = {};
  Map<CommonFieldNamesValues, CommonCopyToClipboard>
      get copyToClipboardFunctions => _copyToClipboardFunctions;
  late T record;
  CommonFieldNames() {
    _columns = {};
    _fieldnames = [];
  }

  add({
    required String kValue,
    required String vValue,
    required CommonFieldNamesValuesFunction? vFunction,
    TextAlign? vTextAlign,
    TextAlign? vContentTextAlign,
    Alignment? vContentAlignment,
    double? vWidth,
    CommonCopyToClipboard? vCopyToClipboard,
  }) {
    var field = CommonFieldNamesValues(
      key: kValue,
      value: vValue,
      func: vFunction,
      textAlign: vTextAlign,
      contentTextAlign: vContentTextAlign,
      contentAlignment: vContentAlignment,
      width: vWidth,
      copyToClipboard: vCopyToClipboard,
    );
    _fieldnames.add(field);
    if (vCopyToClipboard != null) {
      _copyToClipboardFunctions[field] = vCopyToClipboard;
    }
  }

  Map<int, String> getColumns() {
    _columns = {};
    _columns[0] = 'Unknown';
    var f = getFieldNames();
    for (var element in f) {
      _columns[_columns.length] = element.key;
    }
    return _columns;
  }

  List<CommonFieldNamesValues> getFieldNames() {
    return _fieldnames;
  }

  Map<CommonFieldNamesValues, CommonCopyToClipboard>
      getCopyToClipboardFunctions() {
    return _copyToClipboardFunctions;
  }

  // List<String> getFieldNames3() {
  //   List<String> rData = [];
  //   for (var element in _fieldnames) {
  //     element.forEach((key, value) {
  //       rData.add(key);
  //     });
  //   }
  //   return rData;
  // }

  // List<CommonFieldNamesValues> getFieldDescription() {
  //   List<CommonFieldNamesValues> rData = [];
  //   for (var element in _fieldnames) {
  //     element.forEach((key, value) {
  //       //rData.add(value.getFieldDescription());
  //       rData.add(value);
  //     });
  //   }
  //   return rData;
  // }

  /// Return formatted value for specific key in the Map
  ///
  // String getFormattedFieldValue(String key) {

  // }
}
