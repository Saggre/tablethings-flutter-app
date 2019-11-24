import 'package:flutter/material.dart';

enum Overflow { visible, hidden }

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;
  final Overflow overflow;

  ClipShadowPath({
    @required this.shadow,
    @required this.clipper,
    @required this.child,
    this.overflow = Overflow.hidden,
  });

  @override
  Widget build(BuildContext context) {
    return _getOverflow(
      CustomPaint(
        painter: _ClipShadowShadowPainter(
          clipper: this.clipper,
          shadow: this.shadow,
        ),
        child: ClipPath(child: child, clipper: this.clipper),
      ),
    );
  }

  Widget _getOverflow(Widget overflown) {
    if (overflow == Overflow.hidden) {
      return ClipRect(
        child: overflown,
      );
    }

    return overflown;
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({@required this.shadow, @required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
