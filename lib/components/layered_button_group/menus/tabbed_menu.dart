import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/layered_button_group/layered_button_group_menu.dart';
import 'package:tablething/theme/theme.dart';

class TabbedMenu extends StatelessWidget implements LayeredButtonGroupMenu {
  const TabbedMenu({
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
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(32.0)),
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
                  child: _getWavyTile(
                    leftColor: darkThemeColor,
                    rightColor: Colors.grey[200],
                    backgroundColor: Colors.white,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[300],
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(32.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
