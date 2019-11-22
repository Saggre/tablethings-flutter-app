import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/menu/menu_item.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';

class MenuViewItem extends StatelessWidget {
  final MenuItem menuItem;

  MenuViewItem({
    Key key,
    @required this.menuItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFactory.h4(menuItem.name),
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Text(
                      menuItem.price,
                      style: TextFactory.h4Style.copyWith(color: appColors[0]),
                    ),
                  ],
                ),
                TextFactory.p(menuItem.description),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Center(
                child: _getImage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getImage() {
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: new NetworkImage(menuItem.imageUrl),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.rectangle,
      ),
    );
  }
}
