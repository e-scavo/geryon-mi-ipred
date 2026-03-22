// import 'dart:developer' as developer;

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geryon_erp_app/data/const_buttons.dart';
// import 'package:geryon_erp_app/data/error_handler.dart';
// import 'package:geryon_erp_app/data/message_confirmation.dart';
// import 'package:geryon_erp_app/models/common/CommonFormField/common_form_field.dart';
// import 'package:geryon_erp_app/models/common/CommonParamKeyValue/common_param_key_value.dart';
// import 'package:geryon_erp_app/models/service_provider.dart';
// import 'package:geryon_erp_app/models/services_provider_config/model.dart';
// import 'package:geryon_erp_app/models/tbl_DetEmailsClientes/model.dart';
// import 'package:geryon_erp_app/screens/utils/CatchMainScreen/widget.dart';
// import 'package:geryon_erp_app/screens/utils/LoadingGeneric/widget.dart';
// import 'package:geryon_erp_app/screens/utils/child_popup_confirm_action_message.dart';
// import 'package:geryon_erp_app/screens/utils/child_popup_error_message.dart';

// class ServiceProviderConfigUpdateScreen extends ConsumerStatefulWidget {
//   static const String className = "ServiceProviderConfigUpdateScreen";
//   static const String logClassName = ".::$className::.";
//   final double pScreenMaxWidth;
//   final double pScreenMaxHeight;

//   const ServiceProviderConfigUpdateScreen({
//     required this.pScreenMaxWidth,
//     required this.pScreenMaxHeight,
//     super.key,
//   });

//   @override
//   ConsumerState<ServiceProviderConfigUpdateScreen> createState() =>
//       _ServiceProviderConfigUpdateScreenState();
// }

// class _ServiceProviderConfigUpdateScreenState
//     extends ConsumerState<ServiceProviderConfigUpdateScreen>
//     with TickerProviderStateMixin {
//   static String className = "_ServiceProviderConfigUpdateScreenState";
//   static String logClassName = ".::$className::.";

//   final keyboardListener = CommonFormField();
//   bool debug = false;

//   late bool loading;
//   late bool isInit;
//   late double screenMaxWidth;
//   late double screenMaxHeight;
//   late String lWindowTitle;
//   late final ScrollController mainScroller;
//   late final ScrollController mainCatchScroller;
//   late final ScrollController secondScroller;
//   late final ScrollController secondCatchScroller;
//   late final double roughScreenMaxWidth;
//   late final double roughScreenMaxHeight;
//   late TableDetEmailsClientesModel pEnteModel;
//   late TabController tabController;
//   bool showSaveButton = false;

//   final protocolType = CommonFormField();
//   late CommonParamKeyValue pProtocolType;
//   List<CommonParamKeyValue> pProtocolTypeList = [
//     CommonParamKeyValue.fromStandard(
//       key: 'wss',
//       value: "wss",
//       title: "wss",
//     ),
//   ];
//   final pAddress = CommonFormField();
//   final pPort = CommonFormField();
//   final pPath = CommonFormField();
//   final pDebug = CommonFormField();

//   final pChainConnection = CommonFormField();

//   late ServiceProviderConfigModel pServiceProviderConfigModel;

//   @override
//   void initState() {
//     super.initState();
//     lWindowTitle = 'CONFIGURACIÓN AL BACK-END';

//     debug = ref.read(notifierServiceProvider).debug;
//     loading = true;
//     isInit = true;
//     mainScroller = ScrollController();
//     mainCatchScroller = ScrollController();
//     secondScroller = ScrollController();
//     secondCatchScroller = ScrollController();
//     screenMaxWidth = widget.pScreenMaxWidth;
//     screenMaxHeight = widget.pScreenMaxHeight;
//     roughScreenMaxWidth = widget.pScreenMaxWidth;
//     roughScreenMaxHeight = widget.pScreenMaxHeight;
//     tabController = TabController(
//       length: 1,
//       vsync: this,
//     );

