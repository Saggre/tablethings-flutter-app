import 'package:flutter/widgets.dart';
import 'package:tablething/theme/colors.dart';

class CardBase extends StatelessWidget {
  final Widget child;

  CardBase({this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(32.0),
        topLeft: Radius.circular(32.0),
      ),
      child: Container(
        color: offWhiteColor,
        child: child,
      ),
    );
  }
}
