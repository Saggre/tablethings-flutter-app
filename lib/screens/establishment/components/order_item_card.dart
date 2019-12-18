import 'package:flutter/widgets.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/order/order_item.dart';
import 'package:tablething/util/text_factory.dart';
import 'dropdown_menu.dart';
import 'menu_view/menu_view_item.dart';
import 'card_base.dart';

class OrderItemCard extends StatelessWidget {
  final Establishment establishment;
  final OrderItem orderItem;
  final DropdownMenuController controller;

  const OrderItemCard({Key key, this.establishment, this.orderItem, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardBase(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
          ),
          TextFactory.h2(t('Add to order')),
          Container(
            padding: const EdgeInsets.only(left: 15.0),
            child: MenuViewItem(
              width: MediaQuery.of(context).size.width - 15.0,
              menuItem: orderItem.product,
              establishment: establishment,
              onPress: () {},
              buttonStyle: MenuViewItemButtonStyle.none,
              descriptionPadding: 25.0,
            ),
          ),
          DropdownMenu<int>(
            controller: controller,
            title: t('Quantity'),
            options: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9],
            stringGetter: (value) {
              return value.toString();
            },
          ),
          /*DropdownMenu<int>(
            title: t('Sides'),
            options: <int, String>{
              0: 'Nothing',
            },
          ),*/
        ],
      ),
    );
  }
}
