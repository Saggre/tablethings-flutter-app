import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_category.dart';

/// Visual representation of the Menu class
class MenuView extends StatelessWidget {
  final Menu menu;
  final Establishment establishment;

  MenuView({
    Key key,
    @required this.menu,
    @required this.establishment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index < menu.categories.length) {
            return MenuViewCategory(
              menuCategory: menu.categories[index],
              establishment: establishment,
            );
          }
          return null;
        },
      ),
    );
  }
}
