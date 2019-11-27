import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/clip_shadow_path.dart';
import 'package:tablething/components/clippers/inverted_rounded_rectangle.dart';

class CornerBar extends StatelessWidget {
  final List<Widget> children;
  final double size;
  final double shadowRadius;

  final Color color;
  final Color shadowColor;

  final EdgeInsets padding;

  const CornerBar({
    @required this.children,
    this.size = 54,
    this.shadowRadius = 5,
    this.color = Colors.grey,
    this.shadowColor = Colors.black26,
    this.padding = EdgeInsets.zero,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: size,
              padding: padding,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(size * 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: shadowRadius,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ],
              ),
            ),
            ClipShadowPath(
              clipper: InvertedRRectClipper(
                topLeft: Radius.circular(size * 0.5),
              ),
              child: Container(
                color: color,
                width: size * 0.5,
                height: size * 0.5,
              ),
              shadow: Shadow(
                blurRadius: shadowRadius,
                color: shadowColor,
              ),
            ),
          ],
        ),
        ClipShadowPath(
          clipper: InvertedRRectClipper(
            topLeft: Radius.circular(size * 0.5),
          ),
          child: Container(
            color: color,
            width: size * 0.5,
            height: size * 0.5,
          ),
          shadow: Shadow(
            blurRadius: shadowRadius,
            color: shadowColor,
          ),
        ),
      ],
    );
  }
}
