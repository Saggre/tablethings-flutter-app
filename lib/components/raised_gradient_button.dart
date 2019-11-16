import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/theme/theme.dart';

enum ButtonIconPosition { beforeText, afterText }

class RaisedGradientButton extends StatelessWidget {
  final IconData iconData;
  final ButtonIconPosition iconPosition;
  final Color iconColor;
  final String text;
  final double spacing;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    this.iconData,
    this.iconPosition = ButtonIconPosition.afterText,
    this.iconColor = Colors.white,
    this.text = '',
    this.gradient,
    this.spacing = 10.0,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  bool _isIconSet() {
    return iconData != null;
  }

  Widget _getIcon() {
    if (!_isIconSet()) {
      return Container();
    }

    return Icon(
      iconData,
      color: iconColor,
    );
  }

  Widget _getButtonContent() {
    List<Widget> widgets = [
      _getIcon(),
      SizedBox(
        width: _isIconSet() ? spacing : 0.0,
      ),
      Text(
        text,
        style: defaultButtonStyle,
      ),
    ];

    if (iconPosition == ButtonIconPosition.afterText) {
      widgets = widgets.reversed.toList();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 56.0,
      decoration: BoxDecoration(gradient: gradient, boxShadow: [
        BoxShadow(
          color: Color(0x66000000),
          offset: Offset(0.0, 1.0),
          blurRadius: 5,
        ),
      ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onPressed, child: Center(child: _getButtonContent())),
      ),
    );
  }
}
