import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_item_text.dart';
import 'package:tablething/theme/colors.dart';

enum MenuViewItemButtonStyle { none, add, remove }

class MenuViewItem extends StatelessWidget {
  final MenuItem menuItem;
  final Establishment establishment;
  final Function onPress;
  final MenuViewItemButtonStyle buttonStyle;
  final double descriptionPadding;
  final BorderRadius imageRadius;
  final bool wholeAreaIsClickable;

  MenuViewItem({
    Key key,
    @required this.menuItem,
    @required this.establishment,
    @required this.onPress,
    this.buttonStyle = MenuViewItemButtonStyle.none,
    this.descriptionPadding = 10.0,
    this.imageRadius = BorderRadius.zero,
    this.wholeAreaIsClickable = true,
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
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: descriptionPadding,
            bottom: descriptionPadding,
          ),
          child: MenuViewItemText(
            menuItem: menuItem,
            establishment: establishment,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 15.0),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          width: MediaQuery.of(context).size.width * 0.4,
          child: ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 80.0,
            ),
            child: _getImageWithButton(),
          ),
        ),
      ],
    );
  }

  _getImageWithButton() {
    return Container(
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
