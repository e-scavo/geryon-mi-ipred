import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/models/CommonRPCMessageResponse/common_rpc_message_response.dart';
import 'package:geryon_web_app_ws_v2/models/const_buttons.dart';

class ScreenGeneralWorkInProgressProgressMessageDialog extends StatefulWidget {
  final CommonRPCMessageResponse messageStatus;

  const ScreenGeneralWorkInProgressProgressMessageDialog({
    required this.messageStatus,
    super.key,
  });

  @override
  State<ScreenGeneralWorkInProgressProgressMessageDialog> createState() =>
      _ScreenGeneralWorkInProgresProgresssMessageDialogState();
}

class _ScreenGeneralWorkInProgresProgresssMessageDialogState
    extends State<ScreenGeneralWorkInProgressProgressMessageDialog> {
  late CommonRPCMessageResponse messageStatus;
  double progressValue = 0.0;
  var progressTimeString = 0.0;
  String status = "";

  @override
  void initState() {
    super.initState();

    messageStatus = widget.messageStatus;
  }

  @override
  Widget build(BuildContext context) {
    switch (messageStatus.status) {
      case 'init':
        status =
            'Petición inicializada. Aguardando a ser enviada al servidor.\r\n';
        break;
      case 'sent':
        status = 'Petición enviada al servidor. Aguardando respuesta.\r\n';
        break;
      case 'queued':
        status =
            'Petición recibida por el servidor y puesta en cola para su procesamiento.\r\nAguardando respuesta.';
        break;
      case 'processing':
        status = 'Respuesta del servidor recibida. Procesando...\r\n';
        break;
      case 'ok':
        status = 'Petición procesada.\r\n';
        break;
      default:
        status =
            'El estado del mensaje es [${messageStatus.status}]. No está programado.\r\n';
    }
    if (messageStatus.status == "ok") {
      // errorCode = messageStatus.finalResponse.errorCode;
      // // errorDsc = messageStatus.finalResponse.errorDsc.toString();
      // // if (errorCode != 0){

      // }

      //if (messageStatus.isWorkInProgress != null) {
      messageStatus.isWorkInProgress = false;
      // if (Navigator.canPop(context)) {
      //   Navigator.of(context).pop(messageStatus);
      // }
      //}
    } else {
      int timeout = messageStatus.timeOut.inMilliseconds;
      int timeElapsed = messageStatus.timeElapsed.inMilliseconds;
      var progressTime = (timeElapsed * 1 / timeout);
      if (progressTime > 1) {
        progressTime = 1;
      }
      progressValue = progressTime;
      var mod = pow(10.0, 2);
      progressTimeString = ((progressValue * mod).truncateToDouble() / mod);
      developer.log(
        'WorkInProgressPopUp _status $timeElapsed/$timeout $progressTimeString',
        name: 'ScreenGeneralWorkInProgressProgressMessageDialog',
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.00, 5.00, 0.00, 5.00),
          child: Center(child: Text(status)),
        ),
        SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.00, 5.00, 5.00, 5.00),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.00, 5.00, 0.00, 5.00),
          child: Text('$progressTimeString %'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.00, 5.00, 0.00, 5.00),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 5),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check),
                Text(
                  'CERRAR EN ERROR',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop(AppConstButtons.buttonClose);
              }
            },
          ),
        ),
      ],
    );
  }
}
