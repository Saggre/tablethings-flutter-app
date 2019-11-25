import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/clip_shadow_path.dart';
import 'package:tablething/components/inverted_rounded_rectangle.dart';
import 'package:tablething/components/layered_button_group/layered_button_group_menu.dart';
import 'package:tablething/theme/theme.dart';

class TabbedMenuOptions {
  final Widget truncated;
  final Widget expanded;

  TabbedMenuOptions({this.truncated, this.expanded});
}

class TabbedFoodMenu extends StatefulWidget implements LayeredButtonGroupMenu {
  final TabbedMenuOptions firstTabOptions;
  final TabbedMenuOptions secondTabOptions;
  final TabbedMenuOptions thirdTabOptions;
  final TabbedMenuOptions fourthTabOptions;

  const TabbedFoodMenu({
    Key key,
    @required this.firstTabOptions,
    @required this.secondTabOptions,
    @required this.thirdTabOptions,
    @required this.fourthTabOptions,
  }) : super(key: key);

  @override
  _TabbedFoodMenuState createState() => _TabbedFoodMenuState(
        firstTabOptions: firstTabOptions,
        secondTabOptions: secondTabOptions,
        thirdTabOptions: thirdTabOptions,
        fourthTabOptions: fourthTabOptions,
      );
}

class _TabbedFoodMenuState extends State<TabbedFoodMenu> {
  final TabbedMenuOptions firstTabOptions;
  final TabbedMenuOptions secondTabOptions;
  final TabbedMenuOptions thirdTabOptions;
  final TabbedMenuOptions fourthTabOptions;

  _TabbedFoodMenuState({
    this.firstTabOptions,
    this.secondTabOptions,
    this.thirdTabOptions,
    this.fourthTabOptions,
  });

  int selectedTabIndex;
  Duration animationDuration = Duration(milliseconds: 200);
  Curve animationCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double tabWidth = width / 6.0;
    return Container(
      color: mainThemeColor,
      child: SizedOverflowBox(
        size: Size(width, 64),
        child: Container(
          width: width,
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
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: width,
                    child: _getTouch(3, tabWidth),
                  ),
                ),
                Positioned(
                  left: tabWidth * 1.5,
                  child: AnimatedContainer(
                    duration: animationDuration,
                    curve: animationCurve,
                    width: selectedTabIndex == 3 ? tabWidth * 1.5 : tabWidth * 3.5,
                    alignment: Alignment.centerRight,
                    decoration: _getDecoration(Colors.grey[200]),
                    child: _getTouch(2, tabWidth),
                  ),
                ),
                AnimatedPositioned(
                  duration: animationDuration,
                  curve: animationCurve,
                  left: selectedTabIndex == 0 ? 0 : tabWidth * 0,
                  height: 64,
                  child: AnimatedContainer(
                    duration: animationDuration,
                    curve: animationCurve,
                    width: selectedTabIndex == 0 ? tabWidth * 3.5 : tabWidth * 1.5,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          darkThemeColorGradient,
                          darkThemeColor,
                        ],
                      ),
                    ),
                    child: _getTouch(0, tabWidth),
                  ),
                ),
                AnimatedPositioned(
                  left: () {
                    if (selectedTabIndex == 0) {
                      return tabWidth * 3;
                    }
                    return tabWidth * 1;
                  }(),
                  duration: animationDuration,
                  curve: animationCurve,
                  child: AnimatedContainer(
                    duration: animationDuration,
                    curve: animationCurve,
                    width: () {
                      if (selectedTabIndex == 1) {
                        return tabWidth * 3;
                      }

                      return tabWidth * 1;
                    }(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(32.0), bottomLeft: Radius.circular(32.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66000000),
                          offset: Offset(0.0, 0.0),
                          blurRadius: 5,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                    child: _getTouch(1, tabWidth),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTouch(int tabIndex, double tabWidth) {
    TabbedMenuOptions options;

    switch (tabIndex) {
      case 0:
        options = firstTabOptions;
        break;
      case 1:
        options = secondTabOptions;
        break;
      case 2:
        options = thirdTabOptions;
        break;
      case 3:
        options = fourthTabOptions;
        break;
    }

    return GestureDetector(
      onTap: () {
        setTabIndex(tabIndex);
      },
      child: AnimatedContainer(
        duration: animationDuration,
        curve: animationCurve,
        padding: EdgeInsets.symmetric(horizontal: 7),
        width: selectedTabIndex == tabIndex ? tabWidth * 3 : tabWidth,
        height: 64,
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            AnimatedOpacity(
              duration: animationDuration,
              curve: animationCurve,
              opacity: selectedTabIndex == tabIndex ? 1 : 0,
              child: Center(child: options.expanded),
            ),
            AnimatedOpacity(
              duration: animationDuration,
              curve: animationCurve,
              opacity: selectedTabIndex == tabIndex ? 0 : 1,
              child: Center(child: options.truncated),
            ),
          ],
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
      borderRadius: BorderRadius.only(topRight: Radius.circular(32.0)),
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