//     _preInitWork();

//     /// Register a callback to execute a function after the widget is built.
//     ///
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   //_preInitWork();
//     // });
//   }

//   @override
//   void dispose() {
//     keyboardListener.dispose();
//     protocolType.dispose();
//     pAddress.dispose();
//     pPort.dispose();
//     pPath.dispose();
//     pDebug.dispose();
//     pChainConnection.dispose();

//     super.dispose();
//   }

//   void _preInitWork() async {
//     const String functionName = '_preInitWork';
//     try {
//       setState(() {
//         loading = true;
//         isInit = true;
//       });
//       setState(() {
//         isInit = false;
//       });
//       _initWork();
//     } catch (e, stacktrace) {
//       developer
//           .log('$logClassName - $functionName - CATCHED - $e - $stacktrace');
//       if (!mounted) {
//         return;
//       }

//       /// Register a callback to execute a function after the widget is built.
//       ///
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         await Navigator.of(context).push(ModelGeneralPoPUpErrorMessageDialog(
//             error: ErrorHandler(
//           errorCode: 99999,
//           errorDsc: '''Se produjo un error al inicializar el procedimiento.
//               Error: ${e.toString()}
//               ''',
//           className: className,
//           functionName: functionName,
//           stacktrace: stacktrace,
//         )));
//         if (!mounted) {
//           return;
//         }
//         if (Navigator.canPop(context)) {
//           Navigator.pop(context);
//         }
//         return;
//       });
//     }
//   }

//   void _initWork() async {
//     String functionName = "_initWork";
//     try {
//       setState(() {
//         loading = true;
//       });
//       var wssUri = ref.read(notifierServiceProvider).wssURI;
//       var loadConfig = await ServiceProviderConfigModel.loadConfig(wssUri);
//       setState(() {
//         pServiceProviderConfigModel = loadConfig;
//         loading = false;
//       });
//       return;
//     } catch (e, stacktrace) {
//       developer
//           .log('$logClassName - $functionName - CATCHED - $e - $stacktrace');

//       /// Register a callback to execute a function after the widget is built.
//       ///
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         await Navigator.of(context).push(ModelGeneralPoPUpErrorMessageDialog(
//             error: ErrorHandler(
//           errorCode: 99999,
//           errorDsc: '''Se produjo un error al inicializar el procedimiento.
//               Error: ${e.toString()}
//               ''',
//           className: className,
//           functionName: functionName,
//           stacktrace: stacktrace,
//         )));
//         if (!mounted) {
//           return;
//         }
//         if (Navigator.canPop(context)) {
//           Navigator.pop(context);
//         }
//         return;
//       });
//     }
//   }

//   /// Process the save button
//   ///
//   Future<void> _doSave({
//     bool askConfirmation = false,
//   }) async {
//     bool didWeChange = true;
//     if (didWeChange && !askConfirmation) {
//       /// I must ask before saving
//       ///
//       var rConfirm = await Navigator.of(context).push(
//         ModelGeneralPoPUpConfirmMessageDialog(
//           message: MessageHandler(
//               msgCode: 0,
//               msgDsc: '''¿Está seguro que desea guardar los cambios?
//                   Esto implica la modificación de los parámetros de conexión al back-end.
//                   [CONFIGURACIÓN AVANZADA]
//                   ''',
//               msgTitle: '¿Desea continuar?'),
//         ),
//       );
//       if (!mounted) {
//         return;
//       }
//       if (rConfirm != AppConstButtons.buttonYes) {
//         return;
//       }
//     }
//     var rSave = await ServiceProviderConfigModel.saveConfig(
//       pServiceProviderConfigModel,
//     );
//     if (!mounted) {
//       return;
//     }
//     if (rSave.errorCode != 0) {
//       await Navigator.of(context).push(
//         ModelGeneralPoPUpErrorMessageDialog(
//           error: rSave,
//         ),
//       );
//       return;
//     }
//     //RestartableApp.restartApp(context);
//     // Limpiá estados importantes
//     ref.invalidate(serviceProviderConfigProvider);
//     ref.invalidate(notifierServiceProvider);
//     // Agregá más si hace falta...

//     // Volvé al home
//     Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
//     // if (cancel || !didWeChange || force) {
//     //   if (Navigator.canPop(context)) {
//     //     Navigator.of(context).pop(null);
//     //   }
//     // }
//   }

//   /// Process the cancel button
//   ///
//   _doCancel({
//     bool force = false,
//     bool byError = false,
//     askConfirmation = true,
//   }) async {
//     /// I must check if there are changes before cancelling.
//     /// If there are changes, then I MUST ask if we want to cancel
//     ///
//     if (force && byError) {
//       if (Navigator.canPop(context)) {
//         Navigator.of(context).pop(null);
//       }
//       return;
//     }
//     bool cancel = false;
//     bool didWeChange = true;
//     if (didWeChange && !force) {
//       /// I must ask before cancel
//       ///
//       var rConfirm = await Navigator.of(context).push(
//         ModelGeneralPoPUpConfirmMessageDialog(
//           message: MessageHandler(
//               msgCode: 0,
//               msgDsc:
//                   '¿Está seguro que desea cancelar?\r\nSe perderán los cambios.',
//               msgTitle: '¿Desea cancelar?'),
//         ),
//       );
//       if (!mounted) {
//         return;
//       }
//       if (rConfirm == AppConstButtons.buttonYes) {
//         cancel = true;
//       }
//     }
//     if (cancel || !didWeChange || force) {
//       if (Navigator.canPop(context)) {
//         Navigator.of(context).pop(null);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String locFunc = "$logClassName - .::BUILD::.";
//     double devScreenWidth = MediaQuery.of(context).size.width;
//     double devScreenHeight = MediaQuery.of(context).size.height;
//     if (debug) {
//       developer.log(
//           '$locFunc - WidgetWidthHeight:[${widget.pScreenMaxWidth}/${widget.pScreenMaxHeight}]');
//       developer.log(
//           '$locFunc - MediaQueryWidthHeight:[$devScreenWidth/$devScreenHeight]');
//     }
//     try {
//       var rReturn = LayoutBuilder(
//         builder: (context, constraints) {
//           String locLayoutFunc = '$locFunc - .::LayoutBuilder::.';
//           double layHeight = constraints.maxHeight;
//           double layWidth = constraints.maxWidth;
//           if (debug) {
//             developer.log(
//                 '$locLayoutFunc - LayoutWidthHeight:[$layWidth/$layHeight]');
//           }

//           double titleHeight = 30;
//           double bodyHeight = layHeight - titleHeight;
//           if (debug) {
//             developer.log(
//                 '$locLayoutFunc - TitleHeight[$titleHeight] - BodyHeight[$bodyHeight]');
//           }
//           try {
//             if (!loading) {
//               /// Establezco valores
//               ///
//               pProtocolType = pProtocolTypeList.firstWhere(
//                 (element) => element.key == pServiceProviderConfigModel.tipo,
//                 orElse: () {
//                   var first = pProtocolTypeList.first;
//                   pServiceProviderConfigModel.tipo = first.key;
//                   developer.log(
//                       'GetDataDebug: Tipo: ${pServiceProviderConfigModel.tipo} ');
//                   return first;
//                 },
//               );
//               pAddress.controller.text = pServiceProviderConfigModel.address;
//               pPort.controller.text =
//                   pServiceProviderConfigModel.port.toString();
//               pPath.controller.text = pServiceProviderConfigModel.path;
//               pDebug.controller.text =
//                   pServiceProviderConfigModel.debug.toString();
//               pDebug.flag1 = pServiceProviderConfigModel.debug;
//               pChainConnection.excludeFocus = true;
//               pChainConnection.absorbPointer = true;
//               pChainConnection.controller.text =
//                   pServiceProviderConfigModel.uri();
//             }
//             return _buildMainScreen(
//               constraints,
//               locFunc: locFunc,
//             );
//           } catch (e, stacktrace) {
//             return CatchMainScreen(
//               locFunc: locFunc,
//               constraints: constraints,
//               e: e,
//               stacktrace: stacktrace,
//               debug: debug,
//               pScreenMaxHeight: screenMaxHeight,
//               pScreenMaxWidth: screenMaxWidth,
//             );
//           }
//         },
//       );
//       return rReturn;
//     } catch (e, stacktrace) {
//       BoxConstraints constraints = BoxConstraints(
//         maxHeight: widget.pScreenMaxHeight,
//         maxWidth: widget.pScreenMaxWidth,
//       );
//       return CatchMainScreen(
//         locFunc: locFunc,
//         constraints: constraints,
//         e: e,
//         stacktrace: stacktrace,
//         debug: debug,
//         pScreenMaxHeight: screenMaxHeight,
//         pScreenMaxWidth: screenMaxWidth,
//       );
//     }
//   }

//   _buildGeneralTab(
//     BoxConstraints constraints, {
//     required String locFunc,
//   }) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             dragStartBehavior: DragStartBehavior.start,
//             child: Scrollbar(
//               controller: secondScroller,
//               thumbVisibility: true,
//               child: SizedBox(
//                 child: SingleChildScrollView(
//                   controller: secondScroller,
//                   scrollDirection: Axis.vertical,
//                   dragStartBehavior: DragStartBehavior.start,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           /// TipoConexión
//                           SizedBox(
//                             width: 130,
//                             height: 50,
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(
//                                 4,
//                                 4,
//                                 4,
//                                 4,
//                               ),
//                               child: AbsorbPointer(
//                                 absorbing: protocolType.readOnly,
//                                 child: DropdownSearch<CommonParamKeyValue>(
//                                   itemAsString: (item) => item.value,
//                                   popupProps: PopupProps.menu(
//                                     itemBuilder: CommonParamKeyValue
//                                         .sStandardPopupItemBuilderCommonParamKeyValue,
//                                     isFilterOnline: false,
//                                     showSearchBox: true,
//                                     searchFieldProps: TextFieldProps(
//                                       controller: protocolType.controller,
//                                       decoration: InputDecoration(
//                                         suffixIcon: IconButton(
//                                           onPressed: () {
//                                             protocolType.controller.clear();
//                                           },
//                                           icon: const Icon(Icons.clear),
//                                         ),
//                                       ),
//                                     ),
//                                     showSelectedItems: true,
//                                   ),
//                                   clearButtonProps: ClearButtonProps(
//                                     isVisible: false,
//                                     onPressed: () {
//                                       setState(() {
//                                         pProtocolType = pProtocolTypeList.first;
//                                         pServiceProviderConfigModel.tipo =
//                                             pProtocolType.key;
//                                       });
//                                     },
//                                   ),
//                                   //asyncItems:
//                                   compareFn: (item1, item2) => item1 == item2,
//                                   dropdownDecoratorProps:
//                                       DropDownDecoratorProps(
//                                     dropdownSearchDecoration: InputDecoration(
//                                       border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(3)),
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                       ),
//                                       labelText: "Tipo de Conexión",
//                                       labelStyle: const TextStyle(
//                                         fontSize: 13,
//                                       ),
//                                       hintText: "Buscar",
//                                       hintStyle: const TextStyle(
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                   selectedItem: pProtocolType,
//                                   onChanged: (value) {
//                                     if (value == null) {
//                                       return;
//                                     }
//                                     setState(() {
//                                       pProtocolType = pProtocolTypeList.first;
//                                       pServiceProviderConfigModel.tipo =
//                                           pProtocolType.key;
//                                     });
//                                   },
//                                   items: pProtocolTypeList,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       /// URL
//                       Row(
//                         children: [
//                           AbsorbPointer(
//                             absorbing: pAddress.readOnly,
//                             child: SizedBox(
//                               width: 200,
//                               height: 50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: TextFormField(
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     height: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   readOnly: pAddress.readOnly,
//                                   textAlign: TextAlign.end,
//                                   controller: pAddress.controller,
//                                   focusNode: pAddress.focusNode,
//                                   decoration: const InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Dirección',
//                                   ),
//                                   onChanged: (value) {
//                                     pAddress.handleTextFieldChange2<String>(
//                                       controller: pAddress.controller,
//                                       focusNode: pAddress.focusNode,
//                                       newValue: value,
//                                       onValidTextChange: (newValue) {
//                                         setState(() {
//                                           pServiceProviderConfigModel.address =
//                                               newValue;

//                                           pAddress.controller.text =
//                                               pServiceProviderConfigModel
//                                                   .address;
//                                         });
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       /// Puerto
//                       Row(
//                         children: [
//                           AbsorbPointer(
//                             absorbing: pPort.readOnly,
//                             child: SizedBox(
//                               width: 130,
//                               height: 50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: TextFormField(
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     height: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   readOnly: pPort.readOnly,
//                                   textAlign: TextAlign.end,
//                                   controller: pPort.controller,
//                                   focusNode: pPort.focusNode,
//                                   decoration: const InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Puerto',
//                                   ),
//                                   onChanged: (value) {
//                                     pPort.handleTextFieldChange2<int>(
//                                       controller: pPort.controller,
//                                       focusNode: pPort.focusNode,
//                                       newValue: value,
//                                       onValidTextChange: (newValue) {
//                                         setState(() {
//                                           pServiceProviderConfigModel.port =
//                                               int.parse(newValue.toString());
//                                           pPort.controller.text =
//                                               pServiceProviderConfigModel.port
//                                                   .toString();
//                                         });
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       /// Path
//                       Row(
//                         children: [
//                           AbsorbPointer(
//                             absorbing: pPath.readOnly,
//                             child: SizedBox(
//                               width: 130,
//                               height: 50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: TextFormField(
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     height: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   readOnly: pPath.readOnly,
//                                   textAlign: TextAlign.end,
//                                   controller: pPath.controller,
//                                   focusNode: pPath.focusNode,
//                                   decoration: const InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Path',
//                                   ),
//                                   onChanged: (value) {
//                                     pPath.handleTextFieldChange2<String>(
//                                       controller: pPath.controller,
//                                       focusNode: pPath.focusNode,
//                                       newValue: value,
//                                       onValidTextChange: (newValue) {
//                                         setState(() {
//                                           pServiceProviderConfigModel.path =
//                                               newValue;

//                                           pPath.controller.text =
//                                               pServiceProviderConfigModel.path;
//                                         });
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       /// Debug
//                       Row(
//                         children: [
//                           ExcludeFocus(
//                             excluding: pDebug.excludeFocus,
//                             child: AbsorbPointer(
//                               absorbing: pDebug.absorbPointer,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.transparent,
//                                 ),
//                                 width: 250,
//                                 child: SwitchListTile(
//                                   title: const Text(
//                                     'DEPURAR',
//                                     //style: TextStyle(fontSize: 14),
//                                   ),
//                                   focusNode: pDebug.focusNode,
//                                   value: pDebug.flag1,
//                                   onChanged: (bool value) {
//                                     setState(() {
//                                       pServiceProviderConfigModel.debug = value;
//                                       pDebug.controller.text =
//                                           pServiceProviderConfigModel.debug
//                                               .toString();
//                                     });
//                                   },
//                                   secondary: const Icon(Icons.devices_other),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           ExcludeFocus(
//                             excluding: pChainConnection.excludeFocus,
//                             child: AbsorbPointer(
//                               absorbing: pChainConnection.absorbPointer,
//                               child: SizedBox(
//                                 width: constraints.maxWidth - 4 - 4,
//                                 height: 50,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: TextFormField(
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       height: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     readOnly: pChainConnection.readOnly,
//                                     textAlign: TextAlign.end,
//                                     controller: pChainConnection.controller,
//                                     focusNode: pChainConnection.focusNode,
//                                     decoration: const InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       labelText: 'URI de conexión',
//                                     ),
//                                     onChanged: null,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           _crudsButtons(
//                             constraints,
//                             locFunc: locFunc,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   _crudsButtons(
//     BoxConstraints constraints, {
//     required String locFunc,
//   }) {
//     ///
//     ///
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//       ),
//       height: 100,
//       width: constraints.maxWidth - 4 - 4,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           SizedBox(
//             height: 90,
//             width: 90,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(90, 90),
//                 maximumSize: Size(90, 90),
//                 elevation: 5.0,
//                 padding: EdgeInsets.zero,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//               child: const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.save,
//                   ),
//                   Text(
//                     'Guardar',
//                     style: TextStyle(
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               onPressed: () async => await _doSave(
//                 askConfirmation: true,
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           SizedBox(
//             height: 90,
//             width: 90,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(90, 90),
//                 maximumSize: Size(90, 90),
//                 elevation: 5.0,
//                 padding: EdgeInsets.zero,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//               child: const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.cancel,
//                   ),
//                   Text(
//                     'Cancelar',
//                     style: TextStyle(
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               onPressed: () async => await _doCancel(
//                 askConfirmation: true,
//               ),
//             ),
//           ),

//           /// Separador
//           const SizedBox(
//             width: 5,
//           ),
//         ],
//       ),
//     );
//   }

//   _buildMainScreen(
//     BoxConstraints constraints, {
//     required String locFunc,
//   }) {
//     //String lockFunc2 = '$locFunc - .::_buildMainScreen::.';
//     final themeData = Theme.of(context);
//     double titleHeight = 30;
//     double bodyHeight = constraints.maxHeight - 4 - 4 - titleHeight;
//     //double bodyHeight = screenMaxHeight - 4 - 4 - titleHeight;
//     double bodyWidth = constraints.maxWidth - 4 - 4;
//     var rMainScreen = loading
//         ? LoadingGeneric()
//         : Scrollbar(
//             controller: mainScroller,
//             thumbVisibility: true,
//             child: Card(
//               semanticContainer: true,
//               child: Column(
//                 //mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   /// Header Title
//                   ///
//                   Container(
//                     decoration: BoxDecoration(
//                       color: themeData.primaryColor,
//                       border: Border(
//                         bottom: BorderSide(
//                           color: themeData.primaryColorDark,
//                         ),
//                       ),
//                     ),
//                     height: titleHeight,
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: RichText(
//                             textAlign: TextAlign.start,
//                             text: TextSpan(
//                               text: lWindowTitle,
//                               style: const TextStyle(
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             )),
//                       ),
//                     ),
//                   ),

//                   /// Body
//                   ///
//                   SizedBox(
//                     height: bodyHeight,
//                     width: bodyWidth,
//                     child: SingleChildScrollView(
//                       controller: mainScroller,
//                       scrollDirection: Axis.horizontal,
//                       dragStartBehavior: DragStartBehavior.start,
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           minWidth: bodyWidth,
//                           minHeight: bodyHeight,
//                           maxWidth: bodyWidth,
//                           maxHeight: bodyHeight,
//                         ),
//                         child: SizedBox(
//                           height: bodyHeight,
//                           width: bodyWidth,
//                           child: _buildGeneralTab(
//                             constraints,
//                             locFunc: locFunc,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//     return rMainScreen;
//   }
// }
