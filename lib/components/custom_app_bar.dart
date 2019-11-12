import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// The app's main app bar
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(54.0);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(elevation: 0.0, title: Text("Tablething"));
  }
}
