import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/theme/theme.dart';

/// The app's main app bar
class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(54.0);

  @override
  MainAppBarState createState() => MainAppBarState();
}

enum MainAppBarMode { primary, secondary }

class MainAppBarState extends State<MainAppBar> {
  MainAppBarMode _appBarMode = MainAppBarMode.primary;

  @override
  Widget build(BuildContext context) {
    double expandedHeight = 110.0;

    List<IconButton> buttons = [
      IconButton(
        icon: Icon(
          Icons.menu,
          color: appColors[0],
        ),
        tooltip: 'Increase volume by 10',
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(
          Icons.search,
          color: appColors[0],
        ),
        tooltip: 'Increase volume by 10',
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(
          Icons.my_location,
          color: appColors[0],
        ),
        tooltip: 'Increase volume by 10',
        onPressed: () {
          setState(() {
            if (_appBarMode == MainAppBarMode.primary) {
              _appBarMode = MainAppBarMode.secondary;
            } else if (_appBarMode == MainAppBarMode.secondary) {
              _appBarMode = MainAppBarMode.primary;
            }
          });
        },
      )
    ];

    return Stack(
      children: <Widget>[
        Container(
          height: expandedHeight + 30,
          alignment: Alignment.topCenter,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Container(
              alignment: Alignment.center,
              height: 56.0,
              child: Center(
                child: Text(
                  t('Tablething'),
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w300, color: Colors.white),
                ),
              ),
            ),
            color: appColors[0],
            height: () {
              if (_appBarMode == MainAppBarMode.primary) {
                return expandedHeight;
              }

              return 56.0;
            }(),
            width: MediaQuery.of(context).size.width,
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          top: () {
            if (_appBarMode == MainAppBarMode.primary) {
              return expandedHeight - 30;
            }

            return 0.0;
          }(),
          left: 10.0,
          right: 10.0,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            opacity: () {
              return _appBarMode == MainAppBarMode.primary ? 1.0 : 0.0;
            }(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Color(0x66000000),
                  offset: Offset(0.0, 1.0),
                  blurRadius: 5,
                ),
              ]),
              height: 56,
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  buttons[0],
                  Flexible(
                      child: TextField(
                          decoration: InputDecoration(
                    hintText: t('Search'),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ))),
                  buttons[1],
                  buttons[2]
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
