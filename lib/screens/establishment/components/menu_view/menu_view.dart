import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/colum_builder.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_category.dart';
import 'package:tablething/services/tablething/menu/menu.dart';

/// Visual representation of the Menu class
class MenuView extends StatelessWidget {
  final Menu menu;
  final Establishment establishment;
  final Function onAddItem;

  MenuView({
    Key key,
    @required this.menu,
    @required this.establishment,
    @required this.onAddItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColumnBuilder(
      itemCount: menu.categories.length,
      itemBuilder: (BuildContext context, int index) {
        return MenuViewCategory(
          menuCategory: menu.categories[index],
          establishment: establishment,
          onAddItem: onAddItem,
        );
      },
    );
  }
}
