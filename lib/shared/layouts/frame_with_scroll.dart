import 'package:flutter/material.dart';

class FrameWithScroll extends StatelessWidget {
  final Widget pBody;

  const FrameWithScroll({
    super.key,
    required this.pBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              primary: true,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: pBody,
              ),
            ),
          ),
        );
      },
    );
  }
}
