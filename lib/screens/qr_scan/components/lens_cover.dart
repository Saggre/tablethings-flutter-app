import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LensCover extends StatelessWidget {
  const LensCover({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double boxSizePercentage = 0.8;
    double horizontalSize = width * (1.0 - boxSizePercentage) / 2.0;
    double requiredPadding = (height - width * boxSizePercentage) / 2.0;

    Color color = Color.fromRGBO(0, 0, 0, 0.7);

    return Row(
      children: <Widget>[
        Container(
          width: horizontalSize,
          color: color,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                height: requiredPadding,
                color: color,
                child: Center(child: TextFactory.button(t('Scan a QR-code'.i18n))),
              ),
              Expanded(
                  child: Container(
                color: Colors.transparent,
              )),
              Container(
                height: requiredPadding,
                color: color,
              ),
            ],
          ),
        ),
        Container(
          width: horizontalSize,
          color: color,
        ),
      ],
    );
  }
}
