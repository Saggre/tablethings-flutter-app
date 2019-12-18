import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/menu/menu.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';

enum MenuViewItemButtonStyle { none, add, remove }

class MenuViewItem extends StatelessWidget {
  final MenuItem menuItem;
  final Establishment establishment;
  final Function onPress;
  final MenuViewItemButtonStyle buttonStyle;
  final double descriptionPadding;
  final BorderRadius imageRadius;
  final bool wholeAreaIsClickable;
  final String titlePrefix;
  final double width;

  MenuViewItem({
    Key key,
    @required this.menuItem,
    @required this.establishment,
    @required this.onPress,
    this.buttonStyle = MenuViewItemButtonStyle.none,
    this.descriptionPadding = 10.0,
    this.imageRadius = BorderRadius.zero,
    this.wholeAreaIsClickable = true,
    this.titlePrefix,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!wholeAreaIsClickable || buttonStyle == MenuViewItemButtonStyle.none) {
      return _getMenuItemCard(context);
    }

    return GestureDetector(
      onTap: () {
        // Item added callback
        onPress(menuItem);
      },
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: _getMenuItemCard(context),
        ),
      ),
    );
  }

  Widget _getMenuItemCard(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: width * 0.6,
          child: Padding(
            padding: EdgeInsets.only(
              top: descriptionPadding,
              bottom: descriptionPadding,
              right: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  establishment.formatCurrency(menuItem.price),
                  style: TextFactory.h4Style.copyWith(color: darkThemeColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFactory.h3((titlePrefix ?? '') + menuItem.name),
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                  ],
                ),
                TextFactory.p(menuItem.description),
              ],
            ),
          ),
        ),
        Container(

          width: width * 0.4,
          height: 100.0,
          child: _getImageWithButton(),
        ),
      ],
    );
  }

  _getImageWithButton() {
    return Container(
      alignment: Alignment.topRight,

      decoration: BoxDecoration(
        color: darkThemeColor,
        borderRadius: imageRadius,
      ),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          children: () {
            List<Widget> builder = [
              Expanded(
                child: Container(
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: imageRadius,
                    image: DecorationImage(
                      image: new NetworkImage(menuItem.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ];

            if (buttonStyle != MenuViewItemButtonStyle.none) {
              builder.add(
                Container(
                  width: 42,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        buttonStyle == MenuViewItemButtonStyle.add ? Icons.add : Icons.remove,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (!wholeAreaIsClickable) {
                          onPress(menuItem);
                        }
                      },
                    ),
                  ),
                ),
              );
            }

            return builder;
          }()),
    );
  }
}
