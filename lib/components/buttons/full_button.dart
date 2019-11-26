import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'base_button.dart';
export 'button_properties.dart';

class FullButton extends BaseButton {
  final SingleButtonProperties properties;

  const FullButton({
    Key key,
    @required this.properties,
  }) : super(key: key, properties: properties);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: properties.height,
      decoration: BoxDecoration(
        gradient: properties.gradient,
        borderRadius: properties.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(0.0, 1.0),
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: properties.onPressed, child: Center(child: getButtonContent())),
      ),
    );
  }
}
