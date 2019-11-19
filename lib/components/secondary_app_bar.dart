import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/theme/theme.dart';

class SecondaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(54.0);

  @override
  SecondaryAppBarState createState() => SecondaryAppBarState();
}

class SecondaryAppBarState extends State<SecondaryAppBar> {
  @override
  @override
  Widget build(BuildContext context) {
    List<IconButton> buttons = [
      IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        tooltip: 'Increase volume by 10',
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        tooltip: 'Increase volume by 10',
        onPressed: () {},
      ),
    ];

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Container(
            height: 56.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buttons[0],
                Text(
                  t('Tablething'),
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300, color: Colors.white),
                ),
                buttons[1],
              ],
            ),
          ),
          color: appColors[0],
          height: 56.0,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
