import 'package:flutter/material.dart';
import 'package:tablething/models/establishment/cuisine_types.dart';

/// Allows to easily create texts with consistent style (like h1, h2, etc. in css)
class TextFactory {
  static TextStyle h1Style = TextStyle(
    color: Colors.black,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static TextStyle h2Style = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle h3Style = TextStyle(
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.w400,
  );

  static TextStyle h4Style = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static TextStyle pStyle = TextStyle(
    color: Colors.grey[500],
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 20,
    shadows: [
      Shadow(
        blurRadius: 5.0,
        color: Color(0x66000000),
        offset: Offset(0.0, 0.0),
      ),
    ],
  );

  /// For buttons with light background
  static TextStyle lightButtonStyle = buttonStyle.copyWith(color: Colors.black, shadows: [
    Shadow(
      blurRadius: 5.0,
      color: Color(0x11000000),
      offset: Offset(0.0, 0.0),
    ),
  ]);

  /// Main heading
  static Text h1(String text) {
    return Text(text, style: h1Style);
  }

  /// Second heading
  static Text h2(String text) {
    return Text(text, style: h2Style);
  }

  /// Third heading
  static Text h3(String text) {
    return Text(text, style: h3Style);
  }

  /// Fourth heading
  static Text h4(String text) {
    return Text(text, style: h4Style);
  }

  /// Paragraph
  static Text p(String text) {
    return Text(text, style: pStyle);
  }

  /// Button text
  static Text button(String text) {
    return Text(text, style: buttonStyle);
  }

  //----------------------------------------

  /// Returns a cuisine icon
  static Widget getCuisineIcon(CuisineType type, {double width = 32, double height = 32}) {
    return Image(
      image: AssetImage(cuisineTypeDescriptions[type].iconPath),
      width: width,
      height: height,
      color: null,
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
    );
  }
}
