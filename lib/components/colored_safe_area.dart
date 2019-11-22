import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A safe area with color
class ColoredSafeArea extends StatelessWidget {
  final Color color;
  final Widget child;

  ColoredSafeArea({
    Key key,
    @required this.color,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: SafeArea(
        child: child,
      ),
    );
  }
}
