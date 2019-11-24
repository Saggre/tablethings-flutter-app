import 'dart:ui';
import 'package:flutter/widgets.dart';

class InvertedRRectClipper extends CustomClipper<Path> {
  final Radius topLeft;
  final Radius bottomLeft;
  final Radius topRight;
  final Radius bottomRight;

  InvertedRRectClipper({this.topLeft = Radius.zero, this.bottomLeft = Radius.zero, this.topRight = Radius.zero, this.bottomRight = Radius.zero});

  @override
  Path getClip(Size size) {
    final path = Path();

    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    path.addRRect(RRect.fromRectAndCorners(rect, topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight));
    //path.addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width * 0.5));
    path.addRect(rect);

    path.fillType = PathFillType.evenOdd;

    path.close();
    return path;
  }

  @override
  bool shouldReclip(InvertedRRectClipper oldClipper) => false;
}
