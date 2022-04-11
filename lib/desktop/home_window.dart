import 'dart:math' as math;
import 'package:bolgmarkdown/desktop/content_view.dart';
import 'package:flutter/material.dart';


class HomeWindow extends StatelessWidget {
  const HomeWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ClipRect(
      child: _OverflowBox(
        child: Material(
          child:ContentView()
        ),
      ),
    );
  }
}

class _OverflowBox extends StatelessWidget {
  const _OverflowBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxHeight = math.max(constraints.maxHeight, 840.0);
      final maxWidth = math.max(constraints.maxWidth, 1000.0);
      return OverflowBox(
        minHeight: 840,
        maxHeight: maxHeight,
        minWidth: 1000,
        maxWidth: maxWidth,
        child: child,
      );
    });
  }
}
