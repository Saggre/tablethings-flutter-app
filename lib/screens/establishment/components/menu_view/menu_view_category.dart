import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/colum_builder.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu_category.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_item.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';

class MenuViewCategory extends StatelessWidget {
  final MenuCategory menuCategory;
  final Establishment establishment;

  MenuViewCategory({
    Key key,
    @required this.menuCategory,
    @required this.establishment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return Container(
      color: Colors.green,
      height: 1000,
    );*/

    return Container(
      color: offWhiteColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 12,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black12,
                ),
              ],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32.0),
                topLeft: Radius.circular(32.0),
              ),
              color: offWhiteColor,
            ),
            height: 64.0,
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.horizontal,
              children: <Widget>[
                Text(
                  menuCategory.name,
                  style: TextFactory.h2Style,
                )
              ],
            ),
          ),
          ColumnBuilder(
            itemCount: menuCategory.items.length,
            itemBuilder: (BuildContext context, int index) {
              return MenuViewItem(
                menuItem: menuCategory.items[index],
                establishment: establishment,
              );
            },
          ),
        ],
      ),
    );
  }
}
