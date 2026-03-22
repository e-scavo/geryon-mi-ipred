// import 'dart:html';

// class WebSocketService {
//   static const String wsUrl = 'wss://rpc.nfibra.com:19779/ws';
//   static WebSocket? _socket;

//   static Future<void> connect() async {
//     if (_socket != null && _socket!.readyState == WebSocket.OPEN) return;

//     _socket = WebSocket(wsUrl);
//     _socket!.onOpen.listen((_) => print('WebSocket conectado'));
//     _socket!.onError.listen((e) => print('Error WebSocket: \$e'));
//     _socket!.onClose.listen((_) => print('WebSocket cerrado'));
//   }

//   static void send(String message) {
//     if (_socket != null && _socket!.readyState == WebSocket.OPEN) {
//       _socket!.sendString(message);
//     }
//   }

//   static void listen(void Function(String msg) handler) {
//     _socket?.onMessage.listen((MessageEvent e) {
//       handler(e.data as String);
//     });
//   }

//   static void close() {
//     _socket?.close();
//   }
// }
