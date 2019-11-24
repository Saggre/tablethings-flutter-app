import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/clip_shadow_path.dart';
import 'package:tablething/components/inverted_rounded_rectangle.dart';
import 'package:tablething/components/layered_button_group/layered_button_group_menu.dart';
import 'package:tablething/theme/theme.dart';

class TabbedFoodMenu extends StatelessWidget implements LayeredButtonGroupMenu {
  const TabbedFoodMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainThemeColor,
      child: SizedBox(
        height: 64,
        child: Container(
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
                  flex: 5,
                  child: Container(
                    decoration: _getDecoration(Colors.grey[200]),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 4,
                          child: Container(
                            decoration: _getDecoration(Colors.white),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x66000000),
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 5,
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        colors: [
                                          darkThemeColorGradient,
                                          darkThemeColor,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    child: ClipShadowPath(
                                      clipper: InvertedRRectClipper(
                                        bottomLeft: Radius.circular(32.0),
                                      ),
                                      shadow: Shadow(
                                        blurRadius: 5.0,
                                        color: Color(0x66000000),
                                      ),
                                      child: Container(
                                        color: darkThemeColor,
                                      ),
                                    ),
                                  ), //Third rightmost button
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(), // Second rightmost button
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(), // Rightmost button
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(Color backgroundColor) {
    return BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
      boxShadow: [
        BoxShadow(
          color: Color(0x66000000),
          offset: Offset(0.0, 0.0),
          blurRadius: 5,
        ),
      ],
      color: backgroundColor,
    );
  }

  Widget _getWavyTile({Color leftColor, Color rightColor, Color backgroundColor}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [
            0.49999,
            0.50001,
          ],
          colors: [
            leftColor,
            rightColor,
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32.0),
            bottomLeft: Radius.circular(32.0),
          ),
        ),
      ),
    );
  }
}
