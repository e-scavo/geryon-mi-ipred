import 'dart:developer' as developer;

import 'package:flutter/material.dart';

/// PopUpScreen (optional)
///
class PopUpServiceProviderConfigUpdateScreen extends PopupRoute {
  final String className = "PopUpServiceProviderConfigUpdateScreen";

  PopUpServiceProviderConfigUpdateScreen();

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  // This allows the popup to be dismissed by tapping the scrim or by pressing
  // the escape key on the keyboard.
  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'Dismissible Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  double screenMaxWidth = 640;
  double screenMaxHeight = 480;

  ScrollController popUpMainScrollController = ScrollController();
  ScrollController popUpSecondScrollController = ScrollController();

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    const String funcLoc = ".::BUILD::.";
    double mediaQueryWidth = MediaQuery.of(context).size.width;
    double mediaQueryHeight = MediaQuery.of(context).size.height - 4 - 4;
    developer.log(
        '$className - $funcLoc - MediaQuery[Width=$mediaQueryWidth|Height:$mediaQueryHeight]');
    developer.log(
        '$className - $funcLoc - Screen[Width=$screenMaxWidth|Height:$screenMaxHeight]');
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          // decoration: BoxDecoration(
          //   //color: Colors.black12.withOpacity(0.025),
          //   color: Colors.green.shade300,
          // ),
          width: screenMaxWidth,
          height: screenMaxHeight,
          child: SizedBox(
            width: screenMaxWidth,
            height: screenMaxHeight,
            child: Container(),
            // child: ServiceProviderConfigUpdateScreen(
            //   pScreenMaxWidth: screenMaxWidth,
            //   pScreenMaxHeight: screenMaxHeight,
            // ),
          ),
        ),
      ),
    );
  }
}
