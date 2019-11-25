import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';

class LayeredButtonGroup extends StatelessWidget {
  final String buttonText;
  final Widget subMenu;
  final Function onTap;

  const LayeredButtonGroup({
    Key key,
    @required this.subMenu,
    @required this.buttonText,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(0.0, 0.0),
                blurRadius: 5,
              ),
            ],
            color: mainThemeColor,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 64,
                child: GestureDetector(
                  onTap: () => onTap(),
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: TextFactory.button(buttonText),
                    ),
                  ),
                ),
              ),
              subMenu,
            ],
          ),
        ),
      ],
    );
  }
}
