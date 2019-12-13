import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/colum_builder.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/screens/establishment/components/menu_view/menu_view_item.dart';
import 'package:tablething/services/tablething/menu/menu.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';

class MenuViewCategory extends StatelessWidget {
  final MenuCategory menuCategory;
  final Establishment establishment;
  final Function onAddItem;

  MenuViewCategory({
    Key key,
    @required this.menuCategory,
    @required this.establishment,
    @required this.onAddItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black12,
                ),
              ],
              borderRadius: const BorderRadius.only(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ColumnBuilder(
              itemCount: menuCategory.items.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  color: offWhiteColor,
                  child: MenuViewItem(
                    menuItem: menuCategory.items[index],
                    establishment: establishment,
                    onPress: onAddItem,
                    buttonStyle: MenuViewItemButtonStyle.add,
                    imageRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
