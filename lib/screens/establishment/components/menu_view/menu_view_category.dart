import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/colum_builder.dart';
import 'package:tablething/models/establishment/menu/menu_category.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_item.dart';

class MenuViewCategory extends StatelessWidget {
  final MenuCategory menuCategory;

  MenuViewCategory({
    Key key,
    @required this.menuCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return Container(
      color: Colors.green,
      height: 1000,
    );*/

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ColumnBuilder(
        itemCount: menuCategory.items.length,
        itemBuilder: (BuildContext context, int index) {
          return MenuViewItem(
            menuItem: menuCategory.items[index],
          );
        },
      ),
    );
  }
}
