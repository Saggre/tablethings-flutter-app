import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/corner_bar.dart';
import 'package:tablething/theme/theme.dart';

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
    return CornerBar(
      color: mainThemeColor,
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
