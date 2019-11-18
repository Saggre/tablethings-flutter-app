import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/theme/theme.dart';

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
    return Stack(
      children: <Widget>[
        Container(
          // Background
          child: Center(
            child: Text(
              t('Tablething'),
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          color: appColors[0],
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
        ),

        Container(), // Required some widget in between to float AppBar

        Positioned(
          // To take AppBar Size only
          top: 100.0,
          left: 10.0,
          right: 10.0,
          child: AppBar(
            backgroundColor: Colors.white,
            leading: Icon(
              Icons.menu,
              color: appColors[0],
            ),
            primary: false,
            title: TextField(
                decoration: InputDecoration(
              hintText: t('Search'),
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            )),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search, color: appColors[0]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.my_location, color: appColors[0]),
                onPressed: () {},
              )
            ],
          ),
        )
      ],
    );
  }
}
