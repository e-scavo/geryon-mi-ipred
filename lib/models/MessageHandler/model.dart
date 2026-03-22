class MessageHandler {
  int msgCode;
  String? msgDsc;
  String? msgTitle;
  dynamic data;
  late bool byDefault;

  MessageHandler({
    this.msgCode = 0,
    this.msgDsc,
    this.data,
    this.msgTitle,
    this.byDefault = false,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['msg_code'] = msgCode;
    map['msg_dsc'] = msgDsc;
    map['msg_title'] = msgTitle;
    map['data'] = data;
    map['by_default'] = byDefault;
    return map;
  }

  @override
  String toString() {
    // ToDo: implement toString
    return toMap().toString();
  }
}
