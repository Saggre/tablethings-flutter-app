import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:tablething/components/main_app_bar.dart';

class PaymentMethodScreen extends StatelessWidget {
  PaymentMethodScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      color: mainThemeColor,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
