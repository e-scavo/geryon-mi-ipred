import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/extensions/color.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

abstract class CommonParamKeyValueCapable {
  CommonParamKeyValueCapable fromDefault();
  Future<List<CommonParamKeyValue>> filterSearchFromDropDown({
    required String searchText,
  });

  String get dropDownItemAsString;
  String get dropDownKey;
  String get dropDownValue;
  String get dropDownTitle;
  String get dropDownSubTitle;
  String get dropDownAvatar;
  bool get isDisabled;
  String get textOnDisabled;
}

class CommonParamKeyValue<T extends CommonParamKeyValueCapable> {
  final String key;
  final String value;
  final String title;
  final String subTitle;
  final String avatar;
  final T? typeObject;

  const CommonParamKeyValue._internal({
    required this.key,
    required this.value,
    required this.title,
    required this.subTitle,
    required this.avatar,
    required this.typeObject,
  });

  factory CommonParamKeyValue.fromType({
    required T tObject,
  }) {
    T typeObject = tObject;
    String key = typeObject.dropDownKey;
    String value = typeObject.dropDownValue;
    String title = typeObject.dropDownTitle;
    String subTitle = typeObject.dropDownSubTitle;
    String avatar = typeObject.dropDownAvatar;
    return CommonParamKeyValue._internal(
      key: key,
      value: value,
      title: title,
      subTitle: subTitle,
      avatar: avatar,
      typeObject: typeObject,
    );
  }
  factory CommonParamKeyValue.fromStandard({
    required String key,
    required String value,
    required String title,
    String subTitle = "",
    String avatar = 'assets/png/geryon_app_icon-64x64.png',
  }) {
    T? typeObject;
    return CommonParamKeyValue._internal(
      key: key,
      value: value,
      title: title,
      subTitle: subTitle,
      avatar: avatar,
      typeObject: typeObject,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'title': title,
      'subTitle': subTitle,
      'avatar': avatar,
      'typeObject': typeObject,
    };
  }

  String toJson() {
    return {
      'Key': key,
      'Value': value,
      'Title': title,
      'SubTitle': subTitle,
      'Avatar': avatar,
      'TypeObject': typeObject,
    }.toString();
  }

  @override
  String toString() {
    return toMap().toString();
  }

  // @override
  // List<Object?> get props => [
  //       key,
  //       value,
  //       title,
  //       subTitle,
  //       avatar,
  //       typeObject,
  //     ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! CommonParamKeyValue) return false;

    Map<String, dynamic> thisMap = toMap();
    Map<String, dynamic> otherMap = other.toMap();

    for (String key in thisMap.keys) {
      if (thisMap[key].runtimeType != otherMap[key].runtimeType) {
        return false;
      }
      if (thisMap[key] != otherMap[key]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    return toMap().values.fold(0,
        (previousValue, element) => previousValue.hashCode + element.hashCode);
  }

  ///
  ///
  /// This function allows to return an standard Widget for SelectedItem
  ///
  Widget standardPopupItemBuilderCommonParamKeyValue(
    BuildContext context,
    CommonParamKeyValue item,
    bool isSelected,
  ) {
    try {
      var baseItem = Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: ListTile(
          selected: isSelected,
          title: Text(item.title),
          subtitle: item.subTitle.isEmpty ? null : Text(item.subTitle),
          leading: item.avatar.isEmpty
              ? null
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(item.avatar),
                ),
        ),
      );
      Widget finalItem;

      /// MODIFIED
      /// Si el ítem no es nulo
      /// (es decir que tiene asociado un registro en una tabla específica)
      if (item.typeObject != null) {
        if (item.typeObject!.isDisabled) {
          var textOnDisabled = 'YA ASOCIADO';
          switch (item.typeObject!.textOnDisabled) {
            case "":
              break;
            default:
              textOnDisabled = item.typeObject!.textOnDisabled;
          }
          var tempItem = Stack(
            children: [
              baseItem,
              Positioned.fill(
                child: Container(
                  color: Colors.grey.withSafeOpacity(0.1),
                  child: Opacity(
                    opacity: 0.2,
                    child: Center(
                      child: Text(
                        textOnDisabled,
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.red.withSafeOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (1 == 2)
                const Positioned.fill(
                  child: Opacity(
                    opacity: 0.2,
                    child: Center(
                      child: Text(
                        'WATERMARK',
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
          finalItem = tempItem;
        } else {
          finalItem = baseItem;
        }
      } else {
        finalItem = baseItem;
      }

      // var finalItem = item.typeObject!.isDisabled
      //     ? Stack(
      //         children: [
      //           baseItem,
      //           Positioned.fill(
      //             child: Container(
      //               color: Colors.grey.withSafeOpacity(0.1),
      //               child: Opacity(
      //                 opacity: 0.2,
      //                 child: Center(
      //                   child: Text(
      //                     'YA ASOCIADO',
      //                     style: TextStyle(
      //                       fontSize: 50,
      //                       color: Colors.red.withSafeOpacity(0.5),
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           if (1 == 2)
      //             const Positioned.fill(
      //               child: Opacity(
      //                 opacity: 0.2,
      //                 child: Center(
      //                   child: Text(
      //                     'WATERMARK',
      //                     style: TextStyle(
      //                       fontSize: 50,
      //                       color: Colors.grey,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //         ],
      //       )
      //     : baseItem;
      return finalItem;
    } catch (e, stacktrace) {
      throw ErrorHandler(
        errorCode: 6789,
        errorDsc:
            'Ocurrió un error al intentar generar el ítem del DropDownBox.\r\n${e.toString()}',
        stacktrace: stacktrace,
      );
    }
  }

  /// This function allows to return an standard Widget for SelectedItem
  /// [STATIC]
  static Widget sStandardPopupItemBuilderCommonParamKeyValue(
    BuildContext context,
    CommonParamKeyValue item,
    bool isSelected,
  ) {
    try {
      var baseItem = Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: ListTile(
          selected: isSelected,
          title: Text(item.title),
          subtitle: item.subTitle.isEmpty ? null : Text(item.subTitle),
          leading: item.avatar.isEmpty
              ? null
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(item.avatar),
                ),
        ),
      );
      Widget finalItem;

      /// MODIFIED
      /// Si el ítem no es nulo
      /// (es decir que tiene asociado un registro en una tabla específica)
      if (item.typeObject != null) {
        if (item.typeObject!.isDisabled) {
          var textOnDisabled = 'YA ASOCIADO';
          switch (item.typeObject!.textOnDisabled) {
            case "":
              break;
            default:
              textOnDisabled = item.typeObject!.textOnDisabled;
          }
          var tempItem = Stack(
            children: [
              baseItem,
              Positioned.fill(
                child: Container(
                  color: Colors.grey.withSafeOpacity(0.1),
                  child: Opacity(
                    opacity: 0.2,
                    child: Center(
                      child: Text(
                        textOnDisabled,
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.red.withSafeOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (1 == 2)
                const Positioned.fill(
                  child: Opacity(
                    opacity: 0.2,
                    child: Center(
                      child: Text(
                        'WATERMARK',
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
          finalItem = tempItem;
        } else {
          finalItem = baseItem;
        }
      } else {
        finalItem = baseItem;
      }
      return finalItem;
    } catch (e, stacktrace) {
      throw ErrorHandler(
        errorCode: 6789,
        errorDsc:
            'Ocurrió un error al intentar generar el ítem del DropDownBox.\r\n${e.toString()}',
        stacktrace: stacktrace,
      );
    }
  }
}
