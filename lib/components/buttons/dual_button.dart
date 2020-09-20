import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablethings/components/clip_shadow_path.dart';
import 'package:tablethings/components/clippers/inverted_rounded_rectangle.dart';
import 'base_button.dart';
import 'single_button.dart';
export 'button_properties.dart';

/// A widget with two single buttons next to each other. To leave one button out, just set properties to null
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

  bool eitherPropertyIsNull() {
    return leftButtonProperties == null || rightButtonProperties == null;
  }

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
            boxShadow: eitherPropertyIsNull()
                ? null
                : [
                    BoxShadow(
                      color: Color(0x66000000),
                      offset: Offset(0.0, 0.0),
                      blurRadius: 5,
                    ),
                  ],
          ),
          child: _getClipContainer(
            child: Stack(
              children: () {
                // Check right and left button render order to fix shadows (yes it's stupid)
                if (!eitherPropertyIsNull()) {
                  return [
                    Row(
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
                    )
                  ];
                }

                var right = Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                    Flexible(
                      flex: 1,
                      child: _getRightButton(),
                    ),
                  ],
                );

                var left = Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: _getLeftButton(),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                );

                return leftButtonProperties == null ? [right, left] : [left, right];
              }(),
            ),
          ),
        ),
      ),
    );
  }

  /// Clip only when both buttons are present
  Widget _getClipContainer({Widget child}) {
    if (eitherPropertyIsNull()) {
      return Container(
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
      child: child,
    );
  }

  Widget _getLeftButton() {
    return Stack(
      children: () {
        List<Widget> builder = List();

        if (leftButtonProperties != null) {
          builder.add(SingleButton(
            properties: leftButtonProperties.copyWith(
              shadowColor: eitherPropertyIsNull() ? leftButtonProperties.shadowColor : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: eitherPropertyIsNull() ? leftButtonProperties.borderRadius.topLeft : Radius.zero,
                bottomLeft: Radius.zero,
                topRight: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? leftButtonProperties.borderRadius.topRight : Radius.zero,
                bottomRight:
                    properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? Radius.zero : leftButtonProperties.borderRadius.bottomRight,
              ),
            ),
          ));
        }

        // Right button's arc
        if (rightButtonProperties != null) {
          builder.add(Positioned(
            right: 0,
            top: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? 0 : null,
            bottom: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? null : 0,
            width: 32,
            height: 32,
            child: ClipShadowPath(
              shadow: Shadow(
                blurRadius: 5,
                color: rightButtonProperties.shadowColor,
              ),
              clipper: InvertedRRectClipper(
                topRight: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? Radius.circular(32.0) : Radius.zero,
                bottomRight: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? Radius.zero : Radius.circular(32.0),
              ),
              child: Container(
                color: rightButtonProperties.colors.first,
              ),
            ),
          ));
        }

        return builder;
      }(),
    );
  }

  Widget _getRightButton() {
    return Stack(
      children: () {
        List<Widget> builder = List();

        if (rightButtonProperties != null) {
          builder.add(SingleButton(
            properties: rightButtonProperties.copyWith(
              shadowColor: eitherPropertyIsNull() ? rightButtonProperties.shadowColor : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? Radius.zero : rightButtonProperties.borderRadius.topLeft,
                bottomLeft:
                    properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? rightButtonProperties.borderRadius.bottomLeft : Radius.zero,
                topRight: eitherPropertyIsNull() ? rightButtonProperties.borderRadius.topRight : Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
          ));
        }

        // Left button's arc
        if (leftButtonProperties != null) {
          builder.add(Positioned(
            left: 0,
            bottom: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? 0 : null,
            top: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? null : 0,
            width: 32,
            height: 32,
            child: ClipShadowPath(
              shadow: Shadow(
                blurRadius: 5,
                color: leftButtonProperties.shadowColor,
              ),
              clipper: InvertedRRectClipper(
                topLeft: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? Radius.zero : Radius.circular(32.0),
                bottomLeft: properties.separatorDirection == DualButtonSeparatorDirection.rightHand ? Radius.circular(32.0) : Radius.zero,
              ),
              child: Container(
                color: leftButtonProperties.colors.last,
              ),
            ),
          ));
        }

        return builder;
      }(),
    );
  }
}
