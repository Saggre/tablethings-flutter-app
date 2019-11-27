import 'package:flutter/material.dart';

enum ButtonIconPosition { beforeText, afterText }

enum DualButtonSeparatorDirection { rightHand, leftHand }

class SingleButtonProperties {
  final IconData iconData;
  final ButtonIconPosition iconPosition;
  final Color iconColor;
  final String text;
  final double spacing;
  final List<Color> colors;
  final double height;
  final BorderRadius borderRadius;
  final TextStyle textStyle;
  final Color shadowColor;
  final Function onPressed;
  final bool enableDragTab;

  const SingleButtonProperties({
    Key key,
    this.iconData,
    this.iconPosition = ButtonIconPosition.afterText,
    this.iconColor = Colors.white,
    @required this.text,
    @required this.colors,
    this.spacing = 10.0,
    this.height = 64.0,
    this.borderRadius = BorderRadius.zero,
    this.onPressed,
    this.shadowColor = Colors.black26,
    @required this.textStyle,
    this.enableDragTab = false,
  });

  SingleButtonProperties copyWith({
    IconData iconData,
    ButtonIconPosition iconPosition,
    Color iconColor,
    String text,
    double spacing,
    Gradient gradient,
    double height,
    BorderRadius borderRadius,
    TextStyle textStyle,
    Function onPressed,
    Color shadowColor,
    bool enableDragTab,
  }) {
    return SingleButtonProperties(
      iconData: iconData ?? this.iconData,
      iconPosition: iconPosition ?? this.iconPosition,
      iconColor: iconColor ?? this.iconColor,
      text: text ?? this.text,
      spacing: spacing ?? this.spacing,
      colors: gradient ?? this.colors,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      onPressed: onPressed ?? this.onPressed,
      shadowColor: shadowColor ?? this.shadowColor,
      enableDragTab: enableDragTab ?? this.enableDragTab,
    );
  }
}

class DualButtonProperties {
  final DualButtonSeparatorDirection separatorDirection;
  final double width;

  const DualButtonProperties({
    this.separatorDirection = DualButtonSeparatorDirection.rightHand,
    this.width = double.infinity,
  });
}
