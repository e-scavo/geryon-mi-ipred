import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

class ServiceProviderChannel {
  late String name;
  late bool isSubscribed;
  late ErrorHandler? status;

  ServiceProviderChannel({
    required this.name,
    this.isSubscribed = false,
  }) {
    status = null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['is_subsribed'] = isSubscribed;
    map['status'] = status;
    return map;
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  ServiceProviderChannel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    isSubscribed = map['is_subscribed'];
    status = map['status'];
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
