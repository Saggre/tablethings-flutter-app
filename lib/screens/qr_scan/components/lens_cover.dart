import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LensCover extends StatelessWidget {
  const LensCover({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color color = Color.fromRGBO(0, 0, 0, 0.7);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {

          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          double boxSizePercentage = 0.8;
          double horizontalSize = width * (1.0 - boxSizePercentage) / 2.0;
          double requiredPadding = (height - width * boxSizePercentage) / 2.0;

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
                      child: Center(child: Text('Scan a QR-code')),
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
    );

  }
}
