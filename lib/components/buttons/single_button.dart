import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/drag_tab.dart';
import 'base_button.dart';
export 'button_properties.dart';

class SingleButton extends BaseButton {
  final SingleButtonProperties properties;

  const SingleButton({
    Key key,
    @required this.properties,
  }) : super(key: key, properties: properties);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: properties.height,
      decoration: _getDecoration(),
      child: Stack(
        children: () {
          List<Widget> builder = [
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: properties.onPressed, child: Center(child: getButtonContent())),
            ),
          ];

          if (properties.enableDragTab) {
            builder.add(DragTab(
              width: 54, // TODO variable width
            ));
          }

          return builder;
        }(),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    var decoration = BoxDecoration(
      gradient: properties.colors.length < 2
          ? null
          : LinearGradient(
              colors: properties.colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
      color: properties.colors.length == 1 ? properties.colors[0] : null,
      borderRadius: properties.borderRadius,
      boxShadow: properties.shadowColor == Colors.transparent
          ? null
          : [
              BoxShadow(
                color: properties.shadowColor,
                offset: Offset(0.0, 0.0),
                blurRadius: 5,
              ),
            ],
    );

    return decoration;
  }
}
