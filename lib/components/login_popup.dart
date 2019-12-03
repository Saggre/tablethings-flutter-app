import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/theme/theme.dart';

class LoginPopup extends StatelessWidget {
  final Function onCloseTapped;

  const LoginPopup({
    Key key,
    @required this.onCloseTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(32.0),
      child: Container(
        color: offWhiteColor,
        child: Container(),
      ),
    );
  }
}
