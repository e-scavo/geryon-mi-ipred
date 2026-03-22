import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/CommonFieldNames/common_field_names.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:geryon_web_app_ws_v2/models/tbl_Empresas/model.dart';

typedef SetTest = Future<ErrorHandler> Function({
  required String searchText,
  required TableEmpresaModel pEmpresa,
  String fromProcessAsString,
  String setProperty,
});

typedef StandardFromJsonFunction = Function({
  required Map<String, dynamic> map,
  int errorCode,
});

abstract class CommonModel<T> {
  static const String className = "CommonModel";

  /// El método estático que se debe implementar en cada clase concreta
  static String sDefaultTable() {
    throw UnimplementedError('Debe ser implementado en las clases concretas');
  }

  String iDefaultTable();

  Map<String, dynamic> toMap();
  Map<String, dynamic> toJson();

  // T fromJson({
  //   required Map<String, dynamic> map,
  //   int errorCode = 0,
  // });

  /// Factory constructor
  ///
  // factory CommonModel.fromJson({
  //   required Map<String, dynamic> map,
  //   int errorCode = 0,
  // }) {
  //   //throw UnimplementedError('Must be implemented by a concrete subclass');
  //   //T? s;
  //   throw ErrorHandler(
  //     errorCode: 666,
  //     errorDsc: 'Must be implemented by a concrete subclass',
  //     stacktrace: StackTrace.current,
  //     className: className,
  //     functionName: "fromJson",
  //   );
  // }

  /// Abstract methods
  ///
  Map<String, dynamic> getKeyEntity();
  CommonFieldNames getView({
    required String pViewName,
  });

  /// Método estático genérico para llamar a `fromJson` en la subclase de `T`
  static T fromJson<T extends CommonModel<T>>({
    required Map<String, dynamic> map,
    required int errorCode,
    required T Function({
      required Map<String, dynamic> map,
      int errorCode,
    }) fromJsonFunction,
  }) {
    return fromJsonFunction(
      map: map,
      errorCode: errorCode,
    );
  }

  /// Métodos == y hashCode para comparar objetos
  ///
  @override
  bool operator ==(Object other) {
    developer
        .log('Operator - Comparando $runtimeType con ${other.runtimeType}');
    developer.log('Operator - Comparando IDENTICAL ${identical(this, other)}');
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! CommonModel<T>) return false;

    final mapA = _normalizeMap(toMap());
    final mapB = _normalizeMap((other).toMap());

    return _deepEquals(mapA, mapB);
  }

  @override
  int get hashCode {
    final map = _normalizeMap(toMap());
    return Object.hashAll([
      runtimeType,
      ...map.entries.map((e) => Object.hash(e.key, _deepHash(e.value))),
    ]);
  }

  // @override
  // bool operator ==(Object other) {
  //   developer
  //       .log('9PREMIER - Comparando $runtimeType con ${other.runtimeType}');
  //   developer.log('9PREMIER - Comparando IDENTICAL ${identical(this, other)}');

  //   if (identical(this, other)) return true;
  //   if (other.runtimeType != runtimeType) return false;

  //   final thisMap = toMap();
  //   final otherMap = (other as CommonModel<T>).toMap();

  //   for (final key in thisMap.keys) {
  //     if (thisMap[key] != otherMap[key]) return false;
  //   }
  //   return true;
  // }

  // @override
  // int get hashCode => Object.hashAll([
  //       runtimeType,
  //       ...toMap().entries.map((e) => Object.hash(e.key, e.value))
  //     ]);

  Map<String, dynamic> _normalizeMap(Map<String, dynamic> map) {
    return Map.fromEntries(
      map.entries.map((e) => MapEntry(e.key, _normalizeValue(e.value))),
    );
  }

  static Map<String, dynamic> normalizeMap(Map<String, dynamic> map) {
    return Map.fromEntries(
      map.entries.map((e) => MapEntry(e.key, normalizeValue(e.value))),
    );
  }

  dynamic _normalizeValue(dynamic value) {
    if (value is CommonModel) return _normalizeMap(value.toMap());
    if (value is DateTime) return value.toUtc().millisecondsSinceEpoch;
    if (value is Map) {
      return Map.fromEntries(
        value.entries.map((e) => MapEntry(e.key, _normalizeValue(e.value))),
      );
    }
    if (value is List) {
      return value.map(_normalizeValue).toList();
    }
    return value;
  }

  static dynamic normalizeValue(dynamic value) {
    if (value is CommonModel) return normalizeMap(value.toMap());
    if (value is DateTime) return value.toUtc().millisecondsSinceEpoch;
    if (value is Map) {
      return Map.fromEntries(
        value.entries.map((e) => MapEntry(e.key, normalizeValue(e.value))),
      );
    }
    if (value is List) {
      return value.map(normalizeValue).toList();
    }
    return value;
  }

  bool _deepEquals(dynamic a, dynamic b) {
    if (a is Map && b is Map) {
      return a.length == b.length &&
          a.keys.every((k) => _deepEquals(a[k], b[k]));
    } else if (a is List && b is List) {
      return a.length == b.length &&
          Iterable.generate(a.length).every((i) => _deepEquals(a[i], b[i]));
    } else {
      return a == b;
    }
  }

  static bool deepEquals(dynamic a, dynamic b) {
    if (a is Map && b is Map) {
      return a.length == b.length &&
          a.keys.every((k) => deepEquals(a[k], b[k]));
    } else if (a is List && b is List) {
      return a.length == b.length &&
          Iterable.generate(a.length).every((i) => deepEquals(a[i], b[i]));
    } else {
      return a == b;
    }
  }

  int _deepHash(dynamic value) {
    if (value is Map) {
      return Object.hashAll(
          value.entries.map((e) => Object.hash(e.key, _deepHash(e.value))));
    }
    if (value is List) {
      return Object.hashAll(value.map(_deepHash));
    }
    if (value is DateTime) {
      return value.toUtc().millisecondsSinceEpoch.hashCode;
    }
    if (value is CommonModel) {
      return value.hashCode;
    }
    return value.hashCode;
  }

  static int deepHash(dynamic value) {
    if (value is Map) {
      return Object.hashAll(
          value.entries.map((e) => Object.hash(e.key, deepHash(e.value))));
    }
    if (value is List) {
      return Object.hashAll(value.map(deepHash));
    }
    if (value is DateTime) {
      return value.toUtc().millisecondsSinceEpoch.hashCode;
    }
    if (value is CommonModel) {
      return value.hashCode;
    }
    return value.hashCode;
  }
}
