import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'base_button.dart';
import 'single_button.dart';
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

    return Container(
      color: rightButtonProperties != null ? rightButtonProperties.colors.first : Colors.transparent,
      child: SingleButton(
        properties: leftButtonProperties.copyWith(
          shadowColor: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            bottomLeft: Radius.zero,
            topRight: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? leftButtonProperties.borderRadius.topRight : Radius.zero,
            bottomRight: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? Radius.zero : leftButtonProperties.borderRadius.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _getRightButton() {
    if (rightButtonProperties == null) {
      return Container();
    }

    return Container(
      color: leftButtonProperties != null ? leftButtonProperties.colors.last : Colors.transparent,
      child: SingleButton(
        properties: rightButtonProperties.copyWith(
          shadowColor: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? Radius.zero : rightButtonProperties.borderRadius.topLeft,
            bottomLeft: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? rightButtonProperties.borderRadius.bottomLeft : Radius.zero,
            topRight: Radius.zero,
            bottomRight: Radius.zero,
          ),
        ),
      ),
    );
  }
}
