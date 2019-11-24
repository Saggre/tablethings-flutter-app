import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/clip_shadow_path.dart';
import 'package:tablething/components/inverted_rounded_rectangle.dart';
import 'package:tablething/components/layered_button_group/layered_button_group_menu.dart';
import 'package:tablething/theme/theme.dart';

class TabbedFoodMenu extends StatefulWidget implements LayeredButtonGroupMenu {
  const TabbedFoodMenu({
    Key key,
  }) : super(key: key);

  @override
  _TabbedFoodMenuState createState() => _TabbedFoodMenuState();
}

class _TabbedFoodMenuState extends State<TabbedFoodMenu> {
  _TabbedFoodMenuState({this.selectedTabIndex = 0});

  int selectedTabIndex;
  Duration animationDuration = Duration(milliseconds: 80);
  Curve animationCurve = Curves.easeInOutCubic;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double tabWidth = width / 6.0;
    return Container(
      color: mainThemeColor,
      child: SizedOverflowBox(
        size: Size(width, 64),
        child: Container(
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
                AnimatedContainer(
                  duration: animationDuration,
                  curve: animationCurve,
                  width: () {
                    switch (selectedTabIndex) {
                      case 0:
                        return tabWidth * 5;
                      case 1:
                        return tabWidth * 5;
                      case 2:
                        return tabWidth * 5;
                      case 3:
                        return tabWidth * 3;
                      default:
                        return tabWidth * 5;
                    }
                  }(),
                  decoration: _getDecoration(Colors.grey[200]),
                  child: Row(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: animationDuration,
                        curve: animationCurve,
                        width: () {
                          switch (selectedTabIndex) {
                            case 0:
                              return tabWidth * 4;
                            case 1:
                              return tabWidth * 4;
                            case 2:
                              return tabWidth * 2;
                            case 3:
                              return tabWidth * 2;
                            default:
                              return tabWidth * 4;
                          }
                        }(),
                        decoration: _getDecoration(Colors.white),
                        child: Row(
                          children: <Widget>[
                            AnimatedContainer(
                              duration: animationDuration,
                              curve: animationCurve,
                              width: selectedTabIndex == 0 ? tabWidth * 3 : tabWidth,
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
                              child: GestureDetector(
                                onTap: () {
                                  setTabIndex(0);
                                },
                              ),
                            ),
                            AnimatedContainer(
                              duration: animationDuration,
                              curve: animationCurve,
                              width: selectedTabIndex == 1 ? tabWidth * 3 : tabWidth,
                              alignment: Alignment.bottomLeft,
                              child: Stack(
                                children: <Widget>[
                                  ClipShadowPath(
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
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        setTabIndex(1);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: animationDuration,
                        curve: animationCurve,
                        width: selectedTabIndex == 2 ? tabWidth * 3 : tabWidth,
                        child: GestureDetector(
                          onTap: () {
                            setTabIndex(2);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: animationDuration,
                  curve: animationCurve,
                  width: selectedTabIndex == 3 ? tabWidth * 3 : tabWidth,
                  child: GestureDetector(
                    onTap: () {
                      setTabIndex(3);
                    },
                  ), // Rightmost button
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setTabIndex(int index) {
    print("Settting tab index: " + index.toString());
    setState(() {
      selectedTabIndex = index;
    });
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
}
