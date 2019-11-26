import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'base_button.dart';
import 'full_button.dart';
export 'button_properties.dart';

class DualButton extends StatelessWidget {
  final DualButtonProperties properties;
  final SingleButtonProperties leftButtonProperties;
  final SingleButtonProperties rightButtonProperties;

  const DualButton({
    Key key,
    @required this.properties,
    this.leftButtonProperties,
    this.rightButtonProperties,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedOverflowBox(
        size: Size(properties.width, 64),
        child: Container(
          width: properties.width,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(0.0, 0.0),
                blurRadius: 5,
              ),
            ],
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: _getLeftButton(),
                ),
                Flexible(
                  flex: 1,
                  child: _getRightButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLeftButton() {
    if (leftButtonProperties == null) {
      return Container();
    }

    return FullButton(
      properties: leftButtonProperties,
    );
  }

  Widget _getRightButton() {
    if (rightButtonProperties == null) {
      return Container();
    }

    return FullButton(
      properties: rightButtonProperties,
    );
  }
}
