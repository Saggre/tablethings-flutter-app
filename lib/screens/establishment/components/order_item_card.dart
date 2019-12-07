import 'package:flutter/widgets.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/order/order_item.dart';
import 'dropdown_menu.dart';
import 'menu_view/menu_view_item.dart';

class OrderItemCard extends StatelessWidget {
  final Establishment establishment;
  final OrderItem orderItem;
  final DropdownMenuController controller;

  const OrderItemCard({Key key, this.establishment, this.orderItem, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('OrderItemView'),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 15.0),
          child: MenuViewItem(
            menuItem: orderItem.product,
            establishment: establishment,
            onPress: () {},
            buttonStyle: MenuViewItemButtonStyle.none,
            descriptionPadding: 25.0,
          ),
        ),
        DropdownMenu(
          controller: controller,
          title: t('Määrä'),
          options: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9'],
        ),
        DropdownMenu(
          title: t('Lisuke'),
          options: <String>['Kana'],
        ),
      ],
    );
  }
}
