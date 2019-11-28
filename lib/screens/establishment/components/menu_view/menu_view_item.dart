import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/clip_shadow_path.dart';
import 'package:tablething/components/clippers/inverted_rounded_rectangle.dart';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFactory.h3(menuItem.name),
                    Padding(padding: EdgeInsets.only(right: 10.0)),
                    Text(
                      menuItem.price,
                      style: TextFactory.h3Style.copyWith(color: darkThemeColor),
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
            flex: 4,
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
                  // TODO add to ostoskori
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
