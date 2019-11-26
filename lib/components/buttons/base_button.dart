import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'button_properties.dart';
export 'button_properties.dart';

abstract class BaseButton extends StatelessWidget {
  final SingleButtonProperties properties;

  const BaseButton({Key key, @required this.properties}) : super(key: key);

  bool _isIconSet() {
    return properties.iconData != null;
  }

  Widget _getIcon() {
    if (!_isIconSet()) {
      return Container();
    }

    return Icon(
      properties.iconData,
      color: properties.iconColor,
    );
  }

  Widget getButtonContent() {
    List<Widget> widgets = [
      _getIcon(),
      SizedBox(
        width: _isIconSet() ? properties.spacing : 0.0,
      ),
      Text(
        properties.text,
        style: properties.textStyle,
      ),
    ];

    if (properties.iconPosition == ButtonIconPosition.afterText) {
      widgets = widgets.reversed.toList();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}
