import 'dart:ui';
import 'package:flutter/widgets.dart';

class InvertedRRectClipper extends CustomClipper<Path> {
  final Radius topLeft;
  final Radius bottomLeft;
  final Radius topRight;
  final Radius bottomRight;

  final double topMargin;
  final double bottomMargin;
  final double leftMargin;
  final double rightMargin;

  InvertedRRectClipper({
    this.topLeft = Radius.zero,
    this.bottomLeft = Radius.zero,
    this.topRight = Radius.zero,
    this.bottomRight = Radius.zero,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
    this.leftMargin = 0.0,
    this.rightMargin = 0.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    Rect fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect rect = Rect.fromLTWH(leftMargin, topMargin, size.width - leftMargin - rightMargin, size.height - topMargin - bottomMargin);
    path.addRRect(RRect.fromRectAndCorners(rect, topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight));
    path.addRect(fullRect);

    path.fillType = PathFillType.evenOdd;

    path.close();
    return path;
  }

  @override
  bool shouldReclip(InvertedRRectClipper oldClipper) => false;
}
