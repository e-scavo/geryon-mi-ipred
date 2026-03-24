import 'package:flutter/material.dart';

class ShakeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;

  const ShakeTextField({
    super.key,
    required this.controller,
    this.hintText,
  });

  @override
  State<ShakeTextField> createState() => ShakeTextFieldState();
}

class ShakeTextFieldState extends State<ShakeTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Container(
          transform: Matrix4.translationValues(_offsetAnimation.value, 0, 0),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(hintText: widget.hintText),
          ),
        );
      },
    );
  }
}
