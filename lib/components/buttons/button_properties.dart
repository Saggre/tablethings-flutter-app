import 'package:flutter/material.dart';

enum ButtonIconPosition { beforeText, afterText }

enum DualButtonSeparatorDirection { rightHandTop, rightHandBottom, leftHandTop, leftHandBottom }

class SingleButtonProperties {
  final IconData iconData;
  final ButtonIconPosition iconPosition;
  final Color iconColor;
  final String text;
  final double spacing;
  final Gradient gradient;
  final double height;
  final BorderRadius borderRadius;
  final TextStyle textStyle;
  final Function onPressed;

  const SingleButtonProperties({
    Key key,
    this.iconData,
    this.iconPosition = ButtonIconPosition.afterText,
    this.iconColor = Colors.white,
    @required this.text,
    @required this.gradient,
    this.spacing = 10.0,
    this.height = 64.0,
    this.borderRadius = BorderRadius.zero,
    this.onPressed,
    @required this.textStyle,
  });
}

class DualButtonProperties {
  final DualButtonSeparatorDirection separatorDirection;
  final double width;

  const DualButtonProperties({
    this.separatorDirection = DualButtonSeparatorDirection.leftHandBottom,
    this.width = double.infinity,
  });
}
