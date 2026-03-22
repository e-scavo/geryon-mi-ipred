import 'dart:developer' as developer;

import 'package:geryon_web_app_ws_v2/models/CommonRPCMessageResponse/common_rpc_message_response.dart';
import 'package:synchronized/synchronized.dart';

/// Version 2 of Synchronized Map CRUD
///
class SynchronizedMapV2CRUD<K, V extends CallbackCapable> {
  final _lock = Lock();
  final Map<K, V> _map = {};

  SynchronizedMapV2CRUD();

  // Create or Update an item in the map
  Future<void> set(K key, V value) async {
    await _lock.synchronized(() async {
      _map[key] = value;
    });
  }

  Future<void> status(K key, String status) async {
    try {
      await _lock.synchronized(() async {
        try {
          _map[key]?.status = status;
          // if (!_map.containsKey(key)) {
          //   developer.log(
          //     'status: key not found: $key',
          //     name: 'SynchronizedMapV2CRUD',
          //   );
          //   return;
          // }
        } catch (e, stackTrace) {
          developer.log(
            'status: error checking key: $key',
            name: 'SynchronizedMapV2CRUD',
            error: e,
            stackTrace: stackTrace,
          );
          return;
        }
//      _map[key]?.status = status;
      });
    } catch (e, stackTrace) {
      developer.log(
        'status: error setting status for key: $key',
        name: 'SynchronizedMapV2CRUD',
        error: e,
        stackTrace: stackTrace,
      );
      return;
    }
  }

  // Read an item from the map
  V? get(K key) {
    return _map[key];
  }

  int get length => _map.length;

  bool hasCallback(K key) {
    V? v = get(key);
    return v?.callbackFunction != null;
  }

  // Read the callBackFunction, if any, from the map
  Future<bool> execute({
    required K key,
    required String pMessageID,
    required dynamic paramCallBack,
  }) async {
    if (!_map.containsKey(key)) {
      developer.log(
        'execute: key not found: $key',
        name: 'SynchronizedMapV2CRUD',
      );
      return false;
    }
    try {
      if (hasCallback(key)) {
        _map[key]!.callbackFunction!(
          pFromCallback: true,
          pMessageID: pMessageID,
          pParams: paramCallBack,
        );
        return true;
      } else {
        return false;
      }
    } catch (e, stackTace) {
      developer.log(
        'execute: error executing callback for key: $key',
        name: 'SynchronizedMapV2CRUD',
        error: e,
        stackTrace: stackTace,
      );
      return false;
    }
  }

  // Delete an item from the map
  Future<V?> remove(K key) async {
    try {
      return await _lock.synchronized(() async {
        try {
          if (!_map.containsKey(key)) {
            developer.log(
              'remove: key not found: $key',
              name: 'SynchronizedMapV2CRUD',
            );
            return null;
          }
          return _map.remove(key);
        } catch (e, stackTrace) {
          developer.log(
            'remove: error checking key: $key',
            name: 'SynchronizedMapV2CRUD',
            error: e,
            stackTrace: stackTrace,
          );
          return null;
        }
      });
    } catch (e, stackTrace) {
      developer.log(
        'remove: error removing key: $key',
        name: 'SynchronizedMapV2CRUD',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
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
}
