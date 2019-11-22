import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/menu/menu.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_category.dart';

/// Visual representation of the Menu class
class MenuView extends StatelessWidget {
  final Menu menu;

  MenuView({
    Key key,
    @required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index < menu.categories.length) {
            return MenuViewCategory(
              menuCategory: menu.categories[index],
            );
          }
          return null;
        },
      ),
    );
  }
}
