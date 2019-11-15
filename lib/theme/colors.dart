import 'package:flutter/material.dart';

const appColors = [Color(0xFF257AA6), Color(0xFF00BDAA), Color(0xFF00A6BD)];

final buttonGradient = LinearGradient(
  colors: [
    appColors[1],
    appColors[2],
  ],
  begin: FractionalOffset.centerLeft,
  end: FractionalOffset.centerRight,
);
