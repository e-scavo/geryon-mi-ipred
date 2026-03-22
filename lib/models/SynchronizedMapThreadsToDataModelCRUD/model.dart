import 'package:geryon_web_app_ws_v2/models/error_handler.dart';
import 'package:synchronized/synchronized.dart';

/// Version 2 of Synchronized Map CRUD
///
class SynchronizedMapThreadsToDataModelCRUD<K, V> {
  static const className = 'SynchronizedMapThreadsToDataModelCRUD';
  final _lock = Lock();
  final Map<K, V> _map = {};

  SynchronizedMapThreadsToDataModelCRUD();

  // Create or Update an item in the map
  Future<void> set({
    required K key,
    required V value,
  }) async {
    await _lock.synchronized(() async {
      if (_map[key] == null) {
        _map[key] = value;
      }
    });
  }

  /// Read an item from the map
  /// or Throw
  ///
  V get(K key) {
    const functionName = 'get';
    if (_map[key] == null) {
      throw ErrorHandler(
        errorCode: 700,
        errorDsc: 'Thread ID doesn\'t exists.',
        className: className,
        functionName: functionName,
        propertyName: 'threadID',
        propertyValue: key.toString(),
        stacktrace: StackTrace.current,
      );
    } else {
      return _map[key]!;
    }
  }

  // Future<void> status(K key, String status) async {
  //   await _lock.synchronized(() async {
  //     _map[key]?.status = status;
  //   });
  // }

  int get length => _map.length;

  // bool hasCallback(K key) {
  //   V? v = get(key);
  //   return v?.callbackFunction != null;
  // }

  // Read the callBackFunction, if any, from the map
  // Future<bool> execute({
  //   required K key,
  //   required String pMessageID,
  //   required dynamic paramCallBack,
  // }) async {
  //   print('callback v2 - 1: ${key.toString()} - ${paramCallBack.toString()}');
  //   try {
  //     if (hasCallback(key)) {
  //       _map[key]!.callbackFunction!(
  //         pFromCallback: true,
  //         pMessageID: pMessageID,
  //         pParams: paramCallBack,
  //       );
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e, stackTace) {
  //     print('callback v2: error: ${e.toString()} - stack: ${stackTace}');
  //     return false;
  //   }
  // }

  // Delete an item from the map
  Future<V?> remove(K key) async {
    return await _lock.synchronized(() async {
      return _map.remove(key);
    });
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    _map.forEach((key, value) {
      map[key as String] = value;
    });
    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  dispose() {
    _map.clear();
  }
}
