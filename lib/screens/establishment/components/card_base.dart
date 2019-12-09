import 'package:flutter/widgets.dart';
import 'package:tablething/theme/colors.dart';

class CardBase extends StatelessWidget {
  final Widget child;

  CardBase({this.child});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 152.0),
        ),
        ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32.0),
            topLeft: Radius.circular(32.0),
          ),
          child: Container(
            child: child,
            color: offWhiteColor,
          ),
        ),
      ],
    );
  }
}
