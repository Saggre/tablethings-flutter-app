import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/inverted_rounded_rectangle.dart';
import 'package:tablething/theme/theme.dart';
import 'clip_shadow_path.dart';

/// The app's main app bar
class MainAppBar extends StatefulWidget {
  @override
  MainAppBarState createState() => MainAppBarState();
}

class MainAppBarState extends State<MainAppBar> {
  final Color shadowColor = Color(0x44000000);
  final double shadowRadius = 5;
  final double size = 54;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: size,
          width: () {
            return size * 2.0;
          }(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(size * 0.5)),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: Offset(0.0, 0.0),
                blurRadius: shadowRadius,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: size,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _withBackground(IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    tooltip: 'Increase volume by 10',
                    onPressed: () {},
                  )),
                  _withBackground(
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      tooltip: 'Increase volume by 10',
                      onPressed: () {},
                    ),
                    radius: BorderRadius.only(bottomRight: Radius.circular(size * 0.5)),
                  ),
                  ClipShadowPath(
                    clipper: InvertedRRectClipper(
                      topLeft: Radius.circular(size * 0.5),
                    ),
                    child: Container(
                      color: mainThemeColor,
                      width: size,
                      height: size,
                    ),
                    shadow: Shadow(
                      blurRadius: shadowRadius,
                      color: shadowColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size,
              child: ClipShadowPath(
                shadow: Shadow(
                  blurRadius: shadowRadius,
                  color: shadowColor,
                ),
                clipper: InvertedRRectClipper(
                  topLeft: Radius.circular(size * 0.5),
                ),
                child: Container(
                  color: mainThemeColor,
                  width: size,
                  height: size,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _withBackground(Widget child, {BorderRadiusGeometry radius = BorderRadius.zero}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: mainThemeColor,
        borderRadius: radius,
      ),
      child: child,
    );
  }
}
