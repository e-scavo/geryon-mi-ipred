import 'package:flutter/material.dart';

class WindowModel {
  final String title;
  final Color titleColorBackground;
  final Widget? headerWidget;
  final Widget? bodyWidget;
  final BoxConstraints constraints;

  WindowModel({
    required this.title,
    this.constraints = const BoxConstraints.tightFor(width: 400, height: 400),
    this.titleColorBackground = Colors.black45,
    this.headerWidget,
    this.bodyWidget,
  });
}
