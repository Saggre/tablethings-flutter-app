import 'package:flutter/material.dart';

final mainThemeColor = Color(0xFFC18C5D);

final appColors = [Color(0xFF257AA6), Color(0xFF00BDAA), Color(0xFF00A6BD)];

final buttonGradient = LinearGradient(
  colors: [
    appColors[1],
    appColors[2],
  ],
  begin: FractionalOffset.centerLeft,
  end: FractionalOffset.centerRight,
);
