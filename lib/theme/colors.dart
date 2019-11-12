import 'package:flutter/material.dart';

const MAIN_COLOR = Color(0xFF3186E3);
const MAIN_COLOR_DARK = Color(0xFF1D36C4);
const BACKGROUND_COLOR = Color(0xff1a2328);
const CARD_COLOR = Color(0xff404b60);
const GRAPH_COLORS = [Color(0x333186e3), Color(0x33ff0000)];

const BUTTON_GRADIENT = LinearGradient(
  colors: [
    MAIN_COLOR,
    MAIN_COLOR_DARK,
  ],
  begin: FractionalOffset.centerLeft,
  end: FractionalOffset.centerRight,
);
