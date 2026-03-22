import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/models/CommonRPCMessageResponse/common_rpc_message_response.dart';
import 'package:geryon_web_app_ws_v2/models/MessageHandler/model.dart';
import 'package:geryon_web_app_ws_v2/models/ScreenGeneralWorkInProgress/countdown_timer.dart';
import 'package:geryon_web_app_ws_v2/models/ScreenGeneralWorkInProgress/error_widget.dart';
import 'package:geryon_web_app_ws_v2/models/ScreenGeneralWorkInProgress/progress_widget.dart';
import 'package:geryon_web_app_ws_v2/models/const_buttons.dart';

class ScreenGeneralWorkInProgress extends ConsumerStatefulWidget {
  final String messageID;
  const ScreenGeneralWorkInProgress({
    required this.messageID,
    super.key,
  });

  @override
  ConsumerState<ScreenGeneralWorkInProgress> createState() =>
      _ScreenGeneralWorkInProgressState();
}

class _ScreenGeneralWorkInProgressState
    extends ConsumerState<ScreenGeneralWorkInProgress> {
  bool? isProcessRunning;

  @override
  void initState() {
    super.initState();

    var messageStatus = ref
        .read(notifierServiceProvider)
        .wssMessagesTrackingV2
        .get(widget.messageID);
    if (messageStatus != null) {
      developer.log(
        'WorkInProgressPopUp - initState1: ${messageStatus.isWorkInProgress}',
        name: 'ScreenGeneralWorkInProgressProgressMessageDialog',
      );
      messageStatus.isWorkInProgress = true;
      developer.log(
        'WorkInProgressPopUp - initState2: ${messageStatus.isWorkInProgress}',
        name: 'ScreenGeneralWorkInProgressProgressMessageDialog',
      );
    }

    /// Register a callback to execute a function after the widget is built.
    ///
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call your function here.
      isProcessRunning = true;
      initWork();
    });
  }

  Future<Object?> initWork() async {
    return null;
  }

  _buildWindowBody(CommonRPCMessageResponse messageStatus) {
    var rFinalMessage = messageStatus.finalResponse;
    switch (messageStatus.status) {
      case 'ok':
        if (rFinalMessage.errorCode > 0) {
          developer.log(
            'WorkInProgressPopUp - ErrorCode > 0',
            name: 'ScreenGeneralWorkInProgressProgressMessageDialog',
          );
          return ScreenGeneralWorkInProgressErrorMessageDialog(
            error: messageStatus.finalResponse,
          );
        } else if (rFinalMessage.errorCode == 0) {
          // ErrorCode == 0
          developer.log(
            'WorkInProgressPopUp - ErrorCode == 0',
            name: 'ScreenGeneralWorkInProgressProgressMessageDialog',
          );
          return ScreenGeneralWorkInProgressCountDownTimerMessageDialog(
            messageStatus: messageStatus,
            message: MessageHandler(
              msgCode: 0,
              msgDsc: rFinalMessage.errorDsc,
              msgTitle: 'Comprobante cancelado',
            ),
            maxTicks: 5,
            backwards: true,
          );
        } else {
          // ErrorCode < 0
          developer.log(
            'WorkInProgressPopUp - ErrorCode < 0: ${rFinalMessage.errorCode}',
            name: 'ScreenGeneralWorkInProgressProgressMessageDialog',
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(rFinalMessage.errorCode);
          }
        }
      default:
        return ScreenGeneralWorkInProgressProgressMessageDialog(
          messageStatus: messageStatus,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// I rebuilt the widget everytime its status changes
    ///
    final messageStatus = ref
        .watch(notifierServiceProvider)
        .wssMessagesTrackingV2
        .get(widget.messageID);
    developer.log(
        'WorkInProgressPopUp ${messageStatus?.messageID}-${messageStatus?.showWorkInProgress}-${messageStatus?.isWorkInProgress}');
    Map<String, dynamic> pRequest = {};
    if (messageStatus == null) {
      /// Asumo que si es null el mensaje está en error (por ahora lo muestro y saldo)
      ///
      ///
      Future.delayed(const Duration(seconds: 0), () {
        //await ref.read(widget.GeneralProviderNotifier).params = null;
        //ref.invalidate(widget.GeneralProviderNotifier);
        //ref.refresh(widget.GeneralProviderNotifier).params =              null;
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(messageStatus);
        }
      });
    } else {
      pRequest = messageStatus.pParamsRequest;
    }
    final themeData = Theme.of(context);
    double windowWidth = 720;
    double windowHeight = 480;
    double windowTitle = 30;
    double windowFooter = 30;
    double windowBody = windowHeight - windowTitle - windowFooter;
    String titleMessage = '';
    switch (pRequest["Action"]) {
      case "CancelRequest":
        titleMessage = "CANCELANDO ACCIÓN SOBRE REGISTRO";
        break;
      case "SaveRequest":
        titleMessage = "GUARDANDO REGISTRO";
        break;
      default:
        titleMessage = pRequest["Action"].toString();
    }
    return Visibility(
      visible: true,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        width: windowWidth,
        height: windowHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Header
              ///
              Container(
                decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  borderRadius: const BorderRadiusDirectional.only(
                    topStart: Radius.circular(5),
                    topEnd: Radius.circular(5),
                  ),
                ),
                height: windowTitle,
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: titleMessage,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),

              /// Body
              ///
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.zero,
                    topEnd: Radius.zero,
                    bottomStart: Radius.zero,
                    bottomEnd: Radius.zero,
                  ),
                ),
                height: windowBody,
                child: SizedBox(
                  //height: 200,
                  //width: 600,
                  child: messageStatus != null
                      ? _buildWindowBody(messageStatus)
                      : null,
                ),
              ),

              /// Fotter
              ///
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(5),
                    bottomEnd: Radius.circular(5),
                  ),
                ),
                height: windowFooter,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // await ref
                          //     .read(notifierServiceProvider)
                          //     .wssMessagesTrackingV2
                          //     .remove(messageStatus.messageID);
                          // print(
                          //     'WorkInProgressPopUp - delete message ${messageStatus.messageID}');
                          // var sss = ref
                          //     .read(notifierServiceProvider)
                          //     .wssMessagesTrackingV2
                          //     .get(messageStatus.messageID);
                          // print(
                          //     'WorkInProgressPopUp - after delete message ${sss}');
                          Navigator.of(context).pop(AppConstButtons.buttonOk);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check),
                            Text(
                              'ACEPTAR',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
