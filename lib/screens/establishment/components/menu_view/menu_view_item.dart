import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu_item.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_item_text.dart';
import 'package:tablething/theme/colors.dart';

class MenuViewItem extends StatelessWidget with MenuViewItemText {
  final MenuItem menuItem;
  final Establishment establishment;
  final Function onAddItem;

  MenuViewItem({
    Key key,
    @required this.menuItem,
    @required this.establishment,
    @required this.onAddItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: offWhiteColor,
      padding: EdgeInsets.only(
        bottom: 10.0,
        left: 15,
        right: 15,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: getText(menuItem, establishment),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: _getImage(),
            ),
          ),
        ],
      ),
    );
  }

  _getImage() {
    return Container(
      decoration: BoxDecoration(
        color: darkThemeColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                image: DecorationImage(
                  image: new NetworkImage(menuItem.imageUrl),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
          ),
          Container(
            height: 80,
            width: 42,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Item added callback
                  onAddItem(menuItem);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
